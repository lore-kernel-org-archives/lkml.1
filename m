Return-Path: <linux-kernel-owner+w=401wt.eu-S970954AbXFHUtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970954AbXFHUtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030586AbXFHUtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:49:25 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:48728 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030788AbXFHUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:49:24 -0400
Date: Fri, 8 Jun 2007 22:49:11 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH 0/2] i386: Fix two more NMI watchdog bugs
Message-ID: <20070608224911.3ff6bd18@laptop.hypervisor.org>
In-Reply-To: <20070608204324.GA25392@elte.hu>
References: <465C2225.2000100@googlemail.com>
	<20070603150246.5151dda6@laptop.hypervisor.org>
	<20070608060244.GA2369@atjola.homenet>
	<20070607234153.09c32b49.akpm@linux-foundation.org>
	<20070608105808.GA10190@elte.hu>
	<20070608184422.GA2204@atjola.homenet>
	<20070608204324.GA25392@elte.hu>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_K6AXE6qT0I4zeHu2aqDpQ12;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_K6AXE6qT0I4zeHu2aqDpQ12
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Jun 2007 22:43:25 +0200 Ingo Molnar (IM) wrote:

IM>=20
IM> * Bj?rn Steinbrink <B.Steinbrink@gmx.de> wrote:
IM>=20
IM> > Anyway, both are bugs and should be fixed. Maybe we're even lucky and=
=20
IM> > it fixes your hang. *fingers crossed*
IM>=20
IM> just to make it clear: the NMI watchdog was working perfectly fine on=20
IM> that box (in v2.6.21 and in dozens of kernel releases before that, for=
=20
IM> multiple years) before Andi's cleanup patch. So lets find that bug firs=
t=20
IM> or revert the cleanups.
IM>=20
IM> 	Ingo

None of the patches posted by Bj=F6rn fix the kernel BUG at
arch/i386/kernel/cpu/perfctr-watchdog.c:126! that occurs when doing
echo 0 > /proc/sys/kernel/nmi_watchdog

Call Trace:
 [<c010c429>] single_msr_unreserve+0xd/0x1a
 [<c010c668>] disable_lapic_nmi_watchdog+0x27/0x35
 [<c0110ac6>] proc_nmi_enabled+0xa0/0xbd
 [<c018550c>] proc_sys_write+0x6f/0x8c
 [<c018549d>] proc_sys_write+0x0/0x8c
 [<c0156e5b>] vfs_write+0x8a/0x10c
 [<c0157317>] sys_write+0x41/0x67
 [<c0103c30>] syscall_call+0x7/0xb

Andi, did you have a patch for that?

Cheers,

	- Udo

--Sig_K6AXE6qT0I4zeHu2aqDpQ12
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGacDHnhRzXSM7nSkRAjCXAJ95ftq8ywP7BqdkUWn2xASGki8WrACbBfXR
HkbP3OBLtDDEYa6NJZoU9XM=
=nrp2
-----END PGP SIGNATURE-----

--Sig_K6AXE6qT0I4zeHu2aqDpQ12--
