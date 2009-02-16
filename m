Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZBPNOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZBPNOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbZBPNOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:14:03 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:49958 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbZBPNN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:13:56 -0500
Date: Mon, 16 Feb 2009 14:13:52 +0100
From: Nico Schottelius <nico-linux-20090213@schottelius.org>
To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
       ZhangRui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Message-ID: <20090216131351.GA4839@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
	ZhangRui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
References: <20090213093354.GA10175@denkbrett.schottelius.org> <20090213094200.GC17774@elte.hu> <alpine.LFD.2.00.0902131302240.3671@localhost.localdomain> <1234775219.4998.1.camel@rzhang-desktop> <20090216105847.GA29302@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20090216105847.GA29302@denkbrett.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc5-ikn x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nico Schottelius [Mon, Feb 16, 2009 at 11:58:47AM +0100]:
> [...]=20
> I'm upgrading to v2.6.29-rc5 now and will test the supplied patch,
> if the error is still there.

Same problem on 2.6.29-rc5:

[  121.149035] [drm] Initialized drm 1.1.0 20060810
[  121.191392] pci 0000:00:02.0: power state changed by ACPI to D0
[  121.191410] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  121.191419] pci 0000:00:02.0: setting latency timer to 64
[  121.251571] pci 0000:00:02.0: irq 30 for MSI/MSI-X
[  121.251646] [drm] Initialized i915 1.6.0 20080730 on minor 0
[  121.302429] [drm:i915_initialize] *ERROR* can not ioremap virtual addres=
s for ring buffer

Applied patch manually, compiling currently, ...

same problem on 2.6.29-rc5 including patch!

patch:

ikn% git diff
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dm=
a.c
index 81f1cff..2d797ff 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -202,7 +202,7 @@ static int i915_initialize(struct drm_device * dev, drm=
_i915                dev_priv->ring.map.flags =3D 0;
                dev_priv->ring.map.mtrr =3D 0;

-               drm_core_ioremap(&dev_priv->ring.map, dev);
+               drm_core_ioremap_wc(&dev_priv->ring.map, dev);

                if (dev_priv->ring.map.handle =3D=3D NULL) {
                        i915_dma_cleanup(dev);


xorg log:

X.Org X Server 1.4.2
Release Date: 11 June 2008
X Protocol Version 11, Revision 0
Build Operating System: Linux Debian (xorg-server 2:1.4.2-10)
Current Operating System: Linux ikn 2.6.29-rc5-ikn-dirty #15 SMP PREEMPT Mo=
n Feb 16 13:57:11 CET 2009 x86_64
Build Date: 09 January 2009  02:16:05AM
=20
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Module Loader present
Markers: (--) probed, (**) from config file, (=3D=3D) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(=3D=3D) Log file: "/var/log/Xorg.0.log", Time: Mon Feb 16 14:06:57 2009
(=3D=3D) Using config file: "/etc/X11/xorg.conf"
(=3D=3D) No Layout section.  Using the first Screen section.
(**) |-->Screen "Default Screen" (0)
(**) |   |-->Monitor "Configured Monitor"
(=3D=3D) No device specified for screen "Default Screen".
	Using the first device section listed.
(**) |   |-->Device "Configured Video Device"
(=3D=3D) |-->Input Device "Configured Mouse"
(=3D=3D) |-->Input Device "Generic Keyboard"
(=3D=3D) The core pointer device wasn't specified explicitly in the layout.
	Using the first mouse device.
(=3D=3D) The core keyboard device wasn't specified explicitly in the layout.
	Using the first keyboard device.
(=3D=3D) Automatically adding devices
(=3D=3D) Automatically enabling devices
(=3D=3D) No FontPath specified.  Using compiled-in default.
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(=3D=3D) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType
(=3D=3D) RgbPath set to "/etc/X11/rgb"
(=3D=3D) ModulePath set to "/usr/lib/xorg/modules"
(II) Open ACPI successful (/var/run/acpid.socket)
(II) Loader magic: 0x7c28e0
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.3
	X.Org Video Driver: 2.0
	X.Org XInput driver : 2.0
	X.Org Server Extension : 0.3
	X.Org Font Renderer : 0.5
(II) Loader running on linux
(II) LoadModule: "pcidata"
(II) Loading /usr/lib/xorg/modules//libpcidata.so
(II) Module pcidata: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 1.0.0
	ABI class: X.Org Video Driver, version 2.0
(--) using VT number 7

(II) PCI: PCI scan (all values are in hex)
(II) PCI: 00:00:0: chip 8086,2a40 card 17aa,20e0 rev 07 class 06,00,00 hdr =
00
(II) PCI: 00:02:0: chip 8086,2a42 card 17aa,20e4 rev 07 class 03,00,00 hdr =
80
(II) PCI: 00:02:1: chip 8086,2a43 card 17aa,20e4 rev 07 class 03,80,00 hdr =
80
(II) PCI: 00:03:0: chip 8086,2a44 card 17aa,20e6 rev 07 class 07,80,00 hdr =
80
(II) PCI: 00:19:0: chip 8086,10f5 card 17aa,20ee rev 03 class 02,00,00 hdr =
00
(II) PCI: 00:1a:0: chip 8086,2937 card 17aa,20f0 rev 03 class 0c,03,00 hdr =
80
(II) PCI: 00:1a:1: chip 8086,2938 card 17aa,20f0 rev 03 class 0c,03,00 hdr =
00
(II) PCI: 00:1a:2: chip 8086,2939 card 17aa,20f0 rev 03 class 0c,03,00 hdr =
00
(II) PCI: 00:1a:7: chip 8086,293c card 17aa,20f1 rev 03 class 0c,03,20 hdr =
00
(II) PCI: 00:1b:0: chip 8086,293e card 17aa,20f2 rev 03 class 04,03,00 hdr =
00
(II) PCI: 00:1c:0: chip 8086,2940 card 0000,0000 rev 03 class 06,04,00 hdr =
81
(II) PCI: 00:1c:1: chip 8086,2942 card 0000,0000 rev 03 class 06,04,00 hdr =
81
(II) PCI: 00:1c:3: chip 8086,2946 card 0000,0000 rev 03 class 06,04,00 hdr =
81
(II) PCI: 00:1d:0: chip 8086,2934 card 17aa,20f0 rev 03 class 0c,03,00 hdr =
80
(II) PCI: 00:1d:1: chip 8086,2935 card 17aa,20f0 rev 03 class 0c,03,00 hdr =
00
(II) PCI: 00:1d:2: chip 8086,2936 card 17aa,20f0 rev 03 class 0c,03,00 hdr =
00
(II) PCI: 00:1d:7: chip 8086,293a card 17aa,20f1 rev 03 class 0c,03,20 hdr =
00
(II) PCI: 00:1e:0: chip 8086,2448 card 0000,0000 rev 93 class 06,04,01 hdr =
01
(II) PCI: 00:1f:0: chip 8086,2917 card 17aa,20f5 rev 03 class 06,01,00 hdr =
80
(II) PCI: 00:1f:2: chip 8086,2929 card 17aa,20f8 rev 03 class 01,06,01 hdr =
00
(II) PCI: 00:1f:3: chip 8086,2930 card 17aa,20f9 rev 03 class 0c,05,00 hdr =
00
(II) PCI: 03:00:0: chip 8086,4236 card 8086,1011 rev 00 class 02,80,00 hdr =
00
(II) PCI: End of PCI scan
(II) Intel Bridge workaround enabled
(II) Host-to-PCI bridge:
(II) Bus 0: bridge is at (0:0:0), (0,0,13), BCTRL: 0x0008 (VGA_EN is set)
(II) Bus 0 I/O range:
	[0] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) Bus 0 non-prefetchable memory range:
	[0] -1	0	0x00000000 - 0xffffffff (0x100000000) MX[B]
(II) Bus 0 prefetchable memory range:
	[0] -1	0	0x00000000 - 0xffffffff (0x100000000) MX[B]
(II) PCI-to-PCI bridge:
(II) Bus 2: bridge is at (0:28:0), (0,2,2), BCTRL: 0x0004 (VGA_EN is cleare=
d)
(II) PCI-to-PCI bridge:
(II) Bus 3: bridge is at (0:28:1), (0,3,3), BCTRL: 0x0004 (VGA_EN is cleare=
d)
(II) Bus 3 non-prefetchable memory range:
	[0] -1	0	0xf2500000 - 0xf25fffff (0x100000) MX[B]
(II) PCI-to-PCI bridge:
(II) Bus 5: bridge is at (0:28:3), (0,5,12), BCTRL: 0x0004 (VGA_EN is clear=
ed)
(II) Bus 5 I/O range:
	[0] -1	0	0x00002000 - 0x000020ff (0x100) IX[B]
	[1] -1	0	0x00002400 - 0x000024ff (0x100) IX[B]
	[2] -1	0	0x00002800 - 0x000028ff (0x100) IX[B]
	[3] -1	0	0x00002c00 - 0x00002cff (0x100) IX[B]
(II) Bus 5 non-prefetchable memory range:
	[0] -1	0	0xf0000000 - 0xf1ffffff (0x2000000) MX[B]
(II) Bus 5 prefetchable memory range:
	[0] -1	0	0xf2900000 - 0xf29fffff (0x100000) MX[B]
(II) Subtractive PCI-to-PCI bridge:
(II) Bus 13: bridge is at (0:30:0), (0,13,13), BCTRL: 0x0004 (VGA_EN is cle=
ared)
(II) PCI-to-ISA bridge:
(II) Bus -1: bridge is at (0:31:0), (0,-1,-1), BCTRL: 0x0008 (VGA_EN is set)
(--) PCI:*(0:2:0) Intel Corporation Mobile Integrated Graphics Controller r=
ev 7, Mem @ 0xf2000000/22, 0xd0000000/28, I/O @ 0x1800/3
(--) PCI: (0:2:1) Intel Corporation Mobile Integrated Graphics Controller r=
ev 7, Mem @ 0xf2400000/20
(II) Addressable bus resource ranges are
	[0] -1	0	0x00000000 - 0xffffffff (0x100000000) MX[B]
	[1] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) OS-reported resource ranges:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
