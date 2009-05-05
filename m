Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZEEMgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZEEMgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 08:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZEEMg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 08:36:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZEEMg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 08:36:28 -0400
Date: Tue, 5 May 2009 14:36:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] removes unused variable from kernel/sysctl.h
In-Reply-To: <a85e78f50904161052s71dabbe9p17ac68b35331eae@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0905051434400.22532@wotan.suse.de>
References: <a85e78f50904161052s71dabbe9p17ac68b35331eae@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009, Sukanto Ghosh wrote:

> This patch removes the unused variable 'val' from the
> __do_proc_dointvec() function
> in kernel/sysctl.h. The integer has been declared and used as 'val =
> -val' and there is
> no reference to it anywhere.
> Although I am this doesn't affects the kernel binary because gcc
> removes it, still it
> might be confusing for people reading the code.
> 
> 
> Signed-off-by: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
> 
> ----
> 
> --- linux-2.6.29.1/kernel/sysctl.c.orig 2009-04-16 19:57:21.000000000 +0530
> +++ linux-2.6.29.1/kernel/sysctl.c      2009-04-16 19:58:26.000000000 +0530
> @@ -2198,7 +2198,7 @@ static int __do_proc_dointvec(void *tbl_
>                   void *data)
>  {
>  #define TMPBUFLEN 21
> -       int *i, vleft, first=1, neg, val;
> +       int *i, vleft, first=1, neg;
>         unsigned long lval;
>         size_t left, len;
> 
> @@ -2251,8 +2251,6 @@ static int __do_proc_dointvec(void *tbl_
>                         len = p-buf;
>                         if ((len < left) && *p && !isspace(*p))
>                                 break;
> -                       if (neg)
> -                               val = -val;
>                         s += len;
>                         left -= len;

This doesn't seem to be picked up by anyone, CCing akpm.

-- 
Jiri Kosina
SUSE Labs
