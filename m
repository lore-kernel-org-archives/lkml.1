Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZKJBPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZKJBPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 20:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZKJBPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 20:15:37 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55281 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbZKJBPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 20:15:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=Ren7JDxakblhv9DkxkRZbSFD2CQx007X8Mpgc2GHNrALyFCSCNeOe9usd7EXECozuq
         bRtdipAx0wz39J7B75SfY5SMhLSyJhCm1QCcswToVLtI/yCcokoHZGSgSRn84JPpYL+j
         yJhUwupAbcJDoUVK9cEuNWzqqDgHkbasEPlbk=
Message-ID: <4AF8BEB9.1070103@gmail.com>
Date: Mon, 09 Nov 2009 20:15:37 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [lucas.de.marchi@gmail.com: Bug when changing cpus_allowed of
 RT tasks?]
References: <20091108121650.GB11372@elte.hu> <4AF828C50200005A000585DB@sinclair.provo.novell.com> <193b0f820911091312y125209deufadd1040aff65cfd@mail.gmail.com>
In-Reply-To: <193b0f820911091312y125209deufadd1040aff65cfd@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAB207F9FA73AEF6801D1AA81"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAB207F9FA73AEF6801D1AA81
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Lucas De Marchi wrote:
> On Mon, Nov 9, 2009 at 17:35, Gregory Haskins <ghaskins@novell.com> wro=
te:
>=20
>>>       static int select_task_rq_rt(struct task_struct *p, int sd_flag=
, int flags)
>>>       {
>>>               [...]
>>>               if (unlikely(rt_task(rq->curr)) &&
>>>                   (p->rt.nr_cpus_allowed > 1)) {
>>>                       int cpu =3D find_lowest_rq(p);
>>>
>>>                       return (cpu =3D=3D -1) ? task_cpu(p) : cpu;
>>>               }
> 	/*
> 	 * Otherwise, just let it ride on the affined RQ and the
> 	 * post-schedule router will push the preempted task away
> 	 */
> 	return task_cpu(p);
>=20
>>>       }
> I completed the rest of function to emphasize it will return task_cpu(p=
)
> afterwards.
>=20
>> So the intent of this logic is to say "if the task is of type RT, and =
it can move, see if it can move
>> elsewhere".  Otherwise, we do not try to move it at all.
>=20
> I'd say "if _current_ is of type RT, and _p_ can move, see if _p_ can m=
ove
> elsewhere". And this check is repeated for p inside find_lowest_rq, so =
it would
> not be needed here. Just let it call find_lowest_rq and -1 will be retu=
rned.

Ah, yes, "current" is correct.  My bad.


>=20
>> Until further evidence is presented, I have to respectfully NAK the pa=
tch, as I do not think its doing the right thing
>> nor do I think the current code is actually broken.
>=20
> I see now it's not doing the right thing. IMO only the double check of
> rt.nr_cpus_allowed is superfluous, but not wrong.
>=20

Right.  I have a suspicion that the original code didn't have the
redundant check, but it was patched that way later.  I can't recall, tbh.=


>=20
> Thanks for clarifications

Np.

Kind Regards,
-Greg


--------------enigAB207F9FA73AEF6801D1AA81
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkr4vrkACgkQP5K2CMvXmqG0tgCeKyHnQ7OXCgJzzW9uiWh2OZsP
xJEAoIgOK+0CZ5rUc9KYVcbPee2DkYiB
=+Pca
-----END PGP SIGNATURE-----

--------------enigAB207F9FA73AEF6801D1AA81--
