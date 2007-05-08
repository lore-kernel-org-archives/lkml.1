Return-Path: <linux-kernel-owner+w=401wt.eu-S970444AbXEHXmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970444AbXEHXmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968116AbXEHXmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:42:22 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49354 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968060AbXEHXmV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:42:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <andi@firstfloor.org>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: Lockup after logging out of X
In-Reply-To: Your message of "Wed, 09 May 2007 01:01:34 +0200."
             <20070508230134.GD17482@one.firstfloor.org>
From: Valdis.Kletnieks@vt.edu
References: <20070508195142.GA30030@deepthought>
            <20070508230134.GD17482@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178667721_15957P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 08 May 2007 19:42:01 -0400
Message-ID: <16127.1178667721@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178667721_15957P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 May 2007 01:01:34 +0200, Andi Kleen said:
> Already known, although it is still unclear what the bug actually is.
> Can you run with the appended patch please (from Eric Biederman)
> and post any backtraces the WARN_ON in there spews out?

> diff --git a/include/asm-x86_64/page.h b/include/asm-x86_64/page.h
> index b17fc16..e6a4d1e 100644

> +	if (likely(v < __START_KERNEL_map))				\
> +		v -= PAGE_OFFSET;					\
> +	else								\
> +		v = (v - __START_KERNEL_map) + phys_base;		\

ERROR: "phys_base" [net/sunrpc/sunrpc.ko] undefined!
ERROR: "phys_base" [net/sunrpc/auth_gss/rpcsec_gss_spkm3.ko] undefined!
ERROR: "phys_base" [net/sunrpc/auth_gss/auth_rpcgss.ko] undefined!
ERROR: "phys_base" [net/mac80211/mac80211.ko] undefined!
ERROR: "phys_base" [net/ieee80211/ieee80211_crypt_wep.ko] undefined!
ERROR: "phys_base" [net/ieee80211/ieee80211_crypt_tkip.ko] undefined!
ERROR: "phys_base" [fs/nfsd/nfsd.ko] undefined!
ERROR: "phys_base" [fs/nfs/nfs.ko] undefined!
ERROR: "phys_base" [fs/jbd2/jbd2.ko] undefined!
ERROR: "phys_base" [fs/ecryptfs/ecryptfs.ko] undefined!
ERROR: "phys_base" [drivers/net/ppp_mppe.ko] undefined!
ERROR: "phys_base" [drivers/char/agp/intel-agp.ko] undefined!
make[1]: *** [__modpost] Error 1

Looks like a missing EXPORT_SYMBOL. Unfortunately, the definition is here:

arch/x86_64/kernel/head.S:ENTRY(phys_base)

Do I need to go the old symtabs.c route and stick the EXPORT_SYMBOL in some
other .c file?

--==_Exmh_1178667721_15957P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGQQrJcC3lWbTT17ARAiOsAKCWj0lP6+bBSZDIOhPkBi4KiC2h2ACeIVfq
zAAKLWaC+7O8UVvgWGXtMvY=
=XfAT
-----END PGP SIGNATURE-----

--==_Exmh_1178667721_15957P--
