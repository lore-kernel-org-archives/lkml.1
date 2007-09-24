Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbXIXHza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbXIXHza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXIXHzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:55:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37980 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbXIXHzX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:55:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Uninline kcalloc()
In-Reply-To: Your message of "Mon, 24 Sep 2007 11:44:35 +0400."
             <b6fcc0a0709240044x62369dbcv1b5c69ce0be68581@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20070922200349.GA2119@martell.zuzino.mipt.ru> <25045.1190612108@turing-police.cc.vt.edu>
            <b6fcc0a0709240044x62369dbcv1b5c69ce0be68581@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190620520_3891P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2007 03:55:20 -0400
Message-ID: <5480.1190620520@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190620520_3891P
Content-Type: text/plain; charset=us-ascii

On Mon, 24 Sep 2007 11:44:35 +0400, Alexey Dobriyan said:
> On 9/24/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> > On Sun, 23 Sep 2007 00:03:49 +0400, Alexey Dobriyan said:
> >
> > > -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> > > -{
> > > -	if (n != 0 && size > ULONG_MAX / n)
> > > -		return NULL;
> > > -	return __kmalloc(n * size, flags | __GFP_ZERO);
> > > -}
> > > +void *kcalloc(size_t n, size_t size, gfp_t flags);
> >
> > NAK.
> >
> > This busticates some pretty subtle code in mm/slab.c that uses
> > uses __builtin_return_address() for debugging
> 
> Interesting. Here is output from kernel with patch applied and leak
> plugged into proc_dointvec() (I checked twice):
> 
>         $ grep kcalloc /proc/slab_allocators

Right.  That was the whole *point* of the patch to inline kcalloc - otherwise
you ended up with zillions of entries for kcalloc that didn't tell you where
they came from.

>         $ grep proc_dointvec /proc/slab_allocators
>         size-64: 19 proc_dointvec+0x48/0xa0

A lot more useful, no? ;)
<confoozled> I'm failing to see where proc_dointvec() ends up calling kcalloc?
So I'm not sure what that's

--==_Exmh_1190620520_3891P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG921ocC3lWbTT17ARAjViAKC43rzpuWent7pE1ZRXu2Ygz9031wCguhEq
e5rHwslmM65l+8qerJLf2Wg=
=ynQl
-----END PGP SIGNATURE-----

--==_Exmh_1190620520_3891P--