(II) Active PCI resource ranges:
	[0] -1	0	0xf2500000 - 0xf2501fff (0x2000) MX[B]
	[1] -1	0	0xf2827400 - 0xf28274ff (0x100) MX[B]
	[2] -1	0	0xf2826000 - 0xf28267ff (0x800) MX[B]
	[3] -1	0	0xf2827000 - 0xf28273ff (0x400) MX[B]
	[4] -1	0	0xf2620000 - 0xf2623fff (0x4000) MX[B]
	[5] -1	0	0xf2826c00 - 0xf2826fff (0x400) MX[B]
	[6] -1	0	0xf2625000 - 0xf2625fff (0x1000) MX[B]
	[7] -1	0	0xf2600000 - 0xf261ffff (0x20000) MX[B]
	[8] -1	0	0xf2826800 - 0xf282680f (0x10) MX[B]
	[9] -1	0	0xf2400000 - 0xf24fffff (0x100000) MX[B](B)
	[10] -1	0	0xd0000000 - 0xdfffffff (0x10000000) MX[B](B)
	[11] -1	0	0xf2000000 - 0xf23fffff (0x400000) MX[B](B)
	[12] -1	0	0x00001c60 - 0x00001c7f (0x20) IX[B]
	[13] -1	0	0x00001c20 - 0x00001c3f (0x20) IX[B]
	[14] -1	0	0x00001838 - 0x0000183b (0x4) IX[B]
	[15] -1	0	0x00001c40 - 0x00001c47 (0x8) IX[B]
	[16] -1	0	0x0000183c - 0x0000183f (0x4) IX[B]
	[17] -1	0	0x00001c48 - 0x00001c4f (0x8) IX[B]
	[18] -1	0	0x00001c00 - 0x00001c1f (0x20) IX[B]
	[19] -1	0	0x000018e0 - 0x000018ff (0x20) IX[B]
	[20] -1	0	0x000018c0 - 0x000018df (0x20) IX[B]
	[21] -1	0	0x000018a0 - 0x000018bf (0x20) IX[B]
	[22] -1	0	0x00001880 - 0x0000189f (0x20) IX[B]
	[23] -1	0	0x00001860 - 0x0000187f (0x20) IX[B]
	[24] -1	0	0x00001840 - 0x0000185f (0x20) IX[B]
	[25] -1	0	0x00001800 - 0x00001807 (0x8) IX[B](B)
(II) Active PCI resource ranges after removing overlaps:
	[0] -1	0	0xf2500000 - 0xf2501fff (0x2000) MX[B]
	[1] -1	0	0xf2827400 - 0xf28274ff (0x100) MX[B]
	[2] -1	0	0xf2826000 - 0xf28267ff (0x800) MX[B]
	[3] -1	0	0xf2827000 - 0xf28273ff (0x400) MX[B]
	[4] -1	0	0xf2620000 - 0xf2623fff (0x4000) MX[B]
	[5] -1	0	0xf2826c00 - 0xf2826fff (0x400) MX[B]
	[6] -1	0	0xf2625000 - 0xf2625fff (0x1000) MX[B]
	[7] -1	0	0xf2600000 - 0xf261ffff (0x20000) MX[B]
	[8] -1	0	0xf2826800 - 0xf282680f (0x10) MX[B]
	[9] -1	0	0xf2400000 - 0xf24fffff (0x100000) MX[B](B)
	[10] -1	0	0xd0000000 - 0xdfffffff (0x10000000) MX[B](B)
	[11] -1	0	0xf2000000 - 0xf23fffff (0x400000) MX[B](B)
	[12] -1	0	0x00001c60 - 0x00001c7f (0x20) IX[B]
	[13] -1	0	0x00001c20 - 0x00001c3f (0x20) IX[B]
	[14] -1	0	0x00001838 - 0x0000183b (0x4) IX[B]
	[15] -1	0	0x00001c40 - 0x00001c47 (0x8) IX[B]
	[16] -1	0	0x0000183c - 0x0000183f (0x4) IX[B]
	[17] -1	0	0x00001c48 - 0x00001c4f (0x8) IX[B]
	[18] -1	0	0x00001c00 - 0x00001c1f (0x20) IX[B]
	[19] -1	0	0x000018e0 - 0x000018ff (0x20) IX[B]
	[20] -1	0	0x000018c0 - 0x000018df (0x20) IX[B]
	[21] -1	0	0x000018a0 - 0x000018bf (0x20) IX[B]
	[22] -1	0	0x00001880 - 0x0000189f (0x20) IX[B]
	[23] -1	0	0x00001860 - 0x0000187f (0x20) IX[B]
	[24] -1	0	0x00001840 - 0x0000185f (0x20) IX[B]
	[25] -1	0	0x00001800 - 0x00001807 (0x8) IX[B](B)
