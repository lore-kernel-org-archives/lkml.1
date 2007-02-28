Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXB1Mm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXB1Mm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXB1Mm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:42:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbXB1Mm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:42:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kristian =?iso-8859-15?q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
Date: Wed, 28 Feb 2007 13:45:14 +0100
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
References: <1172601905.5428.28.camel@localhost.localdomain> <200702272330.22968.rjw@sisk.pl> <1172622441.4587.14.camel@localhost.localdomain>
In-Reply-To: <1172622441.4587.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702281345.15098.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 01:27, Kristian Grønfeldt Sørensen wrote:
> On Tue, 2007-02-27 at 23:30 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, 27 February 2007 23:04, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > On Tuesday, 27 February 2007 19:45, Kristian Grønfeldt Sørensen wrote:
> > > > Hi.
> > > > 
> > > > PROBLEM: "BUG:" when resumimg from suspend-to-ram 
> > > > 	
> > > > My laptop have a problem with resuming from suspend-to-ram. 
> > > > It does not occur every time - most of the time, resume works without
> > > > any problem.at all.
> > > > 
> > > > After it occurs, the laptop refuses to go into suspend-to-ram mode until
> > > > next reboot.
> > > 
> > > What do you mean by "refuses"?  Are there any suspicious messages in
> > > dmesg?
> > > 
> > > > The system is a Debian unstable running with a self-compiled 2.6.20
> > > > kernel downloaded from kernel.org. 
> > > > 
> > > > I've only tried suspend-to-ram on 2.6.20 so I don't know whether or not
> > > > other versions might have the same problem.
> > > > 
> > > > I'm not subscribed to the list. Please CC me.
> > > 
> > > I guess one of the drivers you use goes awry at some point.  Please provide
> > > us with more information (like dmesg output after a failing resume).
> > 
> > I'm sorry, I've just been told you sent it. :-)
> > 
> > > CLASS: Unregistering class device. ID = 'event3'
> > > class_uevent - name = event3
> > > class_device_create_uevent called for event3
> > > device class 'event3': release.
> > > class_device_create_release called for event3
> > > BUG: unable to handle kernel paging request at virtual address 6b6b6b6b
> > >  printing eip:
> > > f8825a81
> > > *pde = 00000000
> > > Oops: 0000 [#1]
> > > PREEMPT
> > > Modules linked in: tg3 battery ac thermal fan button i915 drm binfmt_misc
> > > rfcomm l2cap ipv6 fuse capability commoncap cpufreq_performance aoe
> > > af_packet nls_utf8 ntfs nls_iso8859_1 nls_cp437 vfat fat dm_snapshot
> > > dm_mirror dm_mod ieee80211_cr ypt_tkip ieee80211_crypt pd6729 snd_seq_dummy
> > > snd_seq_oss snd_seq_midi snd_rawmi di snd_seq_midi_event snd_seq
> > > snd_seq_device sermouse hci_vhci hci_uart wbsd mmc _block mmc_core tun msr
> > > cpuid cpufreq_stats container video speedstep_lib speeds tep_centrino
> > > processor sr_mod sbp2 scsi_mod ide_cd cdrom eth1394 hci_usb bluetoo th
> > > pcmcia firmware_class irda snd_intel8x0m snd_intel8x0 snd_ac97_codec
> > > crc_ccit t ac97_bus snd_pcm_oss snd_mixer_oss rtc i2c_i801 snd_pcm
> > > snd_timer ohci1394 iee e1394 i2c_core serio_raw intel_agp iTCO_wdt snd
> > > soundcore snd_page_alloc ehci_hc d pcspkr uhci_hcd yenta_socket
> > > rsrc_nonstatic pcmcia_core usbcore agpgart moused ev evdev
> > > CPU:    0
> > > EIP:    0060:[<f8825a81>]    Not tainted VLI
> > > EFLAGS: 00010202   (2.6.20-x300 #1)
> > > EIP is at evdev_disconnect+0xb1/0xe0 [evdev]
> > 
> > This points us to a suspect.  Can you please run "gdb vmlinux" against the
> > vmlinux in your kernel sources directory and then
> > 
> > gdb> l *evdev_disconnect+0xb1
> 
> OK. Recopiled the kernel with CONFIG_DEBUG_INFO=y
> 
> This gives: 
> 
> (gdb) l *evdev_disconnect+0xb1
> No symbol "evdev_disconnect" in current context.
> 
> I guess you meant gdb drivers/input/evdev.ko

Yes, exactly.

> This gives:
> 
> (gdb) l *evdev_disconnect+0xb1
> 0xa81 is in evdev_disconnect (include/asm/processor.h:716).
> 711        However we don't do prefetches for pre XP Athlons currently
> 712        That should be fixed. */
> 713     #define ARCH_HAS_PREFETCH
> 714     static inline void prefetch(const void *x)
> 715     {
> 716             alternative_input(ASM_NOP4,
> 717                               "prefetchnta (%1)",
> 718                               X86_FEATURE_XMM,
> 719                               "r" (x));
> 720     }

Hm, interesting.  Looks like a pointer points to nowhere in
input_unregister_device(), but I don't know which one.  This may be
an evdev problem ...

Rafael
