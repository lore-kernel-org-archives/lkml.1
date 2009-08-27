Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZH0WLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZH0WLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 18:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZH0WK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 18:10:57 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:44027 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZH0WK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 18:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=lIRIunLlEVgLs8yGCLxdn6e8sDvqrciuq+COi5AHMrpfn8u6WVZBHv7wJx1Tgo76Qd
         ULL6FlEE5mxXkGWrIWemqWV4pOlO2vxsIAjw64H6b29yO5dmxkTa2i40z2z5c99cJy+g
         6vjT2+SLHohZCy94n+PzEDbgdnj6ZSrchg5p4=
Message-ID: <4A97046D.8010008@gmail.com>
Date: Thu, 27 Aug 2009 18:10:53 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE: regression in 31-rc7
References: <4A96B55C.10001@gmail.com> <20090827164007.GA30679@elte.hu> <4A96BB40.1070306@gmail.com> <alpine.DEB.2.00.0908271301200.29943@gandalf.stny.rr.com> <4A96BD50.9040204@gmail.com> <alpine.DEB.2.00.0908271334230.19345@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908271334230.19345@gandalf.stny.rr.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4F8110CC1F32B3A6B7AE21A8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4F8110CC1F32B3A6B7AE21A8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Steven Rostedt wrote:
> On Thu, 27 Aug 2009, Gregory Haskins wrote:
>=20
>> Hi Steve,
>>
>> Steven Rostedt wrote:
>> instrumented for some reason.
>>> Hmm, so you think something with the modules broke? I can test that o=
ut=20
>>> here.
>> Thats my (admittedly fairly ignorant) theory based on the limited data=

>> samples I have in front of me. :)
>>
>> If I get a chance later, I will try to do something more scientific, o=
r
>> at least a bisect.
>=20
> I just did this:

Sorry, was away from the computer for a while...

In light of these reports, I suspect this may either be some kind of
operator error, or a bad build or something.  I will retry -rc7 with a
clean build later and see if it still reproduces.  Until then, apologies
for the noise.

Kind Regards,
-Greg

>=20
>  # uname -r
> 2.6.31-rc7
>  # echo :mod:ext3 > set_ftrace_filter
>  # echo function_graph > current_tracer
>  # cat trace
> # tracer: function_graph
> #
> # CPU  DURATION                  FUNCTION CALLS
> # |     |   |                     |   |   |   |
>  1)   6.928 us    |  ext3_permission();
>  1)   1.234 us    |  ext3_permission();
>  ------------------------------------------
>  1)  gdm-bin-3477  =3D>   pcscd-2951 =20
>  ------------------------------------------
>=20
>  1)   1.306 us    |  ext3_permission();
>  1)   1.314 us    |  ext3_permission();
>  1)   1.244 us    |  ext3_permission();
>  1)   1.364 us    |  ext3_permission();
>  1)   1.251 us    |  ext3_permission();
>  1)   1.473 us    |  ext3_permission();
>  1)   1.306 us    |  ext3_permission();
>  1)   1.401 us    |  ext3_permission();
>  1)   1.243 us    |  ext3_permission();
>  1)   1.301 us    |  ext3_permission();
>  1)   1.439 us    |  ext3_permission();
>  1)   1.239 us    |  ext3_permission();
>  1)   1.331 us    |  ext3_permission();
>  1)   1.423 us    |  ext3_permission();
>  1)   1.243 us    |  ext3_permission();
>  1)   1.321 us    |  ext3_permission();
>  ------------------------------------------
>  1)   pcscd-2951   =3D>  gdm-bin-3477=20
>  ------------------------------------------
>=20
>  1)   2.567 us    |  ext3_permission();
>  1)   1.139 us    |  ext3_permission();
>  1)   2.329 us    |  ext3_permission();
>  1)   1.246 us    |  ext3_permission();
>  1)   1.321 us    |  ext3_permission();
>  1)   0.989 us    |  ext3_permission();
>  1)   1.261 us    |  ext3_permission();
>  1)   1.209 us    |  ext3_permission();
>  1)   1.221 us    |  ext3_permission();
>  1)   0.968 us    |  ext3_permission();
>  1)   2.319 us    |  ext3_permission();
>  1)   1.221 us    |  ext3_permission();
>  1)   2.199 us    |  ext3_permission();
>  1)   1.269 us    |  ext3_permission();
>  ------------------------------------------
>  1)  gdm-bin-3477  =3D>   bash-3198  =20
>  ------------------------------------------
>=20
>  1)   2.852 us    |  ext3_permission();
>  1)               |  ext3_readdir() {
>  1)   1.249 us    |    free_rb_tree_fname();
>  1)               |    ext3_htree_fill_tree() {
>  1)               |      htree_dirblock_to_tree() {
>  1)               |        ext3_bread() {
>  1)               |          ext3_getblk() {
>  1)               |            ext3_get_blocks_handle() {
>  1)   1.046 us    |              ext3_block_to_path();
>=20
>=20
> This is with the latest Linus git:
>=20
> commit 1e23502cc57cef33455ac7cb9111e3c6d991a894
> Merge: e99b1f2... 3161e45...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Aug 26 20:54:48 2009 -0700
>=20
> -- Steve
>=20



--------------enig4F8110CC1F32B3A6B7AE21A8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqXBG4ACgkQP5K2CMvXmqHz0ACfXVrX/BXCJcUNBGxGtPVx7sFk
qJ8AnAwfBKA3Fkjys93c8spBvY+XY8GY
=WqeD
-----END PGP SIGNATURE-----

--------------enig4F8110CC1F32B3A6B7AE21A8--
