Return-Path: <linux-kernel-owner+w=401wt.eu-S1764532AbXFAVCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764532AbXFAVCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762893AbXFAVCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:02:25 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763716AbXFAVCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:02:24 -0400
Date: Fri, 1 Jun 2007 14:02:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org,
       Arnd Bergmann <arndb@de.ibm.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.22-rc3-mm1
Message-Id: <20070601140211.81e5c301.akpm@linux-foundation.org>
In-Reply-To: <200706012250.58962.m.kozlowski@tuxland.pl>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<200705312243.18724.m.kozlowski@tuxland.pl>
	<20070531141943.5c4d587c.akpm@linux-foundation.org>
	<200706012250.58962.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 22:50:58 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> > > 	This is from iMac G3. The spufs_mem_mmap_fault() code looks bad
> > > in arch/powerpc/platforms/cell/spufs/file.c but somehow I'm unable to find
> > > the patch to blame hmm.
> > > 
> > > arch/powerpc/platforms/cell/spufs/file.c: In function 'spufs_mem_mmap_fault':
> > > arch/powerpc/platforms/cell/spufs/file.c:122: error: 'address' undeclared (first use in this function)
> > > arch/powerpc/platforms/cell/spufs/file.c:122: error: (Each undeclared identifier is reported only once
> > > arch/powerpc/platforms/cell/spufs/file.c:122: error: for each function it appears in.)
> > > arch/powerpc/platforms/cell/spufs/file.c:141: error: expected ';' before 'if'
> > > arch/powerpc/platforms/cell/spufs/file.c:122: warning: unused variable 'addr0'
> > > make[3]: *** [arch/powerpc/platforms/cell/spufs/file.o] Blad 1
> > > make[2]: *** [arch/powerpc/platforms/cell/spufs] Blad 2
> > > make[1]: *** [arch/powerpc/platforms/cell] Blad 2
> > > 
> > 
> > Yeah, that's the fix-fault-vs-invalidate-race patches, or my poor attempt
> > to fix them when spufs changed.  I suppose I'll have a poke at it next time
> > I get the powerpc machine fired up.
> 
> I #if 0'ed that piece of code inside spufs_mem_mmap_fault() and run make again.
> This is 'make allmodconfig && make' result:
> 
> ERROR: ".ps3av_set_hdr" [drivers/ps3/ps3av_cmd.ko] undefined!
> ERROR: ".ps3av_do_pkt" [drivers/ps3/ps3av_cmd.ko] undefined!
> ERROR: ".ps3_vuart_write" [drivers/ps3/ps3av_cmd.ko] undefined!
> ERROR: ".ps3_vuart_read" [drivers/ps3/ps3av_cmd.ko] undefined!
> ERROR: ".ps3av_cmd_fin" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_av_video_disable_sig" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_set_video_mode" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_video_get_monitor_info" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_audio_active" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_set_audio_mode" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_set_av_audio_param" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_vuart_read" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_av_get_hw_conf" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_av_video_mute" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_av_tv_mute" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_audio_mode" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_av_hdmi_mode" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_set_av_video_cs" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_vuart_write" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_audio_mute" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_avb_param" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_init" [drivers/ps3/ps3av.ko] undefined!
> ERROR: ".ps3av_cmd_av_audio_mute" [drivers/ps3/ps3av.ko] undefined!
> ERROR: "pmu_batteries" [drivers/power/pmu_battery.ko] undefined!
> ERROR: "pmu_battery_count" [drivers/power/pmu_battery.ko] undefined!
> ERROR: "pmu_power_flags" [drivers/power/pmu_battery.ko] undefined!
> ERROR: "irq_map" [drivers/net/pasemi_mac.ko] undefined!
> ERROR: "pmu_batteries" [drivers/macintosh/apm_emu.ko] undefined!
> ERROR: "pmu_battery_count" [drivers/macintosh/apm_emu.ko] undefined!
> ERROR: "pmu_power_flags" [drivers/macintosh/apm_emu.ko] undefined!
> ERROR: ".cpufreq_set_policy" [arch/powerpc/platforms/cell/cbe_cpufreq.ko] undefined!
> make[1]: *** [__modpost] Blad 1
> make: *** [modules] Blad 2
> 

Yeah, allmodconfig tends to fall over in a heap on a lot of the
less-lavishly-maintained architectures.  If any of these are specific to
-mm then I guess we should fix them up, prevent the kernel from actually
going backwards.



