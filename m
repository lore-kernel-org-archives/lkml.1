Return-Path: <linux-kernel-owner+w=401wt.eu-S2992484AbXDCXBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992484AbXDCXBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992485AbXDCXBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:01:52 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40956 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992484AbXDCXBv (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:01:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Performance Stats: Kernel patch
In-Reply-To: Your message of "Tue, 03 Apr 2007 16:54:43 +0400."
             <46124E93.2000408@ru.mvista.com>
From: Valdis.Kletnieks@vt.edu
References: <46124E93.2000408@ru.mvista.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175641303_7609P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Apr 2007 19:01:43 -0400
Message-ID: <16797.1175641303@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175641303_7609P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Apr 2007 16:54:43 +0400, Maxim Uvarov said:

> What do you think about it? Patch is bellow.

Was this patch actually compile and run tested?

> Index: linux-2.6.18/fs/proc/array.c
> ===================================================================
> --- linux-2.6.18.orig/fs/proc/array.c
> +++ linux-2.6.18/fs/proc/array.c
> @@ -295,6 +295,18 @@ static inline char *task_cap(struct task
>                             cap_t(p->cap_effective));
>  }
> 
> +#ifdef THREAD_PERF_STAT

This needs to be CONFIG_THREAD_PERF_STAT everyplace except the Kconfig stuff.

> +static inline char *task_perf(struct task_struct *p, char *buffer)
> +{
> +    return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
> +                           "Nivcsw:\t%lu\n"
> +                           "Syscalls:\t%d\n",
> +                           cap_t(p->nvcsw),
> +                           cap_t(p->nivcsw),
> +                           cap_t(p->sysc_cnt));
> +}

You might want a #else that defines a null body for this inline, to
avoid a problem a bit later.

> +#endif /* THREAD_PERF_STAT */
> +
>  #define get_blocked_on(t)      (-1)
> 
>  static char *show_blocked_on(struct task_struct *task, char *buffer)
> @@ -327,6 +339,7 @@ int proc_pid_status(struct task_struct *
>         buffer = task_show_regs(task, buffer);
>  #endif
>         buffer = show_blocked_on(task,buffer);
> +       buffer = task_perf(task, buffer);

What will this call if you don't have THREAD_PERF_STAT defined?

Here's where you need the #else clause providing a null body for you....

I don't see how this could possibly have built cleanly, since the CONFIG_
issue above would have prevented you from defining a task_perf() function...



--==_Exmh_1175641303_7609P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGEtzXcC3lWbTT17ARAp+FAKCXvZp3qFWOeTGIKu4CETVOmhQV/ACfQBKN
d42SV/a/wDxa5h189JnzAlI=
=4tut
-----END PGP SIGNATURE-----

--==_Exmh_1175641303_7609P--
