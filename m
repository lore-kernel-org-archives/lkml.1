Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYCHUIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYCHUIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 15:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYCHUI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 15:08:29 -0500
Received: from smtp2-g19.free.fr ([212.27.42.28]:51057 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbYCHUI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 15:08:28 -0500
Message-ID: <47D2F23A.4020103@free.fr>
Date: Sat, 08 Mar 2008 21:08:26 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080129 Iceape/1.1.8 (Debian-1.1.8-2)
MIME-Version: 1.0
To: mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  mass storage : emulation of sat scsi_pass_thru with
 ATACB
References: <47D2CD95.9070701@free.fr> <20080308183125.GB2820@one-eyed-alien.net>
In-Reply-To: <20080308183125.GB2820@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

thanks for your comments

Matthew Dharm wrote:
> Why are you using an initializer instead of a new protocol code?
Because using a new protocol code means I need to patch all the place 
where there is a comparison between us->subclass and US_SC_SCSI.
After all I am US_SC_SCSI with a special case for ATA12 & ATA16 commands.
I don't translate all scsi to atacb (that's what does US_SC_ISD200).

> 
> Most of this should probably be moved into it's own file, just like all of
> the other protocol handlers.
Ok, I will move it in another file.
> 
> Actually, why do you even have a separate 'dispatcher' function?  Why not
> just one protocol handler function which checks the command at the top and
> calls invoke_transport there?
What do you means by having a separate 'dispatcher' function?
You means why I have 2 functions emulate_pass_thru_with_atacb and 
usb_stor_transparent_scsi_command_atacb ?
I did 2 functions for having a code more clean.

You suggest something like
void usb_stor_transparent_scsi_command_atacb(struct scsi_cmnd *srb,
                        struct us_data *us)
{
     if (srb->cmnd[0] != ATA_16 && srb->cmnd[0] != ATA_12) {
         usb_stor_invoke_transport(srb, us);
         return;
     }
     copy emulate_pass_thru_with_atacb code here
}

> 
> Also, unless ATACB is a new standard (and I don't think it is, as the
> Cypress datasheet uses the term 'vendor specific'), then your functions
> need renaming.  Instead of 'emulate_pass_thru_with_atacb', how about
> something like 'cypress_atacb' --  since it's already a protocol handler,
> everyone already knows it's for passing commands.
But 'emulate_pass_thru_with_atacb' only handle ATA pass_thru scsi 
commands. It doesn't translate all scsi commands to atacb like 
'cypress_atacb' could suggest.
That's why I put 'usb_stor_transparent_scsi_command_atacb' saying it is 
transparent_scsi_command + atacb support.

Matthieu
