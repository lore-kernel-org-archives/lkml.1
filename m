Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbYAJJZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbYAJJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYAJJZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:25:20 -0500
Received: from smtp.ono.com ([62.42.230.12]:44456 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751575AbYAJJZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:25:18 -0500
Date: Thu, 10 Jan 2008 10:25:05 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080110102505.62097da1@werewolf>
In-Reply-To: <478429B2.2030002@gmail.com>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<20080108015012.2e518dd4@werewolf>
	<478429B2.2030002@gmail.com>
X-Mailer: Claws Mail 3.2.0cvs34 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jan 2008 10:56:02 +0900, Tejun Heo <htejun@gmail.com> wrote:

> J.A. Magallón wrote:
> > HI all...
> > 
> > On Sun, 6 Jan 2008 14:19:16 -0800 (PST), Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> >> It's been two weeks since rc6, but let's face it, with xmas and new years 
> >> (and birthdays) in between, there hasn't actually been a lot of working 
> >> days, and the incremental patch from -rc6 is about half the size of the 
> >> one from rc5->rc6.
> >>
> >> And I'll be charitable and claim it's because it's all stabilizing, and 
> >> not because we've all been in a drunken stupor over the holidays.
> >>
> >> The shortlog (appended below) is short and fairly informative. It's all 
> >> really just a lot of rather small changes. The diffstat shows a lot of 
> >> one- and two-liners, with just a few drivers (and the Cell platform) 
> >> getting a bit more attention, and the SLUB support of /proc/slabinfo 
> >> showing up as a blip.
> >>
> > 
> > With this kernel I'm getting frequent temporary freezes (system comes
> > back responsive after a minute or so...). I see this in dmesg:
> > 
> > ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > ata3.00: cmd ca/00:08:67:10:18/00:00:00:00:00/e2 tag 0 dma 4096 out
> >          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> > ata3.00: status: { DRDY }
> > ata3: soft resetting link
> > ata3.00: configured for UDMA/133
> > ata3: EH complete
> > sd 2:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
> > sd 2:0:0:0: [sdb] Write Protect is off
> > sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> > sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > 
> > ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > ata4.00: cmd c8/00:08:ef:0b:c7/00:00:00:00:00/e7 tag 0 dma 4096 in
> >          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> > ata4.00: status: { DRDY }
> > ata4: soft resetting link
> > ata4.00: configured for UDMA/133
> > ata4: EH complete
> > sd 3:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
> > sd 3:0:0:0: [sdc] Write Protect is off
> > sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> > sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > 
> > See this are two different drives, I doubt both drives have gone nuts
> > at the same time...
> 
> That's weird.  There hasn't been any related changes.  Does going back
> to 2.6.24-rc6 fix the problem?
> 

It reproduces also with 2.6.23.13.
Finally I think the problematic disk is sdc:

ICH5 PATA -> sda
ICH5 SATA0 -> sdb
ICH5 SATA1 -> sdc
Promise SATA -> sdd

The problem is that even I have commented out the entry for sdc in fstab,
the system is still giving me errors. An my guess is that errors in sdc makes
the ICH5 sata controller go nuts, and then I get errors also in sdb.
Just a couple questions...

- Can I say to ata_piix something like 'please, detect first SATA ports before
  ATA', so my system disk (sdb) becomes sda ?
- Can I say 'plz, ignore port 1', so it does not try to detect/start/spin sdc ?
  So I ban be sure it is the one to blame, before start to remove hardware...

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
