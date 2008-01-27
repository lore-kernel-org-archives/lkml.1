Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbYA0WIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbYA0WIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYA0WIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:08:24 -0500
Received: from jilau1.colorado.edu ([128.138.140.5]:53348 "EHLO
	jilau1.Colorado.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYA0WIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:08:23 -0500
X-Greylist: delayed 1429 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 17:08:23 EST
Date: Sun, 27 Jan 2008 14:44:00 -0700
From: "Benjamin K. Stuhl" <benjamin.stuhl@colorado.edu>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Linux-Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: "sched: add vslice" causes horrible interactivity under load
Message-ID: <20080127144400.78e0aec5@colorado.edu>
Organization: JILA / University of Colorado at Boulder Department of Physics
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FPYEhchw9LhN7b1K8dxD9Mg";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FPYEhchw9LhN7b1K8dxD9Mg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,
  I recently upgraded from 2.6.23.x to 2.6.24 and found that whereas
with 2.6.23.x I could have multiple "make -j3" compilation runs going
in the background with no real problems (on a dual-core Core 2), with
2.6.24 I get multiple-second lags when trying to switch tasks in KDE.=20
I did a git bisect starting from 9b73e76f3cf63379dcf45fcd4f112f5812418d0a
in Linus's 2.6.25 tree in the hope that the recent scheduler merge might=20
have fixed the problem, but no such luck. Instead, git bisect points its
all-knowing finger at=20

commit 67e9fb2a39a1d454218d50383094940982be138f
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Oct 15 17:00:10 2007 +0200

    sched: add vslice

    add vslice: the load-dependent "virtual slice" a task should
    run ideally, so that the observed latency stays within the
    sched_latency window.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

A straight-forward git revert crashes at boot, so I don't have a patch to o=
ffer. :-/
(Please keep me CC'ed, since I'm not subscribed to LKML.)

Thanks for your help,
-- BKS

--Sig_/FPYEhchw9LhN7b1K8dxD9Mg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHnPssFpoVNd4CUAIRAh+FAJsHg6hguOJHAyin3GNhpkRZf+37TQCgkyPF
yajE+6p7VdtH7IR5s2xbWUI=
=T1/U
-----END PGP SIGNATURE-----

--Sig_/FPYEhchw9LhN7b1K8dxD9Mg--
