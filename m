Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYKTT7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYKTT7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYKTT7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:59:08 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45614 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbYKTT7H (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:59:07 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm: slab - __cache_alloc NULL prefetch fix
In-Reply-To: Your message of "Thu, 20 Nov 2008 19:44:00 +0300."
             <20081120164400.GC7363@localhost>
From: Valdis.Kletnieks@vt.edu
References: <20081120164400.GC7363@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1227211108_3208P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Nov 2008 14:58:28 -0500
Message-ID: <28180.1227211108@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1227211108_3208P
Content-Type: text/plain; charset=us-ascii

On Thu, 20 Nov 2008 19:44:00 +0300, Cyrill Gorcunov said:

> -	prefetchw(objp);
>  
> -	if (likely(objp))
> +	if (likely(objp)) {
> +		prefetchw(objp);
>  		kmemcheck_slab_alloc(cachep, flags, objp, obj_size(cachep));
> +	}

Although it probably makes sense to not bother prefetching NULL, I also
need to wonder how useful it is to prefetch something that we then
turn around and dereference in the very next line of code.

Maybe we should just lose the prefetch entirely?

--==_Exmh_1227211108_3208P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJJcFkcC3lWbTT17ARApy7AKDZeb+owCkG/9T2Oa/obDcce2iYDwCg+m4M
w1bb7hm9D+bhf0vjm4gRtzA=
=0hm7
-----END PGP SIGNATURE-----

--==_Exmh_1227211108_3208P--
