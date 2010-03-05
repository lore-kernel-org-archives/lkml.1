Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab0CEM5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:57:01 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:59425 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0CEM5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:57:00 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ben Skeggs <skeggsb@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sf.net
Subject: Re: Making Xorg easier to test (was Re: [git pull] drm request 3)
In-Reply-To: Your message of "Fri, 05 Mar 2010 11:00:30 +0100."
             <20100305100030.GA4970@Pilar.aei.mpg.de>
From: Valdis.Kletnieks@vt.edu
References: <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com> <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu> <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com> <20100305074407.GC19703@elte.hu>
            <20100305100030.GA4970@Pilar.aei.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1267793695_4085P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Mar 2010 07:54:55 -0500
Message-ID: <8733.1267793695@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4B90FF20.01D8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1267793695_4085P
Content-Type: text/plain; charset=us-ascii

On Fri, 05 Mar 2010 11:00:30 +0100, "Carlos R. Mafra" said:

> Why can't there be a 'Linus Torvalds' for Xorg accepting patches from various
> maintainers and keeping the whole thing tied up? Why can't it mimic the
> 'make menuconfig' way of selecting what to compile to have the guarantee that
> the whole thing will simply work nicely together?

Feel free to do so.  Note that you'll hit 2 problems:

1) In the kernel, the sysadmin can almost always get away with saying
"I have no XYZ devices" or "I only have ext4 filesystems" or similar choices,
and have the resulting kernel still support basically all the syscalls
(unless you start going into CONFIG_EMBEDDED and doing some *major* surgury).
Over on the X side of the fence, there aren't as many options that don't
involve dropping major chunks of the functionality.  You *sure* that nothing
on your system depends on the XRandR extension? ;)

2) Lately, the X server is *already* highly modular and different components
built from different source trees.  Note that the base X server is only about
half the size of the kernel RPM - there really isn't much left to trim out of
the base server anymore.