(II) OS-reported resource ranges after removing overlaps with PCI:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
(II) All system resource ranges:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xf2500000 - 0xf2501fff (0x2000) MX[B]
	[5] -1	0	0xf2827400 - 0xf28274ff (0x100) MX[B]
	[6] -1	0	0xf2826000 - 0xf28267ff (0x800) MX[B]
	[7] -1	0	0xf2827000 - 0xf28273ff (0x400) MX[B]
	[8] -1	0	0xf2620000 - 0xf2623fff (0x4000) MX[B]
	[9] -1	0	0xf2826c00 - 0xf2826fff (0x400) MX[B]
	[10] -1	0	0xf2625000 - 0xf2625fff (0x1000) MX[B]
	[11] -1	0	0xf2600000 - 0xf261ffff (0x20000) MX[B]
	[12] -1	0	0xf2826800 - 0xf282680f (0x10) MX[B]
	[13] -1	0	0xf2400000 - 0xf24fffff (0x100000) MX[B](B)
	[14] -1	0	0xd0000000 - 0xdfffffff (0x10000000) MX[B](B)
	[15] -1	0	0xf2000000 - 0xf23fffff (0x400000) MX[B](B)
	[16] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[17] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[18] -1	0	0x00001c60 - 0x00001c7f (0x20) IX[B]
	[19] -1	0	0x00001c20 - 0x00001c3f (0x20) IX[B]
	[20] -1	0	0x00001838 - 0x0000183b (0x4) IX[B]
	[21] -1	0	0x00001c40 - 0x00001c47 (0x8) IX[B]
	[22] -1	0	0x0000183c - 0x0000183f (0x4) IX[B]
	[23] -1	0	0x00001c48 - 0x00001c4f (0x8) IX[B]
	[24] -1	0	0x00001c00 - 0x00001c1f (0x20) IX[B]
	[25] -1	0	0x000018e0 - 0x000018ff (0x20) IX[B]
	[26] -1	0	0x000018c0 - 0x000018df (0x20) IX[B]
	[27] -1	0	0x000018a0 - 0x000018bf (0x20) IX[B]
	[28] -1	0	0x00001880 - 0x0000189f (0x20) IX[B]
	[29] -1	0	0x00001860 - 0x0000187f (0x20) IX[B]
	[30] -1	0	0x00001840 - 0x0000185f (0x20) IX[B]
	[31] -1	0	0x00001800 - 0x00001807 (0x8) IX[B](B)
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions//libextmod.so
(II) Module extmod: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension SHAPE
(II) Loading extension MIT-SUNDRY-NONSTANDARD
(II) Loading extension BIG-REQUESTS
(II) Loading extension SYNC
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XC-MISC
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-Misc
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension TOG-CUP
(II) Loading extension Extended-Visual-Information
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions//libdbe.so
(II) Module dbe: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions//libglx.so
(II) Module glx: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(=3D=3D) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "freetype"
(II) Loading /usr/lib/xorg/modules//fonts/libfreetype.so
(II) Module freetype: vendor=3D"X.Org Foundation & the After X-TT Project"
	compiled for 1.4.2, module version =3D 2.1.0
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.5
(II) Loading font FreeType
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions//librecord.so
(II) Module record: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension RECORD
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions//libdri.so
(II) Module dri: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension XFree86-DRI
(II) LoadModule: "intel"
(II) Loading /usr/lib/xorg/modules/drivers//intel_drv.so
(II) Module intel: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 2.3.2
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 2.0
(II) LoadModule: "mouse"
(II) Loading /usr/lib/xorg/modules/input//mouse_drv.so
(II) Module mouse: vendor=3D"X.Org Foundation"
	compiled for 1.4.0.90, module version =3D 1.3.0
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 2.0
(II) LoadModule: "kbd"
(II) Loading /usr/lib/xorg/modules/input//kbd_drv.so
(II) Module kbd: vendor=3D"X.Org Foundation"
	compiled for 1.4.0.90, module version =3D 1.3.1
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 2.0
(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, 965G, G35, 965Q, 946GZ,
	965GM, 965GME/GLE, G33, Q35, Q33,
	Mobile Intel=AE GM45 Express Chipset,
	Intel Integrated Graphics Device, G45/G43, Q45/Q43, G41
(II) Primary Device is: PCI 00:02:0
(--) Assigning device section with no busID to primary device
(WW) intel: No matching Device section for instance (BusID PCI:0:2:1) found
(--) Chipset Mobile Intel=AE GM45 Express Chipset found
(II) resource ranges after xf86ClaimFixedResources() call:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xf2500000 - 0xf2501fff (0x2000) MX[B]
	[5] -1	0	0xf2827400 - 0xf28274ff (0x100) MX[B]
	[6] -1	0	0xf2826000 - 0xf28267ff (0x800) MX[B]
	[7] -1	0	0xf2827000 - 0xf28273ff (0x400) MX[B]
	[8] -1	0	0xf2620000 - 0xf2623fff (0x4000) MX[B]
	[9] -1	0	0xf2826c00 - 0xf2826fff (0x400) MX[B]
	[10] -1	0	0xf2625000 - 0xf2625fff (0x1000) MX[B]
	[11] -1	0	0xf2600000 - 0xf261ffff (0x20000) MX[B]
	[12] -1	0	0xf2826800 - 0xf282680f (0x10) MX[B]
	[13] -1	0	0xf2400000 - 0xf24fffff (0x100000) MX[B](B)
	[14] -1	0	0xd0000000 - 0xdfffffff (0x10000000) MX[B](B)
	[15] -1	0	0xf2000000 - 0xf23fffff (0x400000) MX[B](B)
	[16] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[17] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[18] -1	0	0x00001c60 - 0x00001c7f (0x20) IX[B]
	[19] -1	0	0x00001c20 - 0x00001c3f (0x20) IX[B]
	[20] -1	0	0x00001838 - 0x0000183b (0x4) IX[B]
	[21] -1	0	0x00001c40 - 0x00001c47 (0x8) IX[B]
	[22] -1	0	0x0000183c - 0x0000183f (0x4) IX[B]
	[23] -1	0	0x00001c48 - 0x00001c4f (0x8) IX[B]
	[24] -1	0	0x00001c00 - 0x00001c1f (0x20) IX[B]
	[25] -1	0	0x000018e0 - 0x000018ff (0x20) IX[B]
	[26] -1	0	0x000018c0 - 0x000018df (0x20) IX[B]
	[27] -1	0	0x000018a0 - 0x000018bf (0x20) IX[B]
	[28] -1	0	0x00001880 - 0x0000189f (0x20) IX[B]
	[29] -1	0	0x00001860 - 0x0000187f (0x20) IX[B]
	[30] -1	0	0x00001840 - 0x0000185f (0x20) IX[B]
	[31] -1	0	0x00001800 - 0x00001807 (0x8) IX[B](B)
(II) resource ranges after probing:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xf2500000 - 0xf2501fff (0x2000) MX[B]
	[5] -1	0	0xf2827400 - 0xf28274ff (0x100) MX[B]
	[6] -1	0	0xf2826000 - 0xf28267ff (0x800) MX[B]
	[7] -1	0	0xf2827000 - 0xf28273ff (0x400) MX[B]
	[8] -1	0	0xf2620000 - 0xf2623fff (0x4000) MX[B]
	[9] -1	0	0xf2826c00 - 0xf2826fff (0x400) MX[B]
	[10] -1	0	0xf2625000 - 0xf2625fff (0x1000) MX[B]
	[11] -1	0	0xf2600000 - 0xf261ffff (0x20000) MX[B]
	[12] -1	0	0xf2826800 - 0xf282680f (0x10) MX[B]
	[13] -1	0	0xf2400000 - 0xf24fffff (0x100000) MX[B](B)
	[14] -1	0	0xd0000000 - 0xdfffffff (0x10000000) MX[B](B)
	[15] -1	0	0xf2000000 - 0xf23fffff (0x400000) MX[B](B)
	[16] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[17] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[18] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[19] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[20] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[21] -1	0	0x00001c60 - 0x00001c7f (0x20) IX[B]
	[22] -1	0	0x00001c20 - 0x00001c3f (0x20) IX[B]
	[23] -1	0	0x00001838 - 0x0000183b (0x4) IX[B]
	[24] -1	0	0x00001c40 - 0x00001c47 (0x8) IX[B]
	[25] -1	0	0x0000183c - 0x0000183f (0x4) IX[B]
	[26] -1	0	0x00001c48 - 0x00001c4f (0x8) IX[B]
	[27] -1	0	0x00001c00 - 0x00001c1f (0x20) IX[B]
	[28] -1	0	0x000018e0 - 0x000018ff (0x20) IX[B]
	[29] -1	0	0x000018c0 - 0x000018df (0x20) IX[B]
	[30] -1	0	0x000018a0 - 0x000018bf (0x20) IX[B]
	[31] -1	0	0x00001880 - 0x0000189f (0x20) IX[B]
	[32] -1	0	0x00001860 - 0x0000187f (0x20) IX[B]
	[33] -1	0	0x00001840 - 0x0000185f (0x20) IX[B]
	[34] -1	0	0x00001800 - 0x00001807 (0x8) IX[B](B)
	[35] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B]
	[36] 0	0	0x000003c0 - 0x000003df (0x20) IS[B]
(II) Setting vga for screen 0.
(II) Loading sub module "int10"
(II) LoadModule: "int10"
(II) Loading /usr/lib/xorg/modules//libint10.so
(II) Module int10: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 1.0.0
	ABI class: X.Org Video Driver, version 2.0
(II) Loading sub module "vbe"
(II) LoadModule: "vbe"
(II) Loading /usr/lib/xorg/modules//libvbe.so
(II) Module vbe: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 1.1.0
	ABI class: X.Org Video Driver, version 2.0
(II) Loading sub module "vgahw"
(II) LoadModule: "vgahw"
(II) Loading /usr/lib/xorg/modules//libvgahw.so
(II) Module vgahw: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 0.1.0
	ABI class: X.Org Video Driver, version 2.0
