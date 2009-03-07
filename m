Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZCGXn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZCGXn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 18:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZCGXns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 18:43:48 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:20693 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZCGXnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 18:43:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QNXrKZhzC/YaLnYBANjzIUQRyTKHDBHpafYo/4nJKCo4X3uEnt6vcAwE+rN+tUeZ5q
         I6n4pHjY0LvxAo5914cdU4zRZhlbVyRucKFPejRl+Dhf1fqJ9aX07AjMD/4VwzFeTQIz
         ISYW7ZNzDoiWO4x6Bx4lhWdvN9mASFwSjoGbs=
MIME-Version: 1.0
In-Reply-To: <49B1754C.50109@wpkg.org>
References: <49B1754C.50109@wpkg.org>
Date: Sun, 8 Mar 2009 09:43:45 +1000
Message-ID: <21d7e9970903071543o21fb5bb0p10e0709afc76abf6@mail.gmail.com>
Subject: Re: Initialized radeon -> Oops: 0000 [#1] SMP
From: Dave Airlie <airlied@gmail.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 7, 2009 at 5:11 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> Don't really know where one should send Oops... Is there a better place than
> linux-kernel?
>
>
> First time I see such an oops on this multiseat system. Everything still
> works fine though.
>
> pci 0000:02:05.0: enabling device (0000 -> 0003)
>                                                pci 0000:02:05.0: PCI INT A
> -> GSI 17 (level, low) -> IRQ 17
>                     [drm] Initialized drm 1.1.0 20060810
>                                                                     pci
> 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>                                             [drm] Initialized radeon 1.29.0
> 20080528 on minor 0
>                  BUG: unable to handle kernel NULL pointer dereference at
> 00000320                                                            IP:
> [<f864709c>] dri_library_name+0xc/0x50 [radeon]
>                                              *pde = 00000000
>
>                  Oops: 0000 [#1] SMP
>                                                                  last sysfs
> file: /sys/class/drm/card1/dri_library_name
>                                       Modules linked in: radeon(+) drm
> uhci_hcd mt2060 ehci_hcd fuse af_packet ipv6 binfmt_misc loop dm_mirror
> dm_region_hash dm_log dm_mod cpufreq_ondemand cpufreq_conservative
> cpufreq_powersave p4_clockmod speedstep_lib freq_table joydev usbhid hid
> snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device dvb_usb_dibusb_mc
> dvb_usb_dibusb_common snd_pcm_oss dib3000mc dibx000_common snd_pcm dvb_usb
> dvb_core snd_timer rng_core snd_mixer_oss snd r8169 soundcore mii intel_agp
> agpgart i2c_i801 i2c_core shpchp snd_page_alloc iTCO_wdt iTCO_vendor_support
> pci_hotplug thermal sg processor sr_mod button rtc_cmos evdev usbcore
> ata_generic ide_pci_generic pata_acpi piix ide_gd_mod ide_core ahci ata_piix
> libatasd_mod scsi_mod crc_t10dif ext4 jbd2 crc16 [last unloaded: ehci_hcd]

Well dri_library_name is gone in drm-next tree, so the oops is fixed
via deletion.

I think it was a race condition that was causing this, but in any case
it won't be
there much longer.

Dave.

>
> Pid: 2973, comm: hald Not tainted (2.6.29-0.rc7.1mdv #1) MS-6728
> EIP: 0060:[<f864709c>] EFLAGS: 00010286 CPU: 0
> EIP is at dri_library_name+0xc/0x50 [radeon]
> EAX: 00000000 EBX: f4c77000 ECX: f8647090 EDX: f4c77000
> ESI: f84d4ac0 EDI: f84bf5c0 EBP: f623df0c ESP: f623defc
> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process hald (pid: 2973, ti=f623c000 task=f6043040 task.ti=f623c000)
> Stack:
> 000280d0 00000001 00000010 00000001 f623df28 f84bf5e0 c04bc484 000b8097
> 00000000 f4c523c0 fffffffb f623df3c c02b21d4 c04af980 f68fc780 f4c52570
> f623df6c c01f4bdd f623df6c c01a6088 00001000 b8097000 f68fc794 c04af980
> Call Trace:
> [<f84bf5e0>] ? show_dri+0x20/0x50 [drm]
> [<c02b21d4>] ? dev_attr_show+0x24/0x50
> [<c01f4bdd>] ? sysfs_read_file+0x7d/0x110
> [<c01a6088>] ? rw_verify_area+0x48/0xc0
> [<c01a67e9>] ? vfs_read+0x99/0x160
> [<c01f4b60>] ? sysfs_read_file+0x0/0x110
> [<c01a696d>] ? sys_read+0x3d/0x70
> [<c0103eeb>] ? sysenter_do_call+0x12/0x2f
> Code: 08 01 00 00 8b 40 10 83 c0 40 89 10 31 c0 5d c3 eb 0d 90 90 90 90 90
> 90 90 90 90 90 90 90 90 55 89 e5 83 ec 10 8b 80 2c 02 00 00 <0f> b7 88 20 03
> 00 00 b8 c8 de 65 f8 83 f9 04 7e 0a 83 f9 08 b8
> EIP: [<f864709c>] dri_library_name+0xc/0x50 [radeon] SS:ESP 0068:f623defc
> ---[ end trace 64a71e320bae00a0 ]---
> [drm] Initialized radeon 1.29.0 20080528 on minor 1
> [drm] Setting GART location based on new memory map
> [drm] Loading R200 Microcode
> [drm] writeback test succeeded in 2 usecs
> agpgart-intel 0000:00:00.0: AGP 3.0 bridge
> agpgart-intel 0000:00:00.0: putting AGP V3 device into 8x mode
> pci 0000:01:00.0: putting AGP V3 device into 8x mode
> [drm] Setting GART location based on new memory map
> [drm] Loading R300 Microcode
> [drm] Num pipes: 1
> [drm] writeback test succeeded in 1 usecs
>
>
> $ lspci
> 00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM Controller/Host-Hub
> Interface (rev 02)
> 00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller (rev
> 02)
> 00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI
> Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI
> Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI
> Controller #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI
> Controller #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI
> Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
> 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface
> Bridge (rev 02)
> 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
> Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller
> (rev 02)
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER
> (ICH5/ICH5R) AC'97 Audio Controller (rev 02)
> 01:00.0 VGA compatible controller: ATI Technologies Inc RV350 AR [Radeon
> 9600]
> 01:00.1 Display controller: ATI Technologies Inc RV350 AR [Radeon 9600]
> (Secondary)
> 02:05.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200
> PRO] (rev 01)
> 02:05.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200 PRO]
> (Secondary) (rev 01)
> 02:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
> Gigabit Ethernet (rev 10)
>
>
> $ lspci -v (video cards only)
> 01:00.0 VGA compatible controller: ATI Technologies Inc RV350 AR [Radeon
> 9600] (prog-if 00 [VGA controller])
>       Subsystem: ATI Technologies Inc RV350 AR [Radeon 9600]
>       Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
>       Memory at c0000000 (32-bit, prefetchable) [size=256M]
>       I/O ports at a800 [size=256]
>       Memory at ffcf0000 (32-bit, non-prefetchable) [size=64K]
>       Expansion ROM at ffcc0000 [disabled] [size=128K]
>       Capabilities: <access denied>
>       Kernel modules: radeonfb
>
> 01:00.1 Display controller: ATI Technologies Inc RV350 AR [Radeon 9600]
> (Secondary)
>       Subsystem: ATI Technologies Inc Device 4153
>       Flags: bus master, 66MHz, medium devsel, latency 32
>       Memory at b0000000 (32-bit, prefetchable) [size=256M]
>       Memory at ffce0000 (32-bit, non-prefetchable) [size=64K]
>       Capabilities: <access denied>
>
> 02:05.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200
> PRO] (rev 01) (prog-if 00 [VGA controller])
>       Subsystem: Device 0001:0001
>       Flags: bus master, medium devsel, latency 32, IRQ 17
>       Memory at e4000000 (32-bit, prefetchable) [size=64M]
>       I/O ports at b800 [size=256]
>       Memory at ffde0000 (32-bit, non-prefetchable) [size=64K]
>       Expansion ROM at dff00000 [disabled] [size=128K]
>       Capabilities: <access denied>
>       Kernel modules: radeonfb
>
> 02:05.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200 PRO]
> (Secondary) (rev 01)
>       Subsystem: Device 0001:0000
>       Flags: bus master, medium devsel, latency 32
>       Memory at e8000000 (32-bit, prefetchable) [size=64M]
>       Memory at ffdf0000 (32-bit, non-prefetchable) [size=64K]
>       Capabilities: <access denied>
>
> $ cat /proc/cpuinfo processor       : 0              vendor_id       :
> GenuineIntel   cpu family      : 15             model           : 4
>      model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> stepping        : 1                                cpu MHz         :
> 3000.000                         cache size      : 1024 KB
>        physical id     : 0                                siblings        :
> 2                                core id         : 0
>        cpu cores       : 1                                apicid          :
> 0                                initial apicid  : 0
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2ss ht tm pbe constant_tsc
> pebs bts pni dtes64 monitor ds_cpl cid xtpr
> bogomips        : 6000.67
> clflush size    : 64
> power management:
>
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 4
> model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> stepping        : 1
> cpu MHz         : 3000.000
> cache size      : 1024 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 1
> apicid          : 1
> initial apicid  : 1
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2ss ht tm pbe constant_tsc
> pebs bts pni dtes64 monitor ds_cpl cid xtpr
> bogomips        : 5999.17
> clflush size    : 64
> power management:
>
>
> --
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
