Return-Path: <linux-kernel-owner+w=401wt.eu-S968837AbXHMRIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968837AbXHMRIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031946AbXHMQsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:48:12 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34205 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970039AbXHMQsK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:48:10 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
In-Reply-To: Your message of "Mon, 13 Aug 2007 10:00:44 EDT."
             <20070813140044.GB1960@hmsreliant.think-freely.org>
From: Valdis.Kletnieks@vt.edu
References: <20070813140044.GB1960@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187023658_3175P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Aug 2007 12:47:38 -0400
Message-ID: <10638.1187023658@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187023658_3175P
Content-Type: text/plain; charset=us-ascii

On Mon, 13 Aug 2007 10:00:44 EDT, Neil Horman said:
> Hey there-
> 	Currently, there exists no method for a process to query the resource
> limits of another process.  They can be inferred via some mechanisms but they
> cannot be explicitly determined.  Given that this information can be usefull to
> know during the debugging of an application, I've written this patch which
> exports all of a processes limits via /proc/<pid>/limits.  Tested successfully
> by myself on x86 on top of 2.6.23-rc2-mm1.

>  /************************************************************************/
>  /*                       Here the fs part begins                        */
>  /************************************************************************/
> @@ -2017,6 +2080,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	INF("environ",    S_IRUSR, pid_environ),
>  	INF("auxv",       S_IRUSR, pid_auxv),
>  	INF("status",     S_IRUGO, pid_status),
> +	INF("limits",	  S_IRUGO, pid_limits),

Any takers for S_IRUSR instead?  Either that, or lay out the use case for
making it S_IRUGO.  (I'm OK on it being world-visible *if* there's a good
and sane reason for it)

>  #ifdef CONFIG_SCHED_DEBUG
>  	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
>  #endif
> @@ -2310,6 +2374,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  	INF("environ",   S_IRUSR, pid_environ),
>  	INF("auxv",      S_IRUSR, pid_auxv),
>  	INF("status",    S_IRUGO, pid_status),
> +	INF("limits",	 S_IRUGO, pid_limits),

Here too.

--==_Exmh_1187023658_3175P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGwIsqcC3lWbTT17ARAj90AJwNaHgTgWN91dKPxTqUcjaDC/TuiwCgwAOg
iUDlsa+b/VUTg4VPSZ1My6M=
=95Fs
-----END PGP SIGNATURE-----

--==_Exmh_1187023658_3175P--