(=3D=3D) intel(0): Depth 24, (--) framebuffer bpp 32
(=3D=3D) intel(0): RGB weight 888
(=3D=3D) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) Mobile Intel=AE GM45 E=
xpress Chipset
(--) intel(0): Chipset: "Mobile Intel=AE GM45 Express Chipset"
(--) intel(0): Linear framebuffer at 0xD0000000
(--) intel(0): IO registers at addr 0xF2000000
(II) intel(0): 2 display pipes available.
(=3D=3D) intel(0): Using EXA for acceleration
(=3D=3D) intel(0): Disabling EXA render acceleration
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"(II) Module "ddc" already built-in
(II) Loading sub module "i2c"
(II) LoadModule: "i2c"(II) Module "i2c" already built-in
(II) intel(0): Output VGA using monitor section Configured Monitor
(II) intel(0): I2C bus "CRTDDC_A" initialized.
(II) intel(0): Output LVDS has no monitor section
(II) intel(0): I2C bus "LVDSDDC_C" initialized.
(II) intel(0): Attempting to determine panel fixed mode.
(II) intel(0): I2C device "LVDSDDC_C:ddc2" registered at address 0xA0.
(II) intel(0): EDID vendor "LEN", prod id 16400
(II) Loading sub module "int10"
(II) LoadModule: "int10"
(II) Reloading /usr/lib/xorg/modules//libint10.so
(II) intel(0): initializing int10
(WW) intel(0): Bad V_BIOS checksum
(II) intel(0): Primary V_BIOS segment is: 0xc000
(II) intel(0): VESA BIOS detected
(II) intel(0): VESA VBE Version 3.0
(II) intel(0): VESA VBE Total Mem: 32704 kB
(II) intel(0): VESA VBE OEM: Intel(r)Cantiga Graphics Chip Accelerated VGA =
BIOS
(II) intel(0): VESA VBE OEM Software Rev: 1.0
(II) intel(0): VESA VBE OEM Vendor: Intel Corporation
(II) intel(0): VESA VBE OEM Product: Intel(r)Cantiga Graphics Controller
(II) intel(0): VESA VBE OEM Product Rev: Hardware Version 0.0
(II) intel(0): found backlight control method /sys/class/backlight/acpi_vid=
eo0
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOB" initialized.
(II) intel(0): I2C device "SDVOCTRL_E for SDVOB:SDVO Controller B" register=
ed at address 0x70.
(II) intel(0): No SDVO device found on SDVOB
(II) intel(0): I2C device "SDVOCTRL_E for SDVOB:SDVO Controller B" removed.
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOB" removed.
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOC" initialized.
(II) intel(0): I2C device "SDVOCTRL_E for SDVOC:SDVO Controller C" register=
ed at address 0x72.
(II) intel(0): No SDVO device found on SDVOC
(II) intel(0): I2C device "SDVOCTRL_E for SDVOC:SDVO Controller C" removed.
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOC" removed.
(II) intel(0): Output TV has no monitor section
(II) intel(0): I2C device "CRTDDC_A:ddc2" registered at address 0xA0.
(II) intel(0): EDID vendor "SAM", prod id 32
(II) intel(0): Using EDID range info for horizontal sync
(II) intel(0): Using EDID range info for vertical refresh
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 =
1025 1028 1066 +hsync +vsync (64.0 kHz)
(II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 60=
5 628 +hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 60=
3 625 +hsync +vsync (35.2 kHz)
(II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484=
 500 -hsync -vsync (37.5 kHz)
(II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 491=
 520 -hsync -vsync (37.9 kHz)
(II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486=
 525 -hsync -vsync (35.0 kHz)
(II) intel(0): Modeline "640x480"x0.0   25.20  640 656 752 800  480 490 492=
 525 -hsync -vsync (31.5 kHz)
(II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414=
 449 -hsync +vsync (31.5 kHz)
(II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 =
1025 1028 1066 +hsync +vsync (80.0 kHz)
(II) intel(0): Modeline "1024x768"x0.0   78.80  1024 1040 1136 1312  768 76=
9 772 800 +hsync +vsync (60.1 kHz)
(II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 77=
1 777 806 -hsync -vsync (56.5 kHz)
(II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 77=
1 777 806 -hsync -vsync (48.4 kHz)
(II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 62=
8 667 -hsync -vsync (49.7 kHz)
(II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 60=
4 625 +hsync +vsync (46.9 kHz)
(II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 64=
3 666 +hsync +vsync (48.1 kHz)
(II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 86=
5 868 900 +hsync +vsync (67.5 kHz)
(II) intel(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1496 1712  1024=
 1027 1034 1063 -hsync +vsync (63.7 kHz)
(II) intel(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 1328  768 7=
71 775 798 -hsync +vsync (47.8 kHz)
(II) intel(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 6=
07 624 -hsync +vsync (37.4 kHz)
(II) intel(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 48=
7 500 -hsync +vsync (29.7 kHz)
(II) intel(0): EDID vendor "SAM", prod id 32
(II) intel(0): EDID vendor "LEN", prod id 16400
(II) intel(0): Output VGA connected
(II) intel(0): Output LVDS connected
(II) intel(0): Output TV disconnected
(II) intel(0): Output VGA using initial mode 1280x1024
(II) intel(0): Output LVDS using initial mode 1280x800
(II) intel(0): Monitoring connected displays enabled
(II) intel(0): detected 512 kB GTT.
(II) intel(0): detected 32764 kB stolen memory.
(=3D=3D) intel(0): video overlay key set to 0x101fe
(=3D=3D) intel(0): Will not try to enable page flipping
(=3D=3D) intel(0): Triple buffering disabled
(=3D=3D) intel(0): Intel XvMC decoder disabled
(=3D=3D) intel(0): Using gamma correction (1.0, 1.0, 1.0)
(**) intel(0): Display dimensions: (340, 270) mm
(**) intel(0): DPI set to (224, 282)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules//libfb.so
(II) Module fb: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.3
(II) Loading sub module "exa"
(II) LoadModule: "exa"
(II) Loading /usr/lib/xorg/modules//libexa.so
(II) Module exa: vendor=3D"X.Org Foundation"
	compiled for 1.4.2, module version =3D 2.2.0
	ABI class: X.Org Video Driver, version 2.0
(II) Loading sub module "ramdac"
(II) LoadModule: "ramdac"(II) Module "ramdac" already built-in
(II) intel(0): Comparing regs from server start up to After PreInit
(WW) intel(0): Register 0x61114 (PORT_HOTPLUG_STAT) changed from 0x10000b00=
 to 0x10000f00
(WW) intel(0): Register 0x70024 (PIPEASTAT) changed from 0x80000206 to 0x80=
000236
(WW) intel(0): PIPEASTAT before: status: FIFO_UNDERRUN VSYNC_INT_STATUS SVB=
LANK_INT_STATUS VBLANK_INT_STATUS
(WW) intel(0): PIPEASTAT after: status: FIFO_UNDERRUN VSYNC_INT_STATUS OFIE=
LD_INT_STATUS EFIELD_INT_STATUS SVBLANK_INT_STATUS VBLANK_INT_STATUS
(WW) intel(0): Register 0x321b (FBC_FENCE_OFF) changed from 0xa2020500 to 0=
xb4008d00
(WW) intel(0): Register 0x68000 (TV_CTL) changed from 0x00000010 to 0x000c0=
010
(WW) intel(0): Register 0x68010 (TV_CSC_Y) changed from 0x00000000 to 0x033=
2012d
(WW) intel(0): Register 0x68014 (TV_CSC_Y2) changed from 0x00000000 to 0x07=
d30104
(WW) intel(0): Register 0x68018 (TV_CSC_U) changed from 0x00000000 to 0x073=
3052d
(WW) intel(0): Register 0x6801c (TV_CSC_U2) changed from 0x00000000 to 0x05=
c70200
(WW) intel(0): Register 0x68020 (TV_CSC_V) changed from 0x00000000 to 0x034=
0030c
(WW) intel(0): Register 0x68024 (TV_CSC_V2) changed from 0x00000000 to 0x06=
d00200
(WW) intel(0): Register 0x68028 (TV_CLR_KNOBS) changed from 0x00000000 to 0=
x00606000
(WW) intel(0): Register 0x6802c (TV_CLR_LEVEL) changed from 0x00000000 to 0=
x010b00e1
(WW) intel(0): Register 0x68030 (TV_H_CTL_1) changed from 0x00000000 to 0x0=
0400359
(WW) intel(0): Register 0x68034 (TV_H_CTL_2) changed from 0x00000000 to 0x8=
0480022
(WW) intel(0): Register 0x68038 (TV_H_CTL_3) changed from 0x00000000 to 0x0=
07c0344
(WW) intel(0): Register 0x6803c (TV_V_CTL_1) changed from 0x00000000 to 0x0=
0f01415
(WW) intel(0): Register 0x68040 (TV_V_CTL_2) changed from 0x00000000 to 0x0=
0060607
(WW) intel(0): Register 0x68044 (TV_V_CTL_3) changed from 0x00000000 to 0x8=
0120001
(WW) intel(0): Register 0x68048 (TV_V_CTL_4) changed from 0x00000000 to 0x0=
00900f0
(WW) intel(0): Register 0x6804c (TV_V_CTL_5) changed from 0x00000000 to 0x0=
00a00f0
(WW) intel(0): Register 0x68050 (TV_V_CTL_6) changed from 0x00000000 to 0x0=
00900f0
(WW) intel(0): Register 0x68054 (TV_V_CTL_7) changed from 0x00000000 to 0x0=
00a00f0
(WW) intel(0): Register 0x68060 (TV_SC_CTL_1) changed from 0x00000000 to 0x=
c1710088
(WW) intel(0): Register 0x68064 (TV_SC_CTL_2) changed from 0x00000000 to 0x=
4e2d1dc8
(WW) intel(0): Register 0x68070 (TV_WIN_POS) changed from 0x00000000 to 0x0=
0360024
(WW) intel(0): Register 0x68074 (TV_WIN_SIZE) changed from 0x00000000 to 0x=
02640198
(WW) intel(0): Register 0x68080 (TV_FILTER_CTL_1) changed from 0x00000000 t=
o 0x8000085e
(WW) intel(0): Register 0x68084 (TV_FILTER_CTL_2) changed from 0x00000000 t=
o 0x00012d2d
(WW) intel(0): Register 0x68088 (TV_FILTER_CTL_3) changed from 0x00000000 t=
o 0x00009696
(WW) intel(0): Register 0x68100 (TV_H_LUMA_0) changed from 0x00000000 to 0x=
b1403000
(WW) intel(0): Register 0x681ec (TV_H_LUMA_59) changed from 0x00000000 to 0=
x0000b060
(WW) intel(0): Register 0x68200 (TV_H_CHROMA_0) changed from 0x00000000 to =
0xb1403000
(WW) intel(0): Register 0x682ec (TV_H_CHROMA_59) changed from 0x00000000 to=
 0x0000b060
(=3D=3D) Depth 24 pixmap format is 32 bpp
(II) do I need RAC?  No, I don't.
(II) resource ranges after preInit:
	[0] 0	0	0xd0000000 - 0xdfffffff (0x10000000) MS[B]
	[1] 0	0	0xf2000000 - 0xf23fffff (0x400000) MS[B]
	[2] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[3] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[4] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[5] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[6] -1	0	0xf2500000 - 0xf2501fff (0x2000) MX[B]
	[7] -1	0	0xf2827400 - 0xf28274ff (0x100) MX[B]
	[8] -1	0	0xf2826000 - 0xf28267ff (0x800) MX[B]
	[9] -1	0	0xf2827000 - 0xf28273ff (0x400) MX[B]
	[10] -1	0	0xf2620000 - 0xf2623fff (0x4000) MX[B]
	[11] -1	0	0xf2826c00 - 0xf2826fff (0x400) MX[B]
	[12] -1	0	0xf2625000 - 0xf2625fff (0x1000) MX[B]
	[13] -1	0	0xf2600000 - 0xf261ffff (0x20000) MX[B]
	[14] -1	0	0xf2826800 - 0xf282680f (0x10) MX[B]
	[15] -1	0	0xf2400000 - 0xf24fffff (0x100000) MX[B](B)
	[16] -1	0	0xd0000000 - 0xdfffffff (0x10000000) MX[B](B)
	[17] -1	0	0xf2000000 - 0xf23fffff (0x400000) MX[B](B)
	[18] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B](OprD)
	[19] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B](OprD)
	[20] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B](OprD)
	[21] 0	0	0x00001800 - 0x00001807 (0x8) IS[B]
	[22] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[23] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[24] -1	0	0x00001c60 - 0x00001c7f (0x20) IX[B]
	[25] -1	0	0x00001c20 - 0x00001c3f (0x20) IX[B]
	[26] -1	0	0x00001838 - 0x0000183b (0x4) IX[B]
	[27] -1	0	0x00001c40 - 0x00001c47 (0x8) IX[B]
	[28] -1	0	0x0000183c - 0x0000183f (0x4) IX[B]
	[29] -1	0	0x00001c48 - 0x00001c4f (0x8) IX[B]
	[30] -1	0	0x00001c00 - 0x00001c1f (0x20) IX[B]
	[31] -1	0	0x000018e0 - 0x000018ff (0x20) IX[B]
	[32] -1	0	0x000018c0 - 0x000018df (0x20) IX[B]
	[33] -1	0	0x000018a0 - 0x000018bf (0x20) IX[B]
	[34] -1	0	0x00001880 - 0x0000189f (0x20) IX[B]
	[35] -1	0	0x00001860 - 0x0000187f (0x20) IX[B]
	[36] -1	0	0x00001840 - 0x0000185f (0x20) IX[B]
	[37] -1	0	0x00001800 - 0x00001807 (0x8) IX[B](B)
	[38] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B](OprU)
	[39] 0	0	0x000003c0 - 0x000003df (0x20) IS[B](OprU)
(II) intel(0): Kernel reported 478208 total, 1 used
(II) intel(0): I830CheckAvailableMemory: 1912828 kB available
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is -1, (No such device or address)
drmOpenDevice: open result is -1, (No such device or address)
drmOpenDevice: Open failed
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is -1, (No such device or address)
drmOpenDevice: open result is -1, (No such device or address)
drmOpenDevice: Open failed
drmOpenByBusid: Searching for BusID pci:0000:00:02.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 9, (OK)
drmOpenByBusid: drmOpenMinor returns 9
drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
(II) [drm] loaded kernel module for "i915" driver.
(II) [drm] DRM interface version 1.3
(II) [drm] DRM open master succeeded.
(II) intel(0): [drm] Using the DRM lock SAREA also for drawables.
(II) intel(0): [drm] framebuffer mapped by ddx driver
(II) intel(0): [drm] added 1 reserved context for kernel
(II) intel(0): X context handle =3D 0x1
(II) intel(0): [drm] installed DRM signal handler
(**) intel(0): Framebuffer compression disabled
(**) intel(0): Tiling enabled
(=3D=3D) intel(0): VideoRam: 262144 KB
(II) intel(0): Attempting memory allocation with tiled buffers.
(II) intel(0): Tiled allocation successful.
(II) intel(0): [drm] Registers =3D 0xf2000000
(II) intel(0): [drm] ring buffer =3D 0xd0000000
(II) intel(0): [drm] mapped front buffer at 0xd0100000, handle =3D 0xd01000=
00
(II) intel(0): [drm] mapped back buffer at 0xd8da1000, handle =3D 0xd8da1000
(II) intel(0): [drm] mapped depth buffer at 0xdb0e1000, handle =3D 0xdb0e10=
00
(II) intel(0): [drm] mapped classic textures at 0xdd421000, handle =3D 0xdd=
421000
(II) intel(0): [drm] Initialized kernel agp heap manager, 33554432
(II) intel(0): [dri] visual configs initialized
(II) intel(0): Page Flipping disabled
(=3D=3D) intel(0): Write-combining range (0xd0000000,0x10000000)
(II) intel(0): vgaHWGetIOBase: hwp->IOBase is 0x03d0, hwp->PIOOffset is 0x0=
000
(II) intel(0): Disable render standby.
(II) EXA(0): Offscreen pixmap area of 110592000 bytes
(II) EXA(0): Driver registered support for the following operations:
(II)         Solid
(II)         Copy
(=3D=3D) intel(0): Backing store disabled
(=3D=3D) intel(0): Silken mouse enabled
(II) intel(0): Initializing HW Cursor
(II) intel(0): [DRI] installation complete
(II) intel(0): xf86BindGARTMemory: bind key 0 at 0x01fff000 (pgoffset 8191)
(II) intel(0): xf86BindGARTMemory: bind key 1 at 0x02428000 (pgoffset 9256)
(II) intel(0): xf86BindGARTMemory: bind key 2 at 0x08da0000 (pgoffset 36256)
(II) intel(0): xf86BindGARTMemory: bind key 3 at 0x08da1000 (pgoffset 36257)
(II) intel(0): xf86BindGARTMemory: bind key 4 at 0x0b0e1000 (pgoffset 45281)
(II) intel(0): xf86BindGARTMemory: bind key 5 at 0x0d421000 (pgoffset 54305)
(II) intel(0): Fixed memory allocation layout:
(II) intel(0): 0x00000000-0x0001ffff: ring buffer (128 kB)
(II) intel(0): 0x00020000-0x00029fff: HW cursors (40 kB)
(II) intel(0): 0x0002a000-0x00031fff: logical 3D context (32 kB)
(II) intel(0): 0x00032000-0x00041fff: exa G965 state buffer (64 kB)
(II) intel(0): 0x00042000-0x00042fff: power context (4 kB)
(II) intel(0): 0x00100000-0x02427fff: front buffer (36000 kB) X tiled
(II) intel(0): 0x01fff000:            end of stolen memory
(II) intel(0): 0x02428000-0x08d9ffff: exa offscreen (108000 kB)
(II) intel(0): 0x08da0000-0x08da0fff: HW status (4 kB)
(II) intel(0): 0x08da1000-0x0b0e0fff: back buffer (36096 kB) X tiled
(II) intel(0): 0x0b0e1000-0x0d420fff: depth buffer (36096 kB) Y tiled
(II) intel(0): 0x0d421000-0x0f420fff: classic textures (32768 kB)
(II) intel(0): 0x10000000:            end of aperture
(II) intel(0): Selecting standard 18 bit TMDS pixel format.
(II) intel(0): Output configuration:
(II) intel(0):   Pipe A is on
(II) intel(0):   Display plane A is now enabled and connected to pipe A.
(II) intel(0):   Pipe B is on
(II) intel(0):   Display plane B is now enabled and connected to pipe B.
(II) intel(0):   Output VGA is connected to pipe A
(II) intel(0):   Output LVDS is connected to pipe B
(II) intel(0):   Output TV is connected to pipe none
(EE) intel(0): hw status page initialization Failed
(EE) intel(0): Fail to setup hardware status page.
(II) intel(0): [drm] removed 1 reserved context for kernel
(II) intel(0): [drm] unmapping 8192 bytes of SAREA 0x1efff000 at 0x7f948ca7=
c000
(II) intel(0): [drm] Closed DRM master.

Fatal server error:
AddScreen/ScreenInit failed for driver 0

(II) intel(0): xf86UnbindGARTMemory: unbind key 0
(II) intel(0): xf86UnbindGARTMemory: unbind key 1
(II) intel(0): xf86UnbindGARTMemory: unbind key 2
(II) intel(0): xf86UnbindGARTMemory: unbind key 3
(II) intel(0): xf86UnbindGARTMemory: unbind key 4
(II) intel(0): xf86UnbindGARTMemory: unbind key 5

dmesg:


[    0.000000] Linux version 2.6.29-rc5-ikn-dirty (compiler@ikn) (gcc versi=
on 4.3.2 (Debian 4.3.2-1.1) ) #15 SMP PREEMPT Mon Feb 16 13:57:11 CET 2009
[    0.000000] Command line: root=3D/dev/sda1 ro=20
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007c4a1000 (usable)
[    0.000000]  BIOS-e820: 000000007c4a1000 - 000000007c4a7000 (reserved)
[    0.000000]  BIOS-e820: 000000007c4a7000 - 000000007c5b7000 (usable)
[    0.000000]  BIOS-e820: 000000007c5b7000 - 000000007c60f000 (reserved)
[    0.000000]  BIOS-e820: 000000007c60f000 - 000000007c6c6000 (usable)
[    0.000000]  BIOS-e820: 000000007c6c6000 - 000000007c6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c6d1000 - 000000007c6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007c6d4000 - 000000007c6d8000 (reserved)
[    0.000000]  BIOS-e820: 000000007c6d8000 - 000000007c6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c6dc000 - 000000007c6df000 (reserved)
[    0.000000]  BIOS-e820: 000000007c6df000 - 000000007c706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c706000 - 000000007c708000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007c708000 - 000000007c90f000 (reserved)
[    0.000000]  BIOS-e820: 000000007c90f000 - 000000007c99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c99f000 - 000000007c9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007c9ff000 - 000000007ca00000 (usable)
[    0.000000]  BIOS-e820: 000000007cc00000 - 000000007f000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x7ca00 max_arch_pfn =3D 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] init_memory_mapping: 0000000000000000-000000007ca00000
[    0.000000]  0000000000 - 007ca00000 page 2M
[    0.000000] kernel direct mapping tables up to 7ca00000 @ 8000-b000
[    0.000000] last_map_addr: 7ca00000 end: 7ca00000
[    0.000000] ACPI: RSDP 000F73A0, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT 7C97BD45, 009C (r1 LENOVO TP-6D        1050  LTP =
       0)
[    0.000000] ACPI: FACP 7C97BF00, 00F4 (r3 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Pm1aCo=
ntrolBlock: 16/32 [20081204]
[    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aControlBl=
ock: 32, using default 16 [20081204]
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_L=
EN (4)
[    0.000000] ACPI: DSDT 7C97C2F4, D910 (r1 LENOVO TP-6D        1050 MSFT =
 3000000)
[    0.000000] ACPI: FACS 7C98E000, 0040
[    0.000000] ACPI: SSDT 7C97C0B4, 0240 (r1 LENOVO TP-6D        1050 MSFT =
 3000000)
[    0.000000] ACPI: ECDT 7C989C04, 0052 (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: APIC 7C989C56, 0078 (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: MCFG 7C989CCE, 003C (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: HPET 7C989D0A, 0038 (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: SLIC 7C989DC2, 0176 (r1 LENOVO TP-6D        1050  LTP =
       0)
[    0.000000] ACPI: BOOT 7C989F38, 0028 (r1 LENOVO TP-6D        1050  LTP =
       1)
[    0.000000] ACPI: ASF! 7C989F60, 00A0 (r16 LENOVO TP-6D        1050 PTL =
        1)
[    0.000000] ACPI: SSDT 7C98D203, 055F (r1 LENOVO TP-6D        1050 INTL =
20050513)
[    0.000000] ACPI: TCPA 7C707000, 0032 (r0                        0      =
       0)
[    0.000000] ACPI: DMAR 7C706000, 0120 (r1               =01        1    =
         0)
[    0.000000] ACPI: SSDT 7C6D3000, 0655 (r1  PmRef    CpuPm     3000 INTL =
20050624)
[    0.000000] ACPI: SSDT 7C6D2000, 0274 (r1  PmRef  Cpu0Tst     3000 INTL =
20050624)
[    0.000000] ACPI: SSDT 7C6D1000, 0242 (r1  PmRef    ApTst     3000 INTL =
20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (5 early reservations) =3D=3D> bootmem [0000000000 - 007ca00=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000073841c]    TEXT DATA BSS =3D=3D> [000=
0200000 - 000073841c]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved =3D=3D> [000=
009ec00 - 0000100000]
[    0.000000]   #4 [0000008000 - 0000009000]          PGTABLE =3D=3D> [000=
0008000 - 0000009000]
[    0.000000] found SMP MP-table at [ffff8800000f73e0] 000f73e0
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff88000120000=
0-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007c4a1
[    0.000000]     0: 0x0007c4a7 -> 0x0007c5b7
[    0.000000]     0: 0x0007c60f -> 0x0007c6c6
[    0.000000]     0: 0x0007c9ff -> 0x0007ca00
[    0.000000] On node 0 totalpages: 509447
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1439 pages reserved
[    0.000000]   DMA zone: 2503 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6923 pages used for memmap
[    0.000000]   DMA32 zone: 498526 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7f000000=
:61000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 501029
[    0.000000] Kernel command line: root=3D/dev/sda1 ro=20
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2261.130 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 b=
ytes)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 by=
tes)
[    0.004000] Memory: 1999592k/2041856k available (2884k kernel code, 4068=
k absent, 37468k reserved, 1406k data, 348k init)
[    0.004000] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4522.26 BogoMIPS (lpj=3D9044520)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20081204
[    0.024047] Setting APIC routing to flat
[    0.024479] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.067251] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.068001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4521.96 Bog=
oMIPS (lpj=3D9043936)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.153315] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.154469] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.156022] Brought up 2 CPUs
[    0.156122] Total of 2 processors activated (9044.22 BogoMIPS).
[    0.156290] net_namespace: 1752 bytes
[    0.156290] NET: Registered protocol family 16
[    0.156290] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.156290] ACPI: bus type pci registered
[    0.160030] PCI: Using configuration type 1 for base access
[    0.160125] bio: create slab <bio-0> at 0
[    0.161338] ACPI: EC: EC description table is found, configuring boot EC
[    0.171975] ACPI: BIOS _OSI(Linux) query ignored
[    0.172016] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.188495] ACPI: Interpreter enabled
[    0.188495] ACPI: (supports S0 S3 S5)
[    0.188495] ACPI: Using IOAPIC for interrupt routing
[    0.224380] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.224380] ACPI: EC: driver started in interrupt mode
[    0.225430] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.225926] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.228060] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.228066] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.228070] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.228102] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.228148] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.228171] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.228276] pci 0000:00:03.0: PME# disabled
[    0.228452] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.228458] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.228465] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.228511] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.228511] pci 0000:00:19.0: PME# disabled
[    0.228511] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.228511] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.228511] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.228511] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.228511] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.228578] pci 0000:00:1a.7: PME# disabled
[    0.228724] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.228774] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.228879] pci 0000:00:1b.0: PME# disabled
[    0.229045] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.229150] pci 0000:00:1c.0: PME# disabled
[    0.229317] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.229423] pci 0000:00:1c.1: PME# disabled
[    0.229591] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.229696] pci 0000:00:1c.3: PME# disabled
[    0.229859] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.229940] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.230020] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.230103] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.230166] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.230272] pci 0000:00:1d.7: PME# disabled
[    0.230576] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.230582] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.230588] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.230594] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.230600] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.230606] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.230643] pci 0000:00:1f.2: PME# supported from D3hot
[    0.230747] pci 0000:00:1f.2: PME# disabled
[    0.230879] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.230894] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.231069] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.231175] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.232028] pci 0000:03:00.0: PME# disabled
[    0.232207] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.232257] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.232261] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.232267] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29f=
ffff]
[    0.232325] pci 0000:00:1e.0: transparent bridge
[    0.232454] pci_bus 0000:00: on NUMA node 0
[    0.232462] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.232647] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.232728] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.232810] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.240258] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.240853] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.240853] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.241226] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.241904] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.242583] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.243261] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.243941] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.244510] ACPI: Power Resource [PUBS] (on)
[    0.248068] SCSI subsystem initialized
[    0.248157] libata version 3.00 loaded.
[    0.248170] PCI: Using ACPI for IRQ routing
[    0.260057] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.260338] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.284007] pnp: PnP ACPI init
[    0.284111] ACPI: bus type pnp registered
[    0.345174] pnp: PnP ACPI: found 10 devices
[    0.345275] ACPI: ACPI bus type pnp unregistered
[    0.345383] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.345487] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.345592] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.345696] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.345800] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.345904] system 00:00: iomem range 0xd0000-0xd3fff has been reserved
[    0.346008] system 00:00: iomem range 0xdc000-0xdffff could not be reser=
ved
[    0.346112] system 00:00: iomem range 0xe0000-0xe3fff could not be reser=
ved
[    0.346217] system 00:00: iomem range 0xe4000-0xe7fff could not be reser=
ved
[    0.346322] system 00:00: iomem range 0xe8000-0xebfff could not be reser=
ved
[    0.346426] system 00:00: iomem range 0xec000-0xeffff could not be reser=
ved
[    0.346531] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.346642] system 00:00: iomem range 0x100000-0x7effffff could not be r=
eserved
[    0.346805] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be=
 reserved
