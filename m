Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYCWAcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYCWAcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 20:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYCWAb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 20:31:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbYCWAby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 20:31:54 -0400
Date: Sat, 22 Mar 2008 17:31:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Marco Mangiante" <marco.mangiante@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PROBLEM]: onda h600 express card don't work inside the elan
 u132 usb adapter
Message-Id: <20080322173147.d94740b7.akpm@linux-foundation.org>
In-Reply-To: <42212ce70803220351p7fc14327m1e616dca0fec7b34@mail.gmail.com>
References: <42212ce70803220351p7fc14327m1e616dca0fec7b34@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc linux-usb)

On Sat, 22 Mar 2008 11:51:28 +0100 "Marco Mangiante" <marco.mangiante@gmail.com> wrote:

> I'm trying to use the onda h600 (a pcmcia express card for UMTS-HSDPA)
> on an assembled desktop under kubuntu 7.04 (kernel 2.6.22-14-generic),
> but the problem is present even in 7.10 and 8.04 alpha 6 (this has a
> 2.6.24-8-generic kernel). The card apparentely have a ZTE MF330
> chipset, and is OHCI compliant.
> 
> I want to use it with elan u132, an usb external adapter for
> UMTS-HSDPA express cards. In a document found on the net and written
> by Tony Olech (the author and maintainer of the elan u132 linux driver
> in Elan Digital Systems), I read that the device (u132) must load 2
> modules: the ftdi-u132 when it is plugged in the usb port, and the
> u132-hcd, when it recognize an express card inside it.
> 
> What happen is that, when I insert the card in the u132 device, the
> green light (it flashes, is not fix) of the u132 becomes red. On what
> I understand, the module ftdi-u132 is loaded but not the u132-hcd.
> 
> With an dmesg command I received these data, when I plug the u132 in
> the usb port:
> 
> [   15.628000] driver ftdi-elan built at 23:19:53 on Oct 14 2007
> 
> [   15.628000] usb 2-1: interface 0 has I=81 O=02
> 
> [   15.628000] usb 2-1: USB FDTI=e9209000 JTAG interface 0 now
> attached to ftdi192
> 
> [   15.628000] usb 2-1: interface 1 has I=83 O=04
> 
> [   15.628000] usb 2-1: USB FDTI=eb7bd000 ELAN interface 1 now activated
> 
> [   15.628000] usbcore: registered new interface driver ftdi-elan
> 
> [   22.132000] usb 2-1: initialized failed - trying again in 10 seconds
> 
> [   23.176000] usb 2-1: initialized failed - trying again in 10 seconds
> 
> [   24.220000] usb 2-1: initialized failed - trying again in 10 seconds
> 
> [   25.264000] usb 2-1: initialized failed - trying again in 10 seconds
> 
> [   26.308000] usb 2-1: initialized failed - trying again in 10 seconds
> 
> [   28.396000] usb 2-1: initialized failed - trying again in 10 seconds
> 
> [   29.440000] usb 2-1: initialized failed - trying again in 10 seconds
> 
> [   30.484000] usb 2-1: initialized failed - trying again in 10 seconds
> 
> [   31.528000] usb 2-1: initialized failed - trying again in 10 seconds
> 
> 
> N.B.: I deleted many other lines similar to the last above.
> 
> 
> The part wiht the failed initialization starts when you enter the onda
> h600 in the u132, or starts soon as you have already plugged the onda
> h600 in.
> 
> 
> I see on ubuntu that there is a bug (129433) that maybe is related:
> the user of the onda h600 must place in the blacklist the driver
> ehci_hcd, but even if I do that I obtain no good results.
> 
> It seems that the second module driver, u132-hcd, have problem when it
> try to load itself and u132 so don't recognize the onda h600.
> 
> I also include data from scripts/ver_linux:
> 
> Linux kubuntu 2.6.22-14-generic #1 SMP Sun Oct 14 23:05:12 GMT 2007
> i686 GNU/Linux
> 
> 
> 
> Gnu C                  4.1.3
> 
> Gnu make               3.81
> 
> binutils               Binutils
> 
> util-linux             2.13
> 
> mount                  2.13
> 
> module-init-tools      3.3-pre2
> 
> e2fsprogs              1.40.2
> 
> reiserfsprogs          3.6.19
> 
> pcmciautils            014
> 
> PPP                    2.4.4
> 
> Linux C Library        2.6.1
> 
> Dynamic linker (ldd)   2.6.1
> 
> Procps                 3.2.7
> 
> Net-tools              1.60
> 
> Console-tools          0.2.3
> 
> Sh-utils               5.97
> 
> udev                   113
> 
> wireless-tools         29
> 
> Modules Loaded         rfcomm l2cap bluetooth radeon drm ppdev
> cpufreq_userspace cpufreq_conservative cpufreq_powersave
> cpufreq_ondemand cpufreq_stats freq_table container button dock sbs
> video ac battery nls_iso8859_1 nls_cp437 vfat fat lp loop snd_via82xx
> snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm
> snd_page_alloc snd_seq_dummy snd_mpu401 snd_mpu401_uart snd_seq_oss
> snd_seq_midi snd_rawmidi snd_seq_midi_event parport_pc parport analog
> gameport pcspkr ftdi_elan psmouse snd_seq snd_timer snd_seq_device
> i2c_viapro i2c_core via_ircc irda snd soundcore serio_raw crc_ccitt
> shpchp pci_hotplug via_agp agpgart evdev ext3 jbd mbcache ide_cd cdrom
> ide_disk ata_generic libata scsi_mod floppy via_rhine mii via82cxxx
> ide_core uhci_hcd usbcore thermal processor fan fuse apparmor
> commoncap

