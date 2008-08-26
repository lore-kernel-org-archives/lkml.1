Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbYHZLj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbYHZLj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYHZLjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:39:19 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34586 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYHZLjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:39:18 -0400
Message-ID: <48B3EAD9.60609@novell.com>
Date: Tue, 26 Aug 2008 07:36:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: mingo@elte.hu, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de, gregory.haskins@gmail.com
Subject: Re: [PATCH 2/5] sched: pull only one task during NEWIDLE balancing
 to limit critical section
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <20080825201529.23217.8708.stgit@dev.haskins.net> <200808261621.33810.nickpiggin@yahoo.com.au>
In-Reply-To: <200808261621.33810.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2EDC31A232C84FAA939EBA95"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2EDC31A232C84FAA939EBA95
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Nick Piggin wrote:
> On Tuesday 26 August 2008 06:15, Gregory Haskins wrote:
>  =20
>> git-id c4acb2c0669c5c5c9b28e9d02a34b5c67edf7092 attempted to limit
>> newidle critical section length by stopping after at least one task
>> was moved.  Further investigation has shown that there are other
>> paths nested further inside the algorithm which still remain that allo=
w
>> long latencies to occur with newidle balancing.  This patch applies
>> the same technique inside balance_tasks() to limit the duration of
>> this optional balancing operation.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> CC: Nick Piggin <npiggin@suse.de>
>>    =20
>
> Hmm, this (andc4acb2c0669c5c5c9b28e9d02a34b5c67edf7092) still could
> increase the amount of work to do significantly for workloads where
> the CPU is going idle and pulling tasks over frequently. I don't
> really like either of them too much.
>  =20

I had a feeling you may object to this patch based on your comments on
the first one.  Thats why I CC'd you so you wouldnt think I was trying
to sneak something past ;)

> Maybe increasing the limit would effectively amortize most of the
> problem (say, limit to move 16 tasks at most).
>  =20

The problem I was seeing was that even moving 2 was too many in the
ftraces traces I looked at.  I think the idea of making a variable limit
(set via a sysctl, etc) here is a good one, but I would recommend we
have the default be "1" for CONFIG_PREEMPT (or at least
CONFIG_PREEMPT_RT) based on what I know right now.   I know last time
you objected to any kind of special cases for the preemptible kernels,
but I think this is a good compromise.  Would this be acceptable?

Thanks Nick,

-Greg


--------------enig2EDC31A232C84FAA939EBA95
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkiz6tkACgkQlOSOBdgZUxkStACfXhVj1AcDxA+2axQmFVSEpVx4
loEAn2SqLVi2O7ZWp8hDvlyq4gh1Mptx
=WBs5
-----END PGP SIGNATURE-----

--------------enig2EDC31A232C84FAA939EBA95--
