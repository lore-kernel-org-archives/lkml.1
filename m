Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbYAJKzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbYAJKzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYAJKzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:55:05 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60964 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYAJKzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:55:01 -0500
Date: Thu, 10 Jan 2008 12:54:59 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Matt Mackall <mpm@selenic.com>
cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> 
 <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
  <1199641910.8215.28.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI> 
 <1199906151.6245.57.camel@cinder.waste.org>  <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
 <1199919548.6245.74.camel@cinder.waste.org> <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Thu, 10 Jan 2008, Pekka J Enberg wrote:
> I'll double check the results for SLUB next but it seems obvious that your 
> patches are a net gain for SLOB and should be applied. One problem though 
> with SLOB seems to be that its memory efficiency is not so stable. Any 
> ideas why that is?

Ok, I did that. The number are stable and reproducible. In fact, the 
average for SLUB is within 1 KB of the previous numbers. So, we have the 
same .config, the same userspace, and the same hypervisor, so what's the 
difference here?

We probably don't have the same version of GCC which perhaps affects 
memory layout (struct sizes) and thus allocation patterns? I have included 
ver_linux from my laptop here:

Linux haji 2.6.24-rc6 #21 SMP Thu Jan 10 12:30:59 EET 2008 i686 GNU/Linux
 
Gnu C                  4.1.3
Gnu make               3.81
binutils               2.18
util-linux             2.13
mount                  2.13
module-init-tools      3.3-pre2
e2fsprogs              1.40.2
reiserfsprogs          3.6.19
pcmciautils            014
PPP                    2.4.4
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   113
wireless-tools         29
Modules Loaded         af_packet ipv6 binfmt_misc rfcomm l2cap uinput radeon drm acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative dock container joydev snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device pcmcia psmouse snd ipw2200 serio_raw pcspkr hci_usb soundcore snd_page_alloc bluetooth ieee80211 ieee80211_crypt yenta_socket rsrc_nonstatic pcmcia_core iTCO_wdt iTCO_vendor_support video output shpchp pci_hotplug intel_agp button agpgart thinkpad_acpi nvram evdev sg sd_mod ata_piix floppy ata_generic libata scsi_mod e1000 ehci_hcd uhci_hcd usbcore thermal processor fan fuse

			Pekka
