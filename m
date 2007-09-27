Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbXI0GOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbXI0GOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXI0GOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:14:37 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39113 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXI0GOg (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:14:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Shreyansh Jain <shreyansh.jain@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: =?utf-8?b?dHJ5X21vZHVsZV9nZXQ=?= code understanding
In-Reply-To: Your message of "Thu, 27 Sep 2007 05:19:06 -0000."
             <loom.20070927T051622-501@post.gmane.org>
From: Valdis.Kletnieks@vt.edu
References: <loom.20070927T051622-501@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190873674_2832P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Sep 2007 02:14:34 -0400
Message-ID: <9977.1190873674@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190873674_2832P
Content-Type: text/plain; charset=us-ascii

On Thu, 27 Sep 2007 05:19:06 -0000, Shreyansh Jain said:

> -----
> static inline int try_module_get(struct module *module){
>   int ret = 1;   <--- error case when !module
>     if (module) {
>          unsigned int cpu = get_cpu();
>          if (likely(module_is_live(module)))
>                 local_inc(&module->ref[cpu].count);
>          else
>                 ret = 0;   <--- error case
>          put_cpu();
>   }
>   return ret;   <----
> }

> 1. In case the module pointer passed is invalid (NULL) this function would
> return 1 (error case)
> 2. In case the module pointer is OK, and module is currently not being removed,
> reference count would be incremented and 1 returned (non error case)
> 3. In case the module pointer is OK, and module reference count can NOT be
> increased, 0 would be returned (error case).
> 
> As you can observe from above points, 0 and 1 are returned for error cases. I am
> a little confused and wondering if there is something which I am missing in this
> code??.

Go look at the call sites for this function - I bet that most of them, if they
check the return code at all, only check for zero or nonzero, because they only
*care* about the case that returns zero. Since they already know they're not
passing a NULL pointer, they don't worry about that case returning a 1.  So
there's only two realistic returns - either the module is live or it isn't.

--==_Exmh_1190873674_2832P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG+0pKcC3lWbTT17ARAnGjAJ4qN0pO9WRt/gV835MVG4M81l4X6wCfSRpf
bdFdUAavDxJdF1pgPIQXJQI=
=xiDQ
-----END PGP SIGNATURE-----

--==_Exmh_1190873674_2832P--
