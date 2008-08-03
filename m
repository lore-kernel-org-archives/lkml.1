Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYHCClm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYHCClm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 22:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYHCCle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 22:41:34 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:48595 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYHCCld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 22:41:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18581.6873.353028.695909@stoffel.org>
Date: Sat, 2 Aug 2008 22:41:29 -0400
From: "John Stoffel" <john@stoffel.org>
To: linasvepstas@gmail.com
Cc: "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
In-Reply-To: <3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	<200808012319.05038.alistair@devzero.co.uk>
	<3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
	<18580.48861.657366.629904@stoffel.org>
	<3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linas" == Linas Vepstas <linasvepstas@gmail.com> writes:

Linas> 2008/8/2 John Stoffel <john@stoffel.org>:
>>>>>>> "Linas" == Linas Vepstas <linasvepstas@gmail.com> writes:
>> 
Linas> 2008/8/1 Alistair John Strachan <alistair@devzero.co.uk>:
>>>> On Friday 01 August 2008 18:30:34 Linas Vepstas wrote:
>>>>> Hi,
>>>>> 
>>>>> I'm seeing strong, easily reproducible (and silent) corruption on a
>>>>> sata-attached
>>>>> disk drive on an amd64 board.  It might be the disk itself, but I
>>>>> doubt it; googling
>>>>> suggests that its somehow iommu-related but I cannot confirm this.
>> 
>> Can you post the output of dmesg after a boot, so we can see which
>> driver is being used?  I assume the new Libata stuff, but maybe you
>> can also turn on debugging in there as well.  Stuff like SCSI_DEBUG
>> (in the SCSI menus) might show us more details here.
>> 
>> Also, have you tried a new SATA cable by any chance?  That's obviously
>> the cheaper path than getting a new disk...

Linas> I took the problematic hard drive (and its cable) to another
Linas> computer with sata ports on it, and ran my
Linas> file-copy/compare/fsck tests there, and saw no problems; so the
Linas> drive itself and its cable get a clean bill of health.

Well that's a good sign.  

Linas> Then, rather stupidly, I flashed the latest BIOS for the
Linas> motherboard and now have a dead motherboard (it hangs on its
Linas> way through BIOS, well before the bootloader.)  So I'm off to
Linas> buy a new mobo today.

Awww fuckies.  Sorry to suggest this path to you.  You might be able
to get it back by clearing the CMOS as well.  And hey, it could have
been a bad Mobo in the end too.  

Linas> I'll send the dmesg from the older boots later today, if all
Linas> goes well.  I'm pretty sure I had the new libata on, and the
Linas> old off -- but its possible that the .config somehow managed to
Linas> pull in parts of the old libata code anyway. I say this
Linas> because, besides the SATA, the blown motherboard had an IDE
Linas> connector in use, and I also had another PCI IDE card plugged
Linas> in and in use. I'm imagining that perhaps the PCI IDE .config
Linas> might have pulled in old code, maybe via header file, and thus
Linas> mangled some lock that the sata side was using. Just a wild
Linas> guess.  -- Most people on this mobo hadn't seen problems, and
Linas> unlike most people, I had the PCI IDE card in it.

Hmmm... I've sorta run into this, but on my old system where I have
the following:  Adaptec SCSI built in (boot drive), LSI scsi PCI card
(tape library and drives), PATA on board (for DVD), SIL SATA PCI card
(data disks), HighPoint PCI card, two scratch disks.  Total pain in
the butt figuring out the right mix of libATA SATA/PATA drivers vs the
old plain PATA drivers.  Once I got it working with pretty much all
/dev/sd* devices, I just leave it alone.  :]  Oh yeah, an 8 port
serial card and a Gigabit ethernet card as well.  It's full to the
gills.  

My new system is mostly my desktop, not my server, so I haven't pushed
it as hard bus wise.  

Good luck, sorry I can't help directly.  Do you want to see my dmesg
output as a comparision?

John
