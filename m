Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYGCNtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYGCNtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbYGCNtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:49:19 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50201 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758280AbYGCNtS (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:49:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Woodhouse <dwmw2@infradead.org>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Shaohua Li <shaohua.li@intel.com>,
       greg@kroah.com, Kay Sievers <kay.sievers@vrfy.org>, arjan@infradead.org
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New World Order firmware...
In-Reply-To: Your message of "Thu, 03 Jul 2008 13:21:35 BST."
             <1215087695.10393.538.camel@pmac.infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <4534.1215048758@turing-police.cc.vt.edu> <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet> <32146.1215066947@turing-police.cc.vt.edu> <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet> <1215077028.10393.497.camel@pmac.infradead.org> <65663.1215080245@turing-police.cc.vt.edu> <1215081029.10393.517.camel@pmac.infradead.org> <68763.1215084867@turing-police.cc.vt.edu>
            <1215087695.10393.538.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215092936_4193P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jul 2008 09:48:56 -0400
Message-ID: <76161.1215092936@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215092936_4193P
Content-Type: text/plain; charset=us-ascii

On Thu, 03 Jul 2008 13:21:35 BST, David Woodhouse said:
> On Thu, 2008-07-03 at 07:34 -0400, Valdis.Kletnieks@vt.edu wrote:
> > Actually, FIRMWARE_IN_KERNEL *did* make a difference - it busticated the tg
3
> > driver and while fighting with the 'firmware: requesting tigon/tg3_tso.bin'
> > errors I had just inflicted on myself, 
> 
> Just to confirm: that works either with CONFIG_FIRMWARE_IN_KERNEL=y or
> if you run 'make INSTALL_FW_PATH=/lib/firmware firmware_install', right?

The old config was FIRMWARE_IN_KERNEL=y, and that worked fine because the
microcode was compiled into tg3.o and All Was Good.

My current, *also* working config has FIRMWARE_IN_KERNEL=n, and CONFIG_TIGON3=m.
System comes up, initrd runs, the real root gets loaded, udev gets started,
and when the modprobe happens, /lib/firmware/tigon is there to handle the
request_firmware that gets launched when the module loads.

The *broken* config was FIRMWARE_IN_KERNEL=n, CONFIG_TIGON3=y.  System comes up,
the request_firmware pops *very* early (as in while we're still on the initrd),
and I couldn't figure out how to get Fedora/nash/etc to do the firmware load
from the initrd (nash seems to want it in /firmware/tigon3, but putting it
there didn't help any).  By the time udev gets launched, that request is DOA
and the interface doesn't come up.  But as I said, that *seems* to be just a
lack of clue on my part about what nash wants.

> I'm not entirely sure whether we should make 'make firmware_install'
> install to /lib/firmware by default, or to $(O)/usr/lib/firmware as it
> does at the moment.
> 
> The former is consistent with 'make modules_install', and the latter is
> consistent with 'make headers_install'. Both of which have good reasons
> for being the way they are.

Somebody else can decide that one.  Kay does make a point in another mail
that you *really* want it to end up in /lib/firmware for good reasons.

--==_Exmh_1215092936_4193P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIbNjIcC3lWbTT17ARAod/AKCso+2tQsAp0Zt6u2pC6qzrd0EBVwCgrt/y
4MBKRRhCPGtL9mt7fh+F97g=
=7V6z
-----END PGP SIGNATURE-----

--==_Exmh_1215092936_4193P--
