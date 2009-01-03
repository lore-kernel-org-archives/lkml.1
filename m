Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbZACQha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbZACQha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758019AbZACQhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:37:12 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54564 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759924AbZACQhI (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:37:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-mmotm1230 - BUG during 'shutdown -h'
In-Reply-To: Your message of "Sat, 03 Jan 2009 17:43:35 +1030."
             <200901031743.35578.rusty@rustcorp.com.au>
From: Valdis.Kletnieks@vt.edu
References: <4491.1230900738@turing-police.cc.vt.edu>
            <200901031743.35578.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231000591_3203P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 03 Jan 2009 11:36:31 -0500
Message-ID: <3543.1231000591@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231000591_3203P
Content-Type: text/plain; charset=us-ascii

On Sat, 03 Jan 2009 17:43:35 +1030, Rusty Russell said:
> On Friday 02 January 2009 23:22:18 Valdis.Kletnieks@vt.edu wrote:
> > 100% repeatable.  I haven't had a chance to bisect and track this down yet,
> > though most of the obvious suspects are in either origin.patch or linux-next.patch
> > so a bisect of -mmotm probably won't tell us much.
> 
> kernel/workqueue.c: In function 'wq_cpu_map':
> kernel/workqueue.c:94: warning: pointer type mismatch in conditional expression
> 
> That's a problem for a start.  Looks like a merge bug.  Does removing the &
> from in front of cpu_populated_map help?

Fixing that did fix the compiler warning.  However, it didn't fix the
blowup during shutdown.  I'll dig into it more later this weekend.

--==_Exmh_1231000591_3203P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJX5QPcC3lWbTT17ARApHtAKDoL3kBHHN3Ej/682IfcLd1Ga6wKgCfdLKn
ewYJMkDO4U2mq6VN84Y3TT4=
=md6Z
-----END PGP SIGNATURE-----

--==_Exmh_1231000591_3203P--
