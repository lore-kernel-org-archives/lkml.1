Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbYLFG0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbYLFG0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 01:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYLFG0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 01:26:41 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41166 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYLFG0k (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 01:26:40 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtk.manpages@googlemail.com
Subject: Re: MAC and pam_nologin (was Re: man-pages-3.15 is released)
In-Reply-To: Your message of "Sat, 06 Dec 2008 14:04:07 +0900."
             <200812061404.EJG35994.MOJOFQFOLFHtVS@I-love.SAKURA.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <493A01E0.1070705@gmail.com>
            <200812061404.EJG35994.MOJOFQFOLFHtVS@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1228544795_5654P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 06 Dec 2008 01:26:35 -0500
Message-ID: <12563.1228544795@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1228544795_5654P
Content-Type: text/plain; charset=us-ascii

On Sat, 06 Dec 2008 14:04:07 +0900, Tetsuo Handa said:

(Not really a LSM or kernel issue, and I think mtk.man does kernel
manpages only.  At least on my Fedora and RedHat systems, the 'login' manpage
comes from util-linux, so any manpage fixes would go via that route).

> But this description becomes inaccurate when MAC (e.g. SELinux) is enabled.
> 
> MAC can deny open("/etc/nologin", O_RDONLY) by root user. Thus,
> 
>   # ln /etc/shadow /etc/nologin
> 
> will create /etc/nologin which is *not readable* by login(1).
> As a result, non-root user's logins are permitted while /etc/nologin *exists*
> 
> I guess pam_nologin is using a code like
> 
>   fp = fopen("/etc/nologin", "r");
>   if (fp)
>      /* print the contents of /etc/nologin and reject login request. */

Rather than guessing, maybe a check of what the source code actually *does*
would be better?

> So, I think either one of below modifications is needed.
> 
> (1) Change the description of manpage like
> 
>   If the file /etc/nologin *is readable*, login (1) will allow access only to
>   root. Other users will be shown the contents of this file and their logins
>   will be refused.
> 
> (2) Change the code of pam_nologin like
> 
>   fd = open("/etc/nologin", O_RDONLY);
>   if (fd != EOF || errno != ENOENT)
>      /* print the contents of /etc/nologin and reject login request. */

(3) Recognize that a sysadmin who intentionally goes and creates a
/etc/nologin via insane means deserves the insane results.  You have to
go out of your way to actually create a case where the distinction between
"exists" and "is readable" matters.

Having said that, we probably *should* fix 'man login' to say 'is readable'.



--==_Exmh_1228544795_5654P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJOhsbcC3lWbTT17ARAgZCAKDyYcsEh+0RLR/XhxcPHNY2vmreZACgpcg5
sFdH2PnLNN0TdoVTHmUObow=
=yfIy
-----END PGP SIGNATURE-----

--==_Exmh_1228544795_5654P--
