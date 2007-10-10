Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbXJJTyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbXJJTyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbXJJTye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:54:34 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37992 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbXJJTyd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:54:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] SELinux: change Kconfig to use select instead of depends
In-Reply-To: Your message of "Wed, 10 Oct 2007 08:40:31 PDT."
             <470CF26F.10606@oracle.com>
From: Valdis.Kletnieks@vt.edu
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au> <Xine.LNX.4.64.0710100918520.14862@us.intercode.com.au> <20071009162812.00e80a0c.randy.dunlap@oracle.com> <1192018350.2687.16.camel@moss-spartans.epoch.ncsc.mil>
            <470CF26F.10606@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1192045982_2784P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 10 Oct 2007 15:53:02 -0400
Message-ID: <27818.1192045982@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1192045982_2784P
Content-Type: text/plain; charset=us-ascii

On Wed, 10 Oct 2007 08:40:31 PDT, Randy Dunlap said:

> >>>  config SECURITY_SELINUX
> >>>  	bool "NSA SELinux Support"
> >>> -	depends on SECURITY_NETWORK && AUDIT && NET && INET
> >>> +	depends on SECURITY
> >>> +	select SECURITY_NETWORK
> >>> +	select AUDIT
> >>> +	select NET
> >>> +	select INET
> >>>  	select NETWORK_SECMARK

> AUDIT isn't quite library code, still I don't have a (big) problem with
> selecting it or NETWORK_SECMARK.  (other than select is evil :)
> 
> OTOH, NET and INET are large config options, not library-like code, and
> should not be selected.

If it does a 'select SECURITY_NETWORK' but NET=n, does the resulting kernel
actually build?  The problem seems to be that select isn't transitive - if
you select something, it won't automagically select that something's pre-reqs
(modulo the recent patches I've seen posted, have those been mainlined?).


--==_Exmh_1192045982_2784P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHDS2ecC3lWbTT17ARAon9AKC8JfOFtPWbvoIP6LhXPfYFv2sV4QCg7J9t
hWQHXfMLVEjoZQK3v1gn6Sg=
=ym/f
-----END PGP SIGNATURE-----

--==_Exmh_1192045982_2784P--
