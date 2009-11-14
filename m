Return-Path: <linux-kernel-owner+w=401wt.eu-S1751929AbZKNFIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbZKNFIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 00:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZKNFIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 00:08:24 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:58965 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZKNFIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 00:08:24 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: daw-news@taverner.cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
In-Reply-To: Your message of "Sat, 14 Nov 2009 00:41:15 GMT."
             <hdkubb$rdb$1@taverner.cs.berkeley.edu>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <19857.1258147396@turing-police.cc.vt.edu> <Pine.LNX.4.64.0911132224370.6325@ask.diku.dk> <24306.1258153693@turing-police.cc.vt.edu>
            <hdkubb$rdb$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1258175307_3884P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 14 Nov 2009 00:08:27 -0500
Message-ID: <9337.1258175307@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.103 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4AFE3B4C.0052,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1258175307_3884P
Content-Type: text/plain; charset=us-ascii

On Sat, 14 Nov 2009 00:41:15 GMT, David Wagner said:

> 1) The particular code snippets under discussion here were of the
> form
>     strncmp(foo, "constant", sizeof("constant"))
> And the proposal is to replace this code with
>     strcmp(foo, "constant")
> Do you really mean to object to this proposal?

No, in that particular case strcmp() is Obviously Safe.

> 2) More generally, you seem to be concerned about bugs where one
> piece of code fails to '\0'-terminate a string, and another piece of
> code invokes some library function that relies upon '\0'-termination.

Exactly.

> That is not specifically a strcmp() issue; this is an issue with using
> any string library that assumes '\0'-termination, where the string is not
> '\0'-terminated.  That's a much broader issue that should be addressed by
> other means.

I know that - which is why I asked Julia if Cocinelle is able to do anything
in this area.  An awful lot of our \0-terminated strings end up that way
implicitly because somebody does a kzalloc() or bzero() of an entire
structure, which can be fragile if code is refactored.

By the same token, that implicit behavior means that it's probably quite
difficult for any programmatic correctness checkers to follow the behavior.

>              Saying "strcmp() is bad" is a poor response to this risk.

I didn't say "strcmp() is bad". I said it needs auditing.  The strn-
versions of functions have a guaranteed termination condition right there
in the call. For strcmp() and strcpy(), the termination guarantee is
often elsewhere, which is why code using them tends to be brittle and
is harder to audit.


--==_Exmh_1258175307_3884P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK/jtLcC3lWbTT17ARAr+tAKC59xssObMY4DFCm8/INiA8kZkO5wCeK/i1
6K2RfI6TL1bJV2r65RvwlG8=
=1ewX
-----END PGP SIGNATURE-----

--==_Exmh_1258175307_3884P--

