Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZCNCcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZCNCcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZCNCcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 22:32:25 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:62150 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZCNCcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 22:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=aOx3I99c/mAdJc22dOybdlVZFT9eir+9mkQmaNc/AIh7bftuSM3Tnwzwjz4Cw3k1Xv
         lVNSOo+MpA7WHwwRuTO5xuhj63h7ZDBiuv+nTs7H1wLqSgwyiz78troKkW9X+FM/+ar1
         QqPenGZUgioV2O78E6Xw1gz62c3IZllEUPxNI=
Message-ID: <49BB172D.5060609@gmail.com>
Date: Fri, 13 Mar 2009 20:32:13 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Gene Heskett <gene.heskett@gmail.com>
CC: Robin.Laing@drdc-rddc.gc.ca, LKML <linux-kernel@vger.kernel.org>,
       David Newall <davidn@davidnewall.com>, yhlu.kernel@gmail.com
Subject: Re: New ASUS 1701 bios for M2N SLI DELUXE
References: <200903131642.54925.gene.heskett@gmail.com>
In-Reply-To: <200903131642.54925.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Hi Robin, David and lkml list;
> 
> I said I would report.
> 
> I just reinstalled the 1502 version bios after spending the last 2 days 
> trying to get an hours worth of uptime without an oops.  Gave up.
> 
> David Newell and I have been trying to find the cause of the oops, but 
> when the compile instructions David is sending me don't work, its a bit 
> difficult to troubleshoot beyond renaming the function just to see if 
> the oops follows the rename, which it does.  And with the boot girations
> to get a working radeonhd driver now broken again, apparently by the 
> 'make mrproper' that David had me do, I'm now stuck on issue drivers for 
> drm, radeon, and radeonhd and those are noticably slower.
> 
> So I'm back on the 1502 version of the bios, it does an oops as I sent 
> before right at entering vmlinuz, which marks me tainted, but the machine 
> is dead stable after that.
> 
> Here is another snip of that to refresh memories:
> [    0.000000] DMI 2.4 present.
> [    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
> [    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x1000000
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 generic_get_mtrr+0xea/0x120()
> [    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28.7 #7
> [    0.000000] Call Trace:
> [    0.000000]  [<c042858f>] warn_slowpath+0x6f/0x90
> [    0.000000]  [<c05193b0>] vsnprintf+0x3c0/0x7e0
> [    0.000000]  [<c0627a00>] panic+0x15/0xee
> [    0.000000]  [<c041a78c>] pat_init+0x7c/0xa0
> [    0.000000]  [<c040f9fc>] post_set+0x1c/0x50
> [    0.000000]  [<c0733f35>] dmi_string_nosave+0x4c/0x6d
> [    0.000000]  [<c0441031>] up+0x11/0x40
> [    0.000000]  [<c040f7ea>] generic_get_mtrr+0xea/0x120
> [    0.000000]  [<c071f91f>] mtrr_trim_uncached_memory+0x7d/0x374
> [    0.000000]  [<c042e583>] request_resource+0xa3/0x150
> [    0.000000]  [<c0627af0>] printk+0x17/0x1f
> [    0.000000]  [<c071be82>] e820_end_pfn+0xb5/0xd3
> [    0.000000]  [<c0719fc9>] setup_arch+0x501/0xb68
> [    0.000000]  [<c0428d89>] release_console_sem+0x189/0x1d0
> [    0.000000]  [<c071d027>] reserve_early_overlap_ok+0x3f/0x47
> [    0.000000]  [<c07138a4>] start_kernel+0x58/0x314
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---

That's not an oops, it's a warning. Those do normally taint the kernel. 
I don't think this should really be a WARN, IMHO, as it's a BIOS bug and 
not the kernel's fault, and it's fixed up the problem. CCing Yinghai Lu, 
which it looks like wrote this warning.

> 
> So based on that, I'll now go build a 2.6.29-rc8 and see how that runs.
> 
> The biggest problem with the 2.6.29 series is that apparently, for security 
> reasons, they are now doing a PHY disable in a graceful shutdown, which 
> none of the previous kernels knows how to re-enable.
> 
> So to reboot to the 2.6.28.7 stable, you have to use the front panel reset 
> button to reboot or you will not have any onboard ethernet until you do a 
> full, pull ALL the power plugs for at least 30 seconds (I go make a cup of 
> tea, about 3 minutes) to reset the PHY's back to operational status. TBT,
> the reset button is easier.
> 
> Frankly, that seems like a thoroughly busted security idea, but I suppose 
> we're stuck with it.

I doubt it's for security reasons. Could be due to power management or 
suspend/resume changes?

> 
> It also seems to me, that to mark my kernel as tainted over a fix-up that 
> makes the system dead stable, is executing the messenger.  IMNSHO, its ASUS 
> who ought to be shot for not having any method of filing a bug report 
> against their crappy bios.  3 emails sent to the only address I was able to 
> find for ASUS have had the same effect as sending them to /dev/null.
> 
> If anyone on the LKML knows how to contact ASUS, please advise them that 
> there is at least one VERY unhappy camper/user of the 
> $285 USD M2N SLI DELUXE motherboard, I'm sorry I ever laid eyes on it. 
> The newly released version 1701 bios (it unzips as M2N-SLI-Deluxe-1701.BIN) 
> still doesn't get it right AFAIAC.  The kernel writers at least know what
> to do about the older version bios.  Maybe ASUS coded the new bios to get
> past your test, but is it still fscked?  That is certainly my opinion...
> 
> Thanks everybody.  Now back to your regularly scheduled programming. :)
> 

