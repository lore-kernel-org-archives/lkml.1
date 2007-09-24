Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbXIXINd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbXIXINd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXIXINY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:13:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52931 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbXIXINX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:13:23 -0400
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
Content-Type: multipart/signed; boundary="==_Exmh_1190621599_3891P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2007 04:13:19 -0400
Message-ID: <6227.1190621599@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190621599_3891P
Content-Type: text/plain; charset=us-ascii

On Mon, 24 Sep 2007 11:44:35 +0400, Alexey Dobriyan said:

> Interesting. Here is output from kernel with patch applied and leak
> plugged into proc_dointvec() (I checked twice):
> 
>         $ grep kcalloc /proc/slab_allocators
>         $ grep proc_dointvec /proc/slab_allocators
>         size-64: 19 proc_dointvec+0x48/0xa0

Argh, went to "cancel" that previous msg and retry when I realized you meant it was
with *your* patch installed, managed to send it anyhow..

I wonder if the only reason it's working for you is because gcc is doing
some tail-recursion magic on the kcalloc() call (which calls to __kmalloc),
which just happens to make it work, and if the tail-recursion wasn't happening
it would be busticated.

--==_Exmh_1190621599_3891P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG93GfcC3lWbTT17ARAkcYAJ9b0MeN7NC6j3AcSfYvFQt7IFCWbwCg0hz0
khbqcUPBJiBlwOVo0QEnJzo=
=XZ9G
-----END PGP SIGNATURE-----

--==_Exmh_1190621599_3891P--
