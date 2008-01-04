Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbYADCiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbYADCiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYADCh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:37:57 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:35861 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbYADCh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:37:56 -0500
Message-ID: <477D9C00.8060600@tlinx.org>
Date: Thu, 03 Jan 2008 18:37:52 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>, LKML <linux-kernel@vger.kernel.org>
CC: Robert Hancock <hancockr@shaw.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org
Subject: Re:Believed resolved: SATA kern-buffRd read slow: based on promise
 driver bug
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>	<4777E08C.4000603@shaw.ca>	<4779870E.5070507@tlinx.org>	<20080101015812.59e9ebf0@the-village.bc.nu>	<477BEF8D.8090307@tlinx.org>	<477C2B71.7040504@shaw.ca>	<477C63AA.8080006@tlinx.org> <18300.40661.199761.488061@harpo.it.uu.se>
In-Reply-To: <18300.40661.199761.488061@harpo.it.uu.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Linda Walsh writes:
>  > Robert Hancock wrote:
>  > > Linda Walsh wrote:
>  > >>>> read rate began falling; at 128k block-reads-at-a-time or larger, it 
>  > >>>> drops below 20MB/s (only on buffered SATA).
>  > 
>  > But more importantly -- I notice a chronic error message associate
>  > with this drive that may be causing some or all of the problem:
>  > ---
>  > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
>  > ata1.00: port_status 0x20080000
>  > ata1.00: cmd c8/00:10:30:06:03/00:00:00:00:00/e0 tag 0 cdb 0x0 data 8192 in
>  >          res 50/00:00:3f:06:03/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
>  > ata1: limiting SATA link speed to 1.5 Gbps
>
>
> Looks like the Promise ASIC SG bug. Apply
> <http://user.it.uu.se/~mikpe/linux/patches/sata_promise/patch-sata_promise-1-asic-sg-bug-fix-v3-2.6.23>
> and let us know if things improve.
>
> /Mikael
>   
---
    Yep!  Hope that's making it into a patch soon or, at least 2.6.24.
    Kernel buffered

    I seem to remember reading about some problems with Promise SATA & ACPI.
Does this address that or is that a separate issue?  (Am using no-acpi for
now, but would like to try acpi again if it may be fixed (last time I tried
it with this card, "sdb" went "offline" (once it unmounted itself and
refused to be remounted (no error...just nothing), and another it stayed
mounted, but gave an I/O Error...so have been using no-acpi since).
An ACPI error in bootup said:
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread EFFC2000 could 
not acquire Mutex [3] [20070126]

    Is the above bug mentioned/discussed in the linux-ide archives?  That
and I'd like to find out why TCQ/NCQ doesn't work with the Seagate drives --
my guess, since they say queuedepth of 0/32, is that they are blacklisted
as being drives that don't follow normal protocol or implement their
own proprietary extensions?  Sigh.  Really a lame move (if that's the case)
for Seagate, considering they usage they could likely get in server
configs.  Maybe they want to push their SCSI/SAS drives?

    BTW, can SATA have DPO or FUA or are those limited to SCSI?
Would it be a desirable future addition to remove the
"doesn't support DPO or FUA" error message" on SATA drives if they are
specific to SCSI?





