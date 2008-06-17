Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYFQXNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYFQXNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759045AbYFQXNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:13:31 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44458 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075AbYFQXNb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:13:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/19] perfmon2 minimal v2: introduction
In-Reply-To: Your message of "Tue, 17 Jun 2008 15:02:01 PDT."
             <48583459.0917400a.2d99.ffff9b6a@mx.google.com>
From: Valdis.Kletnieks@vt.edu
References: <48583459.0917400a.2d99.ffff9b6a@mx.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1213744408_5877P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Jun 2008 19:13:28 -0400
Message-ID: <45063.1213744408@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1213744408_5877P
Content-Type: text/plain; charset=us-ascii

On Tue, 17 Jun 2008 15:02:01 PDT, eranian@googlemail.com said:
> The following patches implement a minimal perfmon2 subsystem which provides
> access to the hardware performance counters of modern processors.
> 
> This series supports ONLY per-thread counting of PMU events (no sampling) for
> AMD64 and Intel Core processors in both 32 and 64 bit modes.
> 
> This is version 2 of the series following the feedback from LKML. The series
> is against 2.6.26-rc6. Compared to previous version, this new series
> addresses the comments I received from Aran, Greg KH and others:

First, a meta-complaint - Stephane, you're not the only person who does
the following, and in fact, you're not the worst offender.  I've seen a *lot*
of even less clear patchsets on lkml - I actually only bothered to chase *this*
one down because I happened to know that a co-worker might be interested.

Would it be asking too much to have a paragraph or so on *why* we
want this patchset?  Does it add functionality, or fix a bug, or reduce
memory footprint for machines that don't need sampling, or?  Give us a few
sentences of why we should be excited this code is landing - otherwise it's
likely to be just another new option that people will hit 'N' when they come
across it in 'make oldconfig'.  Tell us why we as testers/bleeding edgers
want to hit 'Y'.

I finally grovelled around in patch 2, and found this in a comment in
perfmon_attach.c:

+ * More information about perfmon available at:
+ * 	http://www.hpl.hp.com/research/linux/perfmon

However, said page merely says "The project is now completely hosted
<here> http://perfmon2.sf.net/"

Eventually, after chasing a few links, I find myself at:

http://sourceforge.net/projects/perfmon2

"The goal of the project is to design and implement, on all major
architectures, a standard Linux kernel interface, to access the hardware
performance counters of modern processors. The project also developed a user
library,libpfm, and a tool, pfmon."

Several *more* links and I find http://perfmon2.sourceforge.net/perfmon2-20080124.pdf

which finally tells me *something* about what this does and why I would want
to be interested in it...

"Oh.  So this *could* be used to tell Professor J Random that his code runs
like a sedated sloth because things that should be cache-hot are actually
cache-cold and we're spending 75% of our time waiting for cache line loads..."

*NOW* I'm interested. :)

Second comment - I haven't done a thorough check, but the Kconfig entry shows
up near patch 7 or 8 of 19.  Traditionally, that's done in the *last* patch
so everything added is intentionally dead code, to make it easier to bisect
through.  It looks like possible trouble if bisecting between 2 other points
(say 2.6.27-rc1 and 2.6.27-rc2 or whenever this merges) happens to land near
patch 13 of 19.

--==_Exmh_1213744408_5877P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIWEUYcC3lWbTT17ARAip6AJ9PWH8L5AWO351/8gNq2Dt9F6ZU6ACffGDl
UG74AA7MOxOuJJwmxf8AVcA=
=Ujsf
-----END PGP SIGNATURE-----

--==_Exmh_1213744408_5877P--
