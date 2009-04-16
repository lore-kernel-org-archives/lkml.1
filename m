Return-Path: <linux-kernel-owner+w=401wt.eu-S1758537AbZDPTGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbZDPTGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZDPTGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:06:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:60062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619AbZDPTGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:06:30 -0400
Subject: Re: [PATCH] removes unused variable from kernel/sysctl.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <a85e78f50904161052s71dabbe9p17ac68b35331eae@mail.gmail.com>
References: <a85e78f50904161052s71dabbe9p17ac68b35331eae@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 00:36:20 +0530
Message-Id: <1239908780.10567.8.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sukanto,

On Thu, 2009-04-16 at 23:22 +0530, Sukanto Ghosh wrote:
> This patch removes the unused variable 'val' from the
> __do_proc_dointvec() function
> in kernel/sysctl.h. The integer has been declared and used as 'val =
> -val' and there is
> no reference to it anywhere.
> Although I am this doesn't affects the kernel binary because gcc
> removes it, still it
> might be confusing for people reading the code.
> 

This patch is already submitted by Tomohiro Kusumi on Thu Dec 27 2007:

http://lkml.indiana.edu/hypermail/linux/kernel/0712.3/0557.html

> 
> Signed-off-by: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
> 
> ----
> 
> --- linux-2.6.29.1/kernel/sysctl.c.orig 2009-04-16 19:57:21.000000000 +0530
> +++ linux-2.6.29.1/kernel/sysctl.c      2009-04-16 19:58:26.000000000 +0530
> @@ -2198,7 +2198,7 @@ static int __do_proc_dointvec(void *tbl_
>                   void *data)

This is a very old function and have almost no git history, its old name
was do_proc_dointvec on 2005-04-16 15:20:36 when git tree was made and
then only(almost) function name is changed.

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

So you need to do further investigation. Is this a typo or some other
mistake.

--
JSR

