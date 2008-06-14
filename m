Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbYFNEP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbYFNEP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 00:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYFNEPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 00:15:51 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59338 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYFNEPu (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 00:15:50 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl
Subject: Re: odd timing bug with cgroups?
In-Reply-To: Your message of "Fri, 13 Jun 2008 15:38:29 MDT."
             <4852E8D5.3000503@nortel.com>
From: Valdis.Kletnieks@vt.edu
References: <4852E8D5.3000503@nortel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1213416930_21332P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 14 Jun 2008 00:15:31 -0400
Message-ID: <47364.1213416931@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1213416930_21332P
Content-Type: text/plain; charset=us-ascii

On Fri, 13 Jun 2008 15:38:29 MDT, Chris Friesen said:

> This seems odd...I would think that as soon as the fork() call returns 
> in the parent we should be able to put that task into a group.

I'm admittedly shooting in the dark here, but remember that a successful
fork() call returns *twice*.  Just because the *parent* has returned
doesn't mean that the *child* has finished all the processing and returned
as well - it may be delayed by other kernel threads etc and still not quite
ready for tweaking.

It sounds like a variant of the race conditions we had a while back where
lots of programs blew chunks when we started having "child runs first"
semantics so children could run and exit before the parent was ready
for it?

--==_Exmh_1213416930_21332P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIU0XicC3lWbTT17ARAtGjAJ9Shf9AnPe+HEbi6uvF3o4mlGjOxQCfaQXe
XbWLB5R8y9Frue41KVPFh58=
=e0RY
-----END PGP SIGNATURE-----

--==_Exmh_1213416930_21332P--
