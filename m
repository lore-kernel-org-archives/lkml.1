Return-Path: <linux-kernel-owner+w=401wt.eu-S970233AbXFHVNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970233AbXFHVNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 17:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964832AbXFHVNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 17:13:40 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:58399 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbXFHVNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 17:13:39 -0400
Date: Fri, 8 Jun 2007 23:13:31 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andi Kleen <andi@firstfloor.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH 0/2] i386: Fix two more NMI watchdog bugs
Message-ID: <20070608231331.6d650daf@laptop.hypervisor.org>
In-Reply-To: <20070608135727.d956166d.akpm@linux-foundation.org>
References: <465C2225.2000100@googlemail.com>
	<20070603150246.5151dda6@laptop.hypervisor.org>
	<20070608060244.GA2369@atjola.homenet>
	<20070607234153.09c32b49.akpm@linux-foundation.org>
	<20070608105808.GA10190@elte.hu>
	<20070608184422.GA2204@atjola.homenet>
	<20070608204324.GA25392@elte.hu>
	<20070608224911.3ff6bd18@laptop.hypervisor.org>
	<20070608135727.d956166d.akpm@linux-foundation.org>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_p5R6vRfu.SWBYQIx4HuvP34;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_p5R6vRfu.SWBYQIx4HuvP34
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Jun 2007 13:57:27 -0700 Andrew Morton (AM) wrote:

AM> On Fri, 8 Jun 2007 22:49:11 +0200
AM> "Udo A. Steinberg" <us15@os.inf.tu-dresden.de> wrote:
AM>=20
AM> > On Fri, 8 Jun 2007 22:43:25 +0200 Ingo Molnar (IM) wrote:
AM> >=20
AM> > IM>=20
AM> > IM> * Bj?rn Steinbrink <B.Steinbrink@gmx.de> wrote:
AM> > IM>=20
AM> > IM> > Anyway, both are bugs and should be fixed. Maybe we're even luc=
ky
AM> > IM> > and it fixes your hang. *fingers crossed*
AM> > IM>=20
AM> > IM> just to make it clear: the NMI watchdog was working perfectly fin=
e on=20
AM> > IM> that box (in v2.6.21 and in dozens of kernel releases before that,
AM> > IM> for multiple years) before Andi's cleanup patch. So lets find that
AM> > IM> bug first or revert the cleanups.
AM> > IM>=20
AM> > IM> 	Ingo
AM> >=20
AM> > None of the patches posted by Bj__rn fix the kernel BUG at
AM> > arch/i386/kernel/cpu/perfctr-watchdog.c:126! that occurs when doing
AM> > echo 0 > /proc/sys/kernel/nmi_watchdog
AM> >=20
AM> > Call Trace:
AM> >  [<c010c429>] single_msr_unreserve+0xd/0x1a
AM> >  [<c010c668>] disable_lapic_nmi_watchdog+0x27/0x35
AM> >  [<c0110ac6>] proc_nmi_enabled+0xa0/0xbd
AM> >  [<c018550c>] proc_sys_write+0x6f/0x8c
AM> >  [<c018549d>] proc_sys_write+0x0/0x8c
AM> >  [<c0156e5b>] vfs_write+0x8a/0x10c
AM> >  [<c0157317>] sys_write+0x41/0x67
AM> >  [<c0103c30>] syscall_call+0x7/0xb
AM> >=20
AM> > Andi, did you have a patch for that?
AM> >=20
AM>=20
AM> This?
AM>=20
AM>=20
AM> From: Bjorn Steinbrink <B.Steinbrink@gmx.de>
AM>=20
AM> Fix oops triggered during: echo 0 > /proc/sys/kernel/nmi_watchdog
AM>=20
AM> The culprit seems to be 09198e68501a7e34737cd9264d266f42429abcdc:

This alone does not help, but in combination with the other two patches=20
the problem no longer occurs.=20

Thanks,

	- Udo

--Sig_p5R6vRfu.SWBYQIx4HuvP34
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGacZ7nhRzXSM7nSkRAiIsAJ4va4OIBnL9ZDFO1242UuUF1EzQqgCdHpPp
f+pZJmTVMvjgOQjMssAXe4k=
=sHcr
-----END PGP SIGNATURE-----

--Sig_p5R6vRfu.SWBYQIx4HuvP34--
