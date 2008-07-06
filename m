Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYGFHJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYGFHJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 03:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYGFHJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 03:09:33 -0400
Received: from mout2.freenet.de ([195.4.92.92]:52226 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbYGFHJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 03:09:32 -0400
From: Sascha Sommer <saschasommer@freenet.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Status of Ricoh Bay1Controller driver?
Date: Sun, 6 Jul 2008 09:09:30 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: sdricohcs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080705115039.77bf7e1c@mjolnir.drzeus.cx> <200807052111.49807.saschasommer@freenet.de> <20080706012435.016358d6@mjolnir.drzeus.cx>
In-Reply-To: <20080706012435.016358d6@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807060909.30563.saschasommer@freenet.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sonntag, 6. Juli 2008, Pierre Ossman wrote:
> On Sat, 5 Jul 2008 21:11:49 +0200
>
> Sascha Sommer <saschasommer@freenet.de> wrote:
> > There is still some hack for ACMDs. I know you won't like that but I did
> > not get the SD_APP_SEND_SCR command to work without it.
> >
> > MMC_SEND_EXT_CSD does not work (also not with that ACMD hack) and prints
> > out something like:
>
> The SCR and EXT_CSD are both the only data transfers that are done in
> 1-bit mode in the respective init paths. Are you sure that hack you
> have for ACMDs is really for ACMDs and not for 1-bit transfers?
>
> (And you're right about me not liking that hack, but I can let that one
> slide as long as you agree it is important to get rid off ;))
>

Well I do not like the hacks either ;) However I'm out of ideas when it comes 
to these two commands. As far as I know the windows driver also does the |=64
for the SD_APP_OP_COND  and SD_APP_SET_BUS_WIDTH what are the only ACMDs. 
These aren't data read commands.

When I do not do the |= 64 the SD_APP_SEND_SCR command fails just like the 
MMC_SEND_EXT_CSD command.

#define MMC_SEND_EXT_CSD          8   /* adtc                    R1  */
#define MMC_SEND_CSD              9   /* ac   [31:16] RCA        R2  */
#define SD_APP_SEND_SCR          51   /* adtc                    R1  */

After the SD_APP_SEND_SCR command worked I tryed to fix the MMC_SEND_EXT_CSD 
command.
As you can see they look quite similar from the command description.
I tryed:
- different bit combination for what seem to be the command flags
- or the opcode with  |= 64, if this flag is for data transfers in one 1-bit
   mode this should have worked, shouldn't it?
- set the bus width to 4 bit before the read

Nothing worked ;( == The status register simply does not indicate that there 
is data available that can be read. It doesn't even change. Reading the data 
register nevertheless returns only zeros.

So to summarize this I agree that it is important to get rid off these 
hacks ;) but I don't have a better solution available at the moment ;(.

Regards

Sascha