ncftp ...velopment/source/SRPMS > dir kern* xorg*
-rw-r--r--    1 263      263     66965350   Feb 26 18:03   kernel-2.6.34-0.4.rc0.git2.fc14.src.rpm
-rw-r--r--    1 263      263        44300   Feb 27 01:39   xorg-sgml-doctools-1.1.1-4.fc12.src.rpm
-rw-r--r--    2 263      263      2229508   Feb 11 02:23   xorg-x11-apps-7.4-10.fc13.src.rpm
-rw-r--r--    1 263      263      8250097   Feb 27 00:06   xorg-x11-docs-1.3-6.fc12.src.rpm
-rw-r--r--    1 263      263         9718   Feb 27 03:27   xorg-x11-drivers-7.3-13.fc12.src.rpm
-rw-r--r--    2 263      263       263291   Feb  5 21:40   xorg-x11-drv-acecad-1.4.0-3.fc13.src.rpm
-rw-r--r--    2 263      263       271426   Feb  5 23:03   xorg-x11-drv-aiptek-1.3.0-3.fc13.src.rpm
-rw-r--r--    1 263      263       293991   Feb 27 01:02   xorg-x11-drv-apm-1.2.2-1.fc12.src.rpm
-rw-r--r--    2 263      263       247603   Feb  5 19:49   xorg-x11-drv-ark-0.7.2-2.fc13.src.rpm
-rw-r--r--    1 263      263       273849   Feb 26 20:22   xorg-x11-drv-ast-0.89.9-1.fc12.src.rpm
-rw-r--r--    1 263      263       475771   Feb 19 00:50   xorg-x11-drv-ati-6.13.0-0.23.20100219gite68d3a389.fc14.src.rpm
-rw-r--r--    1 263      263       354400   Feb 27 01:17   xorg-x11-drv-chips-1.2.2-1.fc12.src.rpm
-rw-r--r--    2 263      263       296790   Feb  5 16:10   xorg-x11-drv-cirrus-1.3.2-2.fc13.src.rpm
-rw-r--r--    2 263      263       257700   Feb  5 19:48   xorg-x11-drv-dummy-0.3.3-2.fc13.src.rpm
-rw-r--r--    2 263      263       260227   Feb  5 16:26   xorg-x11-drv-elographics-1.2.3-6.fc13.src.rpm
-rw-r--r--    2 263      263       537577   Feb  5 21:59   xorg-x11-drv-evdev-2.3.99-2.20100108.fc13.src.rpm
-rw-r--r--    2 263      263       254313   Feb  9 13:19   xorg-x11-drv-fbdev-0.4.1-3.fc13.src.rpm
-rw-r--r--    1 263      263       252387   Feb 17 05:13   xorg-x11-drv-fpit-1.3.0-8.fc14.src.rpm
-rw-r--r--    2 263      263       608480   Feb  5 23:07   xorg-x11-drv-geode-2.11.4.1-2.fc13.src.rpm
-rw-r--r--    2 263      263       361698   Feb  5 21:40   xorg-x11-drv-glint-1.2.4-2.fc13.src.rpm
-rw-r--r--    2 263      263       244962   Feb  9 13:48   xorg-x11-drv-hyperpen-1.3.0-4.fc13.src.rpm
-rw-r--r--    2 263      263       289677   Feb  5 22:38   xorg-x11-drv-i128-1.3.3-2.fc13.src.rpm
-rw-r--r--    2 263      263       281904   Feb  5 20:33   xorg-x11-drv-i740-1.3.2-2.fc13.src.rpm
-rw-r--r--    1 263      263       978993   Feb 12 07:15   xorg-x11-drv-intel-2.10.0-4.fc13.src.rpm
-rw-r--r--    2 263      263       305926   Feb  5 19:26   xorg-x11-drv-ivtv-1.1.1-1.fc13.src.rpm
-rw-r--r--    2 263      263       296974   Feb  5 19:22   xorg-x11-drv-keyboard-1.4.0-4.fc13.src.rpm
-rw-r--r--    2 263      263       492204   Feb  5 20:02   xorg-x11-drv-mach64-6.8.2-2.fc13.src.rpm
-rw-r--r--    2 263      263       427579   Feb  5 20:39   xorg-x11-drv-mga-1.4.11-2.fc13.src.rpm
-rw-r--r--    2 263      263       318263   Feb  9 13:52   xorg-x11-drv-mouse-1.5.0-4.fc13.src.rpm
-rw-r--r--    2 263      263       254590   Feb  5 20:17   xorg-x11-drv-mutouch-1.2.1-6.fc13.src.rpm
-rw-r--r--    2 263      263       290495   Feb  5 22:02   xorg-x11-drv-neomagic-1.2.4-3.fc13.src.rpm
-rw-r--r--    2 263      263        91334   Feb 18 16:59   xorg-x11-drv-nouveau-0.0.16-2.20100218git2964702.fc13.src.rpm
-rw-r--r--    2 263      263       449803   Feb  9 12:19   xorg-x11-drv-nv-2.1.15-5.fc13.src.rpm
-rw-r--r--    2 263      263       475028   Feb  9 12:26   xorg-x11-drv-openchrome-0.2.904-2.fc13.src.rpm
-rw-r--r--    2 263      263       248668   Feb  9 12:27   xorg-x11-drv-penmount-1.4.0-6.fc13.src.rpm
-rw-r--r--    2 263      263       280184   Feb  5 22:08   xorg-x11-drv-qxl-0.0.9-0.1.fc13.src.rpm
-rw-r--r--    2 263      263       424771   Feb  5 19:36   xorg-x11-drv-r128-6.8.1-3.fc13.src.rpm
-rw-r--r--    2 263      263       746854   Feb 11 02:43   xorg-x11-drv-radeonhd-1.3.0-5.4.20100210git.fc13.src.rpm
-rw-r--r--    2 263      263       323181   Feb  5 20:32   xorg-x11-drv-rendition-4.2.2-5.fc13.src.rpm
-rw-r--r--    2 263      263       285445   Feb  5 20:21   xorg-x11-drv-s3-0.6.3-2.fc13.src.rpm
-rw-r--r--    2 263      263       308304   Feb  9 12:44   xorg-x11-drv-s3virge-1.10.4-2.fc13.src.rpm
-rw-r--r--    2 263      263       336582   Feb  5 18:39   xorg-x11-drv-savage-2.3.1-2.fc13.src.rpm
-rw-r--r--    2 263      263       587339   Feb  5 20:09   xorg-x11-drv-siliconmotion-1.7.3-3.20100122.fc13.src.rpm
-rw-r--r--    2 263      263       651516   Feb  5 16:33   xorg-x11-drv-sis-0.10.2-2.fc13.src.rpm
-rw-r--r--    2 263      263       329764   Feb  5 19:46   xorg-x11-drv-sisusb-0.9.3-2.fc13.src.rpm
-rw-r--r--    1 263      263       316085   Feb 18 23:34   xorg-x11-drv-synaptics-1.2.1-4.fc14.src.rpm
-rw-r--r--    2 263      263       298619   Feb  5 20:35   xorg-x11-drv-tdfx-1.4.3-2.fc13.src.rpm
-rw-r--r--    2 263      263       305737   Feb  5 19:56   xorg-x11-drv-trident-1.3.3-2.fc13.src.rpm
-rw-r--r--    2 263      263       292468   Feb  5 22:28   xorg-x11-drv-tseng-1.2.3-2.fc13.src.rpm
-rw-r--r--    2 263      263       250893   Feb  5 21:17   xorg-x11-drv-v4l-0.2.0-4.fc13.1.src.rpm
-rw-r--r--    2 263      263       259661   Feb  5 16:27   xorg-x11-drv-vesa-2.2.1-2.fc13.src.rpm
-rw-r--r--    1 263      263       281386   Feb 12 06:37   xorg-x11-drv-vmmouse-12.6.6-1.fc13.src.rpm
-rw-r--r--    2 263      263       288560   Feb  9 13:16   xorg-x11-drv-vmware-10.16.7-3.fc13.src.rpm
-rw-r--r--    2 263      263       255811   Feb  5 22:30   xorg-x11-drv-void-1.3.0-5.fc13.src.rpm
-rw-r--r--    2 263      263       268147   Feb  5 21:35   xorg-x11-drv-voodoo-1.2.3-2.fc13.src.rpm
-rw-r--r--    1 263      263      2356579   Mar  4 00:05   xorg-x11-drv-wacom-0.10.4-5.20100219.fc14.src.rpm
-rw-r--r--    2 263      263       521166   Feb  5 22:42   xorg-x11-font-utils-7.2-11.fc13.src.rpm
-rw-r--r--    1 263      263     10315388   Feb 27 00:41   xorg-x11-fonts-7.2-9.fc12.src.rpm
-rw-r--r--    2 263      263      2165779   Feb 25 21:56   xorg-x11-proto-devel-7.4-36.fc13.src.rpm
-rw-r--r--    1 263      263       371754   Feb 26 20:39   xorg-x11-resutils-7.1-9.fc12.src.rpm
-rw-r--r--    1 263      263     35493506   Mar  4 05:51   xorg-x11-server-1.7.99.901-10.20100304.fc14.src.rpm
-rw-r--r--    2 263      263      1418431   Feb  5 16:50   xorg-x11-server-utils-7.4-15.fc13.src.rpm
-rw-r--r--    2 263      263       247211   Feb 12 05:41   xorg-x11-twm-1.0.3-6.fc13.src.rpm
-rw-r--r--    2 263      263        66840   Feb  9 12:03   xorg-x11-util-macros-1.5.0-1.fc13.src.rpm
-rw-r--r--    2 263      263       900166   Feb  9 11:40   xorg-x11-utils-7.4-9.fc13.src.rpm
-rw-r--r--    1 263      263       123367   Feb 27 03:05   xorg-x11-xauth-1.0.2-7.fc12.src.rpm
-rw-r--r--    2 263      263       108420   Feb  5 20:51   xorg-x11-xbitmaps-1.1.0-1.fc13.src.rpm
-rw-r--r--    1 263      263       415159   Feb 20 21:12   xorg-x11-xdm-1.1.6-16.fc13.src.rpm
-rw-r--r--    1 263      263       481668   Feb 27 02:56   xorg-x11-xfs-1.0.5-6.fc12.src.rpm
-rw-r--r--    1 263      263       282714   Feb 26 22:00   xorg-x11-xfwp-1.0.1-10.fc12.src.rpm
-rw-r--r--    1 263      263       153187   Feb 27 10:54   xorg-x11-xinit-1.0.9-15.fc14.src.rpm
-rw-r--r--    2 263      263       681572   Feb  5 16:57   xorg-x11-xkb-utils-7.4-7.fc13.src.rpm
-rw-r--r--    2 263      263       308671   Feb 11 02:35   xorg-x11-xsm-1.0.2-13.fc13.src.rpm
-rw-r--r--    1 263      263       110396   Feb 27 01:45   xorg-x11-xtrans-devel-1.2.2-4.fc12.src.rpm


--==_Exmh_1267793695_4085P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLkP8fcC3lWbTT17ARAoNyAJ92g6vtmQiMxArs5oo4HIiDKPdQvACfQXC6
vG4ckeHGv0CYla6AGVwSdm4=
=hu09
-----END PGP SIGNATURE-----

--==_Exmh_1267793695_4085P--

