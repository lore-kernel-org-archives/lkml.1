Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYAXFa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYAXFa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 00:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYAXFaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 00:30:17 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56228 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYAXFaP (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 00:30:15 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mike Galbraith <efault@gmx.de>, Frederik Himpe <fhimpe@telenet.be>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
In-Reply-To: Your message of "Tue, 22 Jan 2008 16:25:58 +1100."
             <200801221625.58615.nickpiggin@yahoo.com.au>
From: Valdis.Kletnieks@vt.edu
References: <1200949086.6648.19.camel@Anastacia> <200801221105.11413.nickpiggin@yahoo.com.au> <1200978207.3944.8.camel@homer.simson.net>
            <200801221625.58615.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201152611_2830P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jan 2008 00:30:11 -0500
Message-ID: <27437.1201152611@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201152611_2830P
Content-Type: text/plain; charset=us-ascii

On Tue, 22 Jan 2008 16:25:58 +1100, Nick Piggin said:
>
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -4920,8 +4920,7 @@ static void show_task(struct task_struct
>  	printk(KERN_CONT "%5lu %5d %6d\n", free,
>  		task_pid_nr(p), task_pid_nr(p->real_parent));
>  
> -	if (state != TASK_RUNNING)
> -		show_stack(p, NULL);
> +	show_stack(p, NULL);
>  }

Maybe something like this would be better?

	if (state == TASK_RUNNING)
		printk("running task, stack trace may be inaccurate\n");
	show_stack(p, NULL);

Just a thought....

--==_Exmh_1201152611_2830P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmCJjcC3lWbTT17ARAi26AKDhkBH6srtvQiQNvwcwm2VdsB5+HwCdGmwG
v91IHj0U+lptQv7hFH088GQ=
=Ko1A
-----END PGP SIGNATURE-----

--==_Exmh_1201152611_2830P--
