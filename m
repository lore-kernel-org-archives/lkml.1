Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYEWRM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYEWRM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYEWRMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:12:51 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:34080 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYEWRMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:12:50 -0400
Message-ID: <4836FB0B.9020906@web.de>
Date: Fri, 23 May 2008 19:12:43 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: SMP support
References: <20080523141759.GA1833@damson.getinternet.no>	 <4836E55C.5000304@goop.org> <19f34abd0805230851w59a5972dk593900cf3ea8c14a@mail.gmail.com>
In-Reply-To: <19f34abd0805230851w59a5972dk593900cf3ea8c14a@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig16550CE1C417E028B9A2A8FA"
X-Provags-ID: V01U2FsdGVkX1/ukgbA7ElR43h6/LHDcE0OwjeeyUCnOnzvjcxG
	8Hx2loeUcArj7OtIecvtYTh+qANbiTVZa9XREp4hmdexlmykJN
	8UV727BvQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig16550CE1C417E028B9A2A8FA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Vegard Nossum wrote:
> On Fri, May 23, 2008 at 5:40 PM, Jeremy Fitzhardinge <jeremy@goop.org> =
wrote:
>> Vegard Nossum wrote:
>>> This works on real hw, but not on qemu. It seems to get stuck waiting=
 for
>>> one
>>> of the atomic values to change. Don't know why yet, it might just be =
yet
>>> another bug in qemu... (we've hit at least two of them so far. And th=
ey
>>> were
>>> real bugs too.)
>>>
>> I've noticed that qemu mis-reports the eip of cmpxchg if it faults (it=

>> reports the eip of the start of the basic block, I think).  Does that =
match
>> what you're seeing?
>=20
> You mean the EIP that gets pushed on the stack for the page fault?
> (That would be bad news for kmemcheck. I suppose the rest of the
> kernel never page faults on cmpxchg addresses?)
>=20
> Or do you mean the EIP that shows up in gdb?
>=20
> But no, it seems to be unrelated. What I hit so far were (in 0.9.0):
>=20
> 1. qemu doesn't set the single-stepping flag of DR6 on single-step
> debug exceptions.
> 2. qemu triggers int 0 (divide error) instead of int 2 on NMI IPIs.
>=20
> But both of these were fixed in the latest 0.9.1.

I guess you mean trunk - NMI IPIs didn't came with "old" 0.9.1.

>=20
> I don't yet know if what I'm hitting now is really an error with qemu.
> But I usually trust the real hardware more :-)

Try KVM as well. It is, of course, must faster than QEMU, and it comes
with true SMP (given you have a SMP host). With in-kernel irqchip
(that's default), KVM now also supports NMI IPIs. And debug registers
should be fine with my latest patch.

I'm currently trying to get debug support straight for upstream KVM and,
where also required, QEMU. SMP debugging is a common issue, but already
usable with KVM. So testers are welcome, an overview on required patches
can be provided.

Jan

PS: Some cmpxchg changes where committed to qemu-trunk recently, maybe
only related to the restructuring of the code generator, but maybe also
fixing an older bug.


--------------enig16550CE1C417E028B9A2A8FA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFINvsPniDOoMHTA+kRAhVZAJ9XdIsdtcGvfeUNOoIwd+3vYS9UYQCfdaNu
i/F3QY//m7ID9fk6oSSE/W4=
=W9Tf
-----END PGP SIGNATURE-----

--------------enig16550CE1C417E028B9A2A8FA--
