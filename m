Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZHIJhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZHIJhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZHIJho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:37:44 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:14079 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbZHIJhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HR5s5R9ceGapjEPJl6LtLR0+MbfssvnsW03k5nr+7oOWYgCNUGxcXpXP+6qJYfLSnI
         LyWuaW1OBDoikQ6N9CUjChypj4WJOWw9Phwk363UwYNKKuQCJCw4ZQ8wNlTmMSXxPrmD
         zmP4eMyRSH36lY6sFBzDmCrnU61aKSsi+Fst8=
Date: Sun, 9 Aug 2009 12:40:48 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2
Message-ID: <20090809094048.GA3100@localdomain.by>
References: <20090806180930.GA3004@localdomain.by>
 <87d478i0d7.fsf@basil.nowhere.org>
 <4A7CEC70.4050806@gmail.com>
 <20090808073534.GA12190@basil.fritz.box>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <20090808073534.GA12190@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/08/09 10:22), Robert Hancock wrote:
> Actually, the Intel Architecture Optimization Reference Manual doesn't
> say divide may be faster, but it does say that "On processors based on
> Intel NetBurst microarchitecture, latencies of some instructions are
> relatively significant (including shifts, rotates, integer multiplies,
> and moves from memory with sign extension)." and that "The SHIFT and
> ROTATE instructions have a longer latency on processor with a CPUID
> signature corresponding to family 15 and model encoding of 0, 1, or 2.
> The latency of a sequence of adds will be shorter for left shifts of thre=
e or less."

Intel Architecture Optimization Reference Manual does say about latency:

Table C-13a. General Purpose Instructions
Instruction		Latency				Throughput
IDIV 		| 11-21	13-23	17-41	22	| 5-13	5-14	12-36	22
SAL/SAR/SHL/SHR	| 1	1	1		| 0.33	0.33	0.33

For example,
Table 12-2. Intel=C2=AE Atom=E2=84=A2 Microarchitecture Instructions Latenc=
y Data
Instruction		Latency		Throughput
IDIV r/m8; IDIV r/m16;	| 33;42;	| 32;41;56;196
IDIV r/m32; IDIV r/m64;	| 57;197	|
			|		|
ROL; ROR; SAL; 		| 1		| 1
SAR; SHL; SHR		|		|

*SHLD/SHRD		|4;2-11	|3;1-10



On (08/08/09 09:35), Andi Kleen wrote:
> DIV should be always slower than a SHIFT.
>
> But it has nothing really to do with the CPU. The point is that the compi=
ler
> always selects a suitable one by itself. Rewriting x / 2 to x >> 1 is
> one of the easiest exercises in compiler optimizations.
>
> The only case when the compiler cannot do this easily by itself is
> when the dividend is not a constant.
>

        int width =3D (vc->vc_font.width + 7) >> 3;

> That said -Os sometimes screws us up on this, but it's still not worth
> doing this change manually.
>

My point is that it should 'look the same'.
I mean there are 5
        int width =3D (vc->vc_font.width + 7) >> 3;
*not exactly this one, but vc->vc_font.width (+ 7)? >> 3

and _only_ one
        int width =3D (vc->vc_font.width + 7) / 8;

P.S.
Sorry, hit "reply", not "reply to all".

        Sergey

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp+maAACgkQfKHnntdSXjTO0QQAsHtaQ6GGDhuI3dyaxciTp1+T
I1C8lzwhkwRYYl9QNfYacXpzVe5hSRK1Jkxgq6c8uORf3yM8fBvyxiNF1lbp4K1N
X3S9HoSBy31c92u1g/L61YnfAuXki+SODPe+p3lkXTh+GtlUbf60zMJHBZ2+4YiT
cBr6DmE2arrTEQRgKT0=
=qoDZ
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
