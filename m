Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbZGCKN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbZGCKN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZGCKNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:13:50 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57258 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZGCKNt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:13:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] selinux_bprm_committed_creds: use __wake_up_parent()
In-Reply-To: Your message of "Fri, 03 Jul 2009 11:23:11 +0200."
             <20090703092311.GA3712@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org> <11314.1246585948@turing-police.cc.vt.edu> <20090702192047.10b81ada.akpm@linux-foundation.org> <20090703081821.GA4051@redhat.com>
            <20090703092311.GA3712@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246615973_3932P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 03 Jul 2009 06:12:53 -0400
Message-ID: <4098.1246615973@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246615973_3932P
Content-Type: text/plain; charset=us-ascii

On Fri, 03 Jul 2009 11:23:11 +0200, Oleg Nesterov said:
> (depends on ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
>  which exports __wake_up_parent)
> 
> Spotted by Valdis.Kletnieks@vt.edu.
> 
> selinux_bprm_committed_creds() should not play with ->wait_chldexit, now
> that __wake_up_parent() is exported change the code to use this helper.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> --- WAIT/security/selinux/hooks.c~SEL_WAKE_PARENT	2009-06-16 17:01:42.000000000 +0200
> +++ WAIT/security/selinux/hooks.c	2009-07-03 11:15:08.000000000 +0200

Oleg: Thanks muchly - I applied the patch, reverted the mm/vmscan.c patch that
was giving others trouble, and 31-rc1-mmotm0702 is up and running

Feel free to stick a

Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

on it as it goes upstream...


--==_Exmh_1246615973_3932P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKTdmlcC3lWbTT17ARAvJ4AJ46VeOgRjphHBymowWKgmN4OfTOEACfU090
F9aimj6UEDQYkvCZlQSfNQw=
=FaL/
-----END PGP SIGNATURE-----

--==_Exmh_1246615973_3932P--
