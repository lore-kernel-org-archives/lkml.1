Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZAYDSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZAYDSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 22:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZAYDSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 22:18:45 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52417 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbZAYDSo (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 22:18:44 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] audit: Fix compile time warning on kernel/auditsc.c
In-Reply-To: Your message of "Sat, 24 Jan 2009 01:50:30 +0600."
             <b9df5fa10901231150i1b9ea0f4n14d1cf60a9296a78@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <b9df5fa10901231150i1b9ea0f4n14d1cf60a9296a78@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1232853509_3444P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 24 Jan 2009 22:18:29 -0500
Message-ID: <32272.1232853509@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1232853509_3444P
Content-Type: text/plain; charset=us-ascii

On Sat, 24 Jan 2009 01:50:30 +0600, Rakib Mullick said:
>  Impact: Fix compile time warning.
> 
> The function audit_set_auditable called when CONFIG_AUDIT_TREE is set.
> When CONFIG_AUDIT_TREE is not set then it might be unused, which
> generates the following warning. Making audit_set_auditable function
> inline fixes this problem. If anything else please notice.
> 
> CC      kernel/auditsc.o
> kernel/auditsc.c:745: warning: 'audit_set_auditable' defined but not used
> 
> Thanks.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linux-2.6-orig/kernel/auditsc.c	2009-01-23 18:28:45.000000000 +0600
> +++ linux-2.6/kernel/auditsc.c	2009-01-23 22:31:34.145406088 +0600
> @@ -741,7 +741,7 @@ void audit_filter_inodes(struct task_str
>  	rcu_read_unlock();
>  }
> 
> -static void audit_set_auditable(struct audit_context *ctx)
> +static inline void audit_set_auditable(struct audit_context *ctx)

Blech.  That's abuse of inline.  Can you find some other, more kernel-y
way to address the issue?  (Possibly make it an actual inline up in a .h
file, with a #ifdef wrapping around it, or do something matching what's
done at the call site (apparently #ifdef'ing code is accepted in that .c
file, adding another #ifdef around that function to match all the *other*
'#ifdef CONFIG_AUDIT_TREE' would be less ugly than 'inline'.

--==_Exmh_1232853509_3444P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJe9oFcC3lWbTT17ARAqVWAJ9YZ4jEXQ3pVgV4GiF3S2JFCjrrPACeMPBE
e66xmjj6AZPqcbygPsD1cHo=
=AhqV
-----END PGP SIGNATURE-----

--==_Exmh_1232853509_3444P--