[    0.346969] system 00:00: iomem range 0xfed4c000-0xffffffff could not be=
 reserved
[    0.347137] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.347240] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.347345] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.347448] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.347552] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.347656] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.347759] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.347863] system 00:02: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.347968] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.348073] system 00:02: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.348178] system 00:02: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.348283] system 00:02: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.348387] system 00:02: iomem range 0xfed45000-0xfed4bfff has been res=
erved
[    0.353364] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.353467] pci 0000:00:1c.0:   IO window: disabled
[    0.353571] pci 0000:00:1c.0:   MEM window: disabled
[    0.353675] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.353781] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.353883] pci 0000:00:1c.1:   IO window: disabled
[    0.353988] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.354093] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.354199] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.354303] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.354407] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.354513] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x0000=
00f29fffff
[    0.354690] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.354793] pci 0000:00:1e.0:   IO window: disabled
[    0.354897] pci 0000:00:1e.0:   MEM window: disabled
[    0.355000] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.355115] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.355222] pci 0000:00:1c.0: setting latency timer to 64
[    0.355229] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.355336] pci 0000:00:1c.1: setting latency timer to 64
[    0.355343] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.355449] pci 0000:00:1c.3: setting latency timer to 64
[    0.355455] pci 0000:00:1e.0: setting latency timer to 64
[    0.355458] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.355460] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.355462] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    0.355463] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
[    0.355465] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.355466] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.355468] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.355469] pci_bus 0000:03: resource 1 mem: [0xf2500000-0xf25fffff]
[    0.355471] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.355473] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.355474] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.355476] pci_bus 0000:05: resource 1 mem: [0xf0000000-0xf1ffffff]
[    0.355478] pci_bus 0000:05: resource 2 mem: [0xf2900000-0xf29fffff]
[    0.355479] pci_bus 0000:05: resource 3 mem: [0x0-0x0]
[    0.355481] pci_bus 0000:0d: resource 0 mem: [0x0-0x0]
[    0.355482] pci_bus 0000:0d: resource 1 mem: [0x0-0x0]
[    0.355484] pci_bus 0000:0d: resource 2 mem: [0x0-0x0]
[    0.355485] pci_bus 0000:0d: resource 3 io:  [0x00-0xffff]
[    0.355487] pci_bus 0000:0d: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.355507] NET: Registered protocol family 2
[    0.402667] IP route cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.403211] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.404917] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.405531] TCP: Hash tables configured (established 262144 bind 65536)
[    0.405636] TCP reno registered
[    0.414719] NET: Registered protocol family 1
[    0.415034] Simple Boot Flag at 0x35 set to 0x1
[    0.415969] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>=
, Peter Oruba
[    0.418309] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.420366] VFS: Disk quotas dquot_6.5.2
[    0.420530] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.421052] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.424179] msgmni has been set to 3906
[    0.424496] alg: No test for stdrng (krng)
[    0.424605] io scheduler noop registered
[    0.424707] io scheduler anticipatory registered (default)
[    0.424809] io scheduler deadline registered
[    0.424964] io scheduler cfq registered
[    0.425078] pci 0000:00:02.0: Boot video device
[    0.425322] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.425385] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.425510] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.425569] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.425692] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.425750] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.426829] ACPI: AC Adapter [AC] (on-line)
[    0.474511] ACPI: Battery Slot [BAT0] (battery present)
[    0.474731] input: Power Button (FF) as /class/input/input0
[    0.474835] ACPI: Power Button (FF) [PWRF]
[    0.475037] input: Lid Switch as /class/input/input1
[    0.476009] ACPI: Lid Switch [LID]
[    0.476173] input: Sleep Button (CM) as /class/input/input2
[    0.476280] ACPI: Sleep Button (CM) [SLPB]
[    0.477191] ACPI: SSDT 7C6D6C20, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL =
20050624)
[    0.478076] ACPI: SSDT 7C6D4020, 087A (r1  PmRef  Cpu0Cst     3001 INTL =
20050624)
[    0.482790] Monitor-Mwait will be used to enter C-1 state
[    0.482795] Monitor-Mwait will be used to enter C-2 state
[    0.482798] Monitor-Mwait will be used to enter C-3 state
[    0.482848] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.483135] processor ACPI_CPU:00: registered as cooling_device0
[    0.483288] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.484126] ACPI: SSDT 7C6D5CA0, 01CF (r1  PmRef    ApIst     3000 INTL =
20050624)
[    0.484903] ACPI: SSDT 7C6D5F20, 008D (r1  PmRef    ApCst     3000 INTL =
20050624)
[    0.487282] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.487565] processor ACPI_CPU:01: registered as cooling_device1
[    0.487670] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.532163] thermal LNXTHERM:01: registered as thermal_zone0
[    0.535842] ACPI: Thermal Zone [THM0] (46 C)
[    0.536959] thermal LNXTHERM:02: registered as thermal_zone1
[    0.538329] ACPI: Thermal Zone [THM1] (41 C)
[    0.566811] Switched to high resolution mode on CPU 1
[    0.566813] Switched to high resolution mode on CPU 0
[    0.593543] Linux agpgart interface v0.103
[    3.608008] floppy0: no floppy controllers found
[    3.609245] brd: module loaded
[    3.609413] Uniform Multi-Platform E-IDE driver
[    3.609587] ide-gd driver 1.18
[    3.609785] Driver 'sd' needs updating - please use bus_type methods
[    3.609929] ahci 0000:00:1f.2: version 3.0
[    3.609944] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.610080] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    3.610118] ahci: SSS flag set, parallel bus scan disabled
[    3.610240] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
3 impl SATA mode
[    3.610406] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part=20
[    3.610574] ahci 0000:00:1f.2: setting latency timer to 64
[    3.610739] scsi0 : ahci
[    3.610921] scsi1 : ahci
[    3.611078] scsi2 : ahci
[    3.611234] scsi3 : ahci
[    3.612191] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282610=
0 irq 27
[    3.612356] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282618=
0 irq 27
[    3.612519] ata3: DUMMY
[    3.612618] ata4: DUMMY
[    3.928015] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.935476] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    3.935478] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    3.935662] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    3.935664] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    3.936519] ata1.00: ATA-8: ST9250827AS, 3.CMF, max UDMA/100
[    3.936623] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.946561] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    3.946564] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    3.946748] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    3.946750] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    3.947597] ata1.00: configured for UDMA/100
[    3.961691] ata1.00: configured for UDMA/100
[    3.961793] ata1: EH complete
[    3.961961] scsi 0:0:0:0: Direct-Access     ATA      ST9250827AS      3.=
CM PQ: 0 ANSI: 5
[    3.962241] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    3.962416] sd 0:0:0:0: [sda] Write Protect is off
[    3.962518] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.962536] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.962753] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    3.962928] sd 0:0:0:0: [sda] Write Protect is off
[    3.963030] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.963048] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.963216]  sda: sda1 sda2 sda3
[    3.980083] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.300013] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.307845] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    4.308743] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    4.312710] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[    4.320104] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    4.321069] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    4.324996] ata2.00: configured for UDMA/133
[    4.463018] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
10 PQ: 0 ANSI: 5
[    4.492073] Fusion MPT base driver 3.04.07
[    4.492173] Copyright (c) 1999-2008 LSI Corporation
[    4.492280] Fusion MPT SPI Host driver 3.04.07
[    4.492687] ieee1394: raw1394: /dev/raw1394 device initialized
[    4.492899] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 =
irq 1,12
[    4.504658] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.504764] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.504997] mice: PS/2 mouse device common for all mice
[    4.548345] cpuidle: using governor ladder
[    4.548860] cpuidle: using governor menu
[    4.549000] Marking TSC unstable due to TSC halts in idle
[    4.549206] oprofile: using NMI interrupt.
[    4.549540] TCP cubic registered
[    4.549640] NET: Registered protocol family 17
[    4.550749] registered taskstats version 1
[    4.553073] input: AT Translated Set 2 keyboard as /class/input/input3
[    4.815508] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[    5.000156] Clocksource tsc unstable (delta =3D -408136115 ns)
[    5.132534] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    5.151511] input: TPPS/2 IBM TrackPoint as /class/input/input4
[    5.333851] VFS: Mounted root (jfs filesystem) readonly on device 8:1.
[    5.334019] Freeing unused kernel memory: 348k freed
[    8.197735] Non-volatile memory driver v1.3
[    8.279783] Driver 'sr' needs updating - please use bus_type methods
[    8.291395] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    8.291568] Uniform CD-ROM driver Revision: 3.20
[    8.291756] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    8.366926] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.367070] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    8.608913] thinkpad_acpi: ThinkPad ACPI Extras v0.22
[    8.609022] thinkpad_acpi: http://ibm-acpi.sf.net/
[    8.609123] thinkpad_acpi: ThinkPad BIOS 6DET28WW (1.05 ), EC 7XHT21WW-1=
=2E03
[    8.609228] thinkpad_acpi: Lenovo ThinkPad X200, model 7458AH8
[    8.610085] thinkpad_acpi: radio switch found; radios are enabled
[    8.610308] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[    8.610478] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[    8.619510] Registered led device: tpacpi::thinklight
[    8.619646] Registered led device: tpacpi::power
[    8.619761] Registered led device: tpacpi:orange:batt
[    8.619879] Registered led device: tpacpi:green:batt
[    8.619995] Registered led device: tpacpi::dock_active
[    8.620126] Registered led device: tpacpi::bay_active
[    8.620251] Registered led device: tpacpi::dock_batt
[    8.620377] Registered led device: tpacpi::unknown_led
[    8.620506] Registered led device: tpacpi::standby
[    8.623210] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one.
[    8.623608] input: ThinkPad Extra Buttons as /class/input/input5
[    8.669473] agpgart-intel 0000:00:00.0: Intel Mobile Intel=AE GM45 Expre=
ss Chipset
[    8.670613] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    8.673745] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    8.839018] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    8.839125] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    8.839265] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[    8.839377] e1000e 0000:00:19.0: setting latency timer to 64
[    8.839476] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[    8.906953] ACPI: WMI: Mapper loaded
[    8.927414] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:=
09:46:11
[    8.927582] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    8.927708] 0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: 1008ff-0ff
[    8.985444] usbcore: registered new interface driver usbfs
[    8.985576] usbcore: registered new interface driver hub
[    9.068062] usbcore: registered new device driver usb
[    9.289477] uhci_hcd: USB Universal Host Controller Interface driver
[    9.290177] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    9.290298] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[    9.290416] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    9.290420] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    9.290565] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    9.290764] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    9.290986] usb usb1: configuration #1 chosen from 1 choice
[    9.291113] hub 1-0:1.0: USB hub found
[    9.291218] hub 1-0:1.0: 2 ports detected
[    9.291422] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    9.291531] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    9.291534] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    9.291654] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 2
[    9.291847] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    9.292022] usb usb2: configuration #1 chosen from 1 choice
[    9.292147] hub 2-0:1.0: USB hub found
[    9.292251] hub 2-0:1.0: 2 ports detected
[    9.292874] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    9.292984] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[    9.293141] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    9.293144] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    9.293277] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 3
[    9.293470] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    9.293651] usb usb3: configuration #1 chosen from 1 choice
[    9.293776] hub 3-0:1.0: USB hub found
[    9.293880] hub 3-0:1.0: 2 ports detected
[    9.294464] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    9.294571] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    9.294680] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    9.294683] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    9.294805] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 4
[    9.294998] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    9.295171] usb usb4: configuration #1 chosen from 1 choice
[    9.295296] hub 4-0:1.0: USB hub found
[    9.295401] hub 4-0:1.0: 2 ports detected
[    9.295586] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[    9.295696] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    9.295699] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    9.295819] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 5
[    9.296013] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    9.296185] usb usb5: configuration #1 chosen from 1 choice
[    9.296310] hub 5-0:1.0: USB hub found
[    9.296414] hub 5-0:1.0: 2 ports detected
[    9.296599] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    9.296709] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    9.296712] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    9.296833] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 6
[    9.297061] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    9.297253] usb usb6: configuration #1 chosen from 1 choice
[    9.297384] hub 6-0:1.0: USB hub found
[    9.297495] hub 6-0:1.0: 2 ports detected
[    9.351425] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.351539] Warning! ehci_hcd should always be loaded before uhci_hcd an=
d ohci_hcd, not after
[    9.352142] cfg80211: Calling CRDA to update world regulatory domain
[    9.352694] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    9.352812] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    9.352948] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    9.352951] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    9.353105] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 7
[    9.357193] ehci_hcd 0000:00:1a.7: debug port 1
[    9.357300] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    9.357318] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    9.373043] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    9.373269] usb usb7: configuration #1 chosen from 1 choice
[    9.373403] hub 7-0:1.0: USB hub found
[    9.373509] hub 7-0:1.0: 6 ports detected
[    9.374473] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    9.374591] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[    9.374723] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    9.374726] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    9.374855] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 8
[    9.378916] ehci_hcd 0000:00:1d.7: debug port 1
[    9.379025] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    9.379042] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    9.396040] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    9.396275] usb usb8: configuration #1 chosen from 1 choice
[    9.396404] hub 8-0:1.0: USB hub found
[    9.396509] hub 8-0:1.0: 6 ports detected
[    9.456218] rtc_cmos 00:07: RTC can wake from S4
[    9.456440] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    9.456586] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    9.552956] acpi device:03: registered as cooling_device2
[    9.553333] input: Video Bus as /class/input/input6
[    9.588148] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    9.618868] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[    9.701509] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[    9.701692] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    9.701896] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[    9.702033] iwlagn 0000:03:00.0: setting latency timer to 64
[    9.702092] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=3D0x24
[    9.724232] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[    9.727670] iwlagn 0000:03:00.0: PCI INT A disabled
[    9.731973] wmaster0 (iwlagn): not using net_device_ops yet
[    9.732297] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    9.833079] usb 7-5: new high speed USB device using ehci_hcd and addres=
s 3
[    9.836755] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[    9.836966] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.868488] wlan0 (iwlagn): not using net_device_ops yet
[    9.968734] usb 7-5: configuration #1 chosen from 1 choice
[    9.969575] hub 7-5:1.0: USB hub found
[    9.970043] hub 7-5:1.0: 4 ports detected
[   10.084061] usb 7-6: new high speed USB device using ehci_hcd and addres=
s 4
[   10.109914] input: HDA Intel at 0xf2620000 irq 17 Mic as /class/input/in=
put7
[   10.129175] input: HDA Intel at 0xf2620000 irq 17 Mic as /class/input/in=
put8
[   10.145139] input: HDA Intel at 0xf2620000 irq 17 Headphone as /class/in=
put/input9
[   10.221945] usb 7-6: configuration #1 chosen from 1 choice
[   10.333040] usb 8-6: new high speed USB device using ehci_hcd and addres=
s 2
[   10.479345] usb 8-6: configuration #1 chosen from 1 choice
[   10.585976] usbcore: registered new interface driver libusual
[   10.711478] Initializing USB Mass Storage driver...
[   10.711834] scsi4 : SCSI emulation for USB Mass Storage devices
[   10.714639] usb-storage: device found at 2
[   10.714645] usb-storage: waiting for device to settle before scanning
[   10.714665] usbcore: registered new interface driver usb-storage
[   10.714816] USB Mass Storage support registered.
[   10.717097] usb 2-1: new full speed USB device using uhci_hcd and addres=
s 2
[   10.897203] usb 2-1: configuration #1 chosen from 1 choice
[   10.972145] usb 7-5.4: new full speed USB device using ehci_hcd and addr=
ess 5
[   11.067577] usb 7-5.4: configuration #1 chosen from 1 choice
[   11.239588] usblp0: USB Bidirectional printer dev 5 if 0 alt 1 proto 2 v=
id 0x03F0 pid 0x0B17
[   11.239851] usbcore: registered new interface driver usblp
[   13.733378] loop: module loaded
[   14.364027] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   15.712414] isa bounce pool size: 16 pages
[   15.713198] scsi 4:0:0:0: Direct-Access     RICOH    R5U880FlashMedia 00=
00 PQ: 0 ANSI: 2
[   15.904014] sd 4:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[   15.904623] sd 4:0:0:0: [sdb] Write Protect is off
[   15.904625] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   15.904627] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   15.906121] sd 4:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[   15.906765] sd 4:0:0:0: [sdb] Write Protect is off
[   15.906767] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   15.906770] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   15.906773]  sdb: sdb1
[   15.908777] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[   15.908871] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   15.909046] usb-storage: device scan complete
[   44.966010] fuse init (API version 7.11)
[   47.660428] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   47.716162] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   50.672874] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: RX/TX
[   57.485346] NET: Registered protocol family 10
[   57.486573] lo: Disabled Privacy Extensions
[   68.093071] eth0: no IPv6 routers present
[   69.507584] Loading iSCSI transport class v2.0-870.
[   69.559800] iscsi: registered transport (tcp)
[   69.709542] iscsi: registered transport (iser)
[   76.746605] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is like=
ly not the best way to go about it
[   76.746832] thinkpad_acpi: please consider using the driver defaults, an=
d refer to up-to-date thinkpad-acpi documentation
[   76.819527] input: /usr/sbin/thinkpad-keys as /class/input/input10
[   85.779773] Bluetooth: Core ver 2.14
[   85.793101] NET: Registered protocol family 31
[   85.793234] Bluetooth: HCI device and connection manager initialized
[   85.793369] Bluetooth: HCI socket layer initialized
[   85.839109] Bluetooth: L2CAP ver 2.11
[   85.839255] Bluetooth: L2CAP socket layer initialized
[   85.848914] Bluetooth: RFCOMM socket layer initialized
[   85.849234] Bluetooth: RFCOMM TTY layer initialized
[   85.849381] Bluetooth: RFCOMM ver 1.10
[   86.241849] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[   86.242151] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (w=
as 0x100102, writing 0x100106)
[   86.242264] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[   86.242349] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[   86.418905] iwlagn loaded firmware version 5.4.1.16
[   86.584191] Registered led device: iwl-phy0:radio
[   86.584389] Registered led device: iwl-phy0:assoc
[   86.584587] Registered led device: iwl-phy0:RX
[   86.584777] Registered led device: iwl-phy0:TX
[   86.620316] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  100.092113] eth0: no IPv6 routers present
[  119.520290] [drm] Initialized drm 1.1.0 20060810
[  119.563593] pci 0000:00:02.0: power state changed by ACPI to D0
[  119.563611] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  119.563620] pci 0000:00:02.0: setting latency timer to 64
[  119.620687] pci 0000:00:02.0: irq 30 for MSI/MSI-X
[  119.620727] [drm] Initialized i915 1.6.0 20080730 on minor 0
[  120.404830] set status page addr 0x08da0000
[  120.404876] [drm:i915_set_status_page] *ERROR* can not ioremap virtual a=
ddress for G33 hw status page


--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmZZo8ACgkQuL75KpiFGIyLAgCgwS1oHg8Bv/Telo50vBnX37XU
P8cAoJxLiu86aVDq4cKIM3UaWwYQgJie
=TFpK
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
