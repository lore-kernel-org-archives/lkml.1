Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZK2LhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZK2LhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 06:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZK2LhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 06:37:16 -0500
Received: from mail.klingt.org ([86.59.21.178]:43216 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZK2LhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 06:37:14 -0500
Message-ID: <4B125CC2.7000202@klingt.org>
Date: Sun, 29 Nov 2009 12:36:34 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091127 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 3/5] slab.c: remove branch hint
References: <cover.1259059549.git.tim@klingt.org> <4B0BBBA8.2090604@klingt.org>	 <20091124112058.GA23765@elte.hu> <84144f020911240328l3d36d347o6c91b2b1a0f50f2a@mail.gmail.com>
In-Reply-To: <84144f020911240328l3d36d347o6c91b2b1a0f50f2a@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB5AFFFD16A6BA469323A9394"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Sun, 29 Nov 2009 12:36:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB5AFFFD16A6BA469323A9394
Content-Type: multipart/mixed;
 boundary="------------010408010908040909050604"

This is a multi-part message in MIME format.
--------------010408010908040909050604
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/24/2009 12:28 PM, Pekka Enberg wrote:
> On Tue, Nov 24, 2009 at 1:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> (Pekka Cc:-ed)
>>
>> * Tim Blechmann <tim@klingt.org> wrote:
>>
>>> branch profiling on my nehalem machine showed 99% incorrect branch hi=
nts:
>>>
>>>    28459  7678524  99 __cache_alloc_node             slab.c
>>>   3551
>>>
>>> Signed-off-by: Tim Blechmann <tim@klingt.org>
>>> ---
>>>  mm/slab.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/mm/slab.c b/mm/slab.c
>>> index f70b326..4125fcd 100644
>>> --- a/mm/slab.c
>>> +++ b/mm/slab.c
>>> @@ -3548,7 +3548,7 @@ __cache_alloc_node(struct kmem_cache *cachep,
>>> gfp_t flags, int nodeid,
>>>       slab_irq_save(save_flags, this_cpu);
>>>       this_node =3D cpu_to_node(this_cpu);
>>> -     if (unlikely(nodeid =3D=3D -1))
>>> +     if (nodeid =3D=3D -1)
>>>               nodeid =3D this_node;
>>>       if (unlikely(!cachep->nodelists[nodeid])) {
>=20
> That sounds odd to me. Can you see where the incorrectly predicted
> calls are coming from? Calling kmem_cache_alloc_node() with node set
> to -1 most of the time could be a real bug somewhere.

when dumping the stack for the incorrectly hinted branches, i get the
attached stack traces...

hth, tim

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3548,8 +3548,10 @@ __cache_alloc_node(struct kmem_cache *cachep,
gfp_t flags, int nodeid,
        slab_irq_save(save_flags, this_cpu);

        this_node =3D cpu_to_node(this_cpu);
-       if (nodeid =3D=3D -1)
+       if (nodeid =3D=3D -1) {
+               dump_stack();
                nodeid =3D this_node;
+       }

        if (unlikely(!cachep->nodelists[nodeid])) {
                /* Node not bootstrapped yet */



--=20
tim@klingt.org
http://tim.klingt.org

It is better to make a piece of music than to perform one, better to
perform one than to listen to one, better to listen to one than to
misuse it as a means of distraction, entertainment, or acquisition of
'culture'.
  John Cage

--------------010408010908040909050604
Content-Type: application/x-bzip;
 name="traces.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="traces.bz2"

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
--------------010408010908040909050604--

--------------enigB5AFFFD16A6BA469323A9394
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksSXMUACgkQdL+4qsZfVsth9gCeL1X4zaXU0bkiGyqc4i2T3xdR
vEUAnAxH0B7YSFfjnHdaMa1MN5B/ix+I
=Bcyf
-----END PGP SIGNATURE-----

--------------enigB5AFFFD16A6BA469323A9394--
