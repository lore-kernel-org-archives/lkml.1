Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbYHZO2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbYHZO2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbYHZO2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:28:43 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:43356 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbYHZO2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:28:42 -0400
Date: Tue, 26 Aug 2008 15:28:25 +0100
From: Andy Whitcroft <andyw@uk.ibm.com>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, davej@codemonkey.org.uk,
       jschopp@austin.ibm.com, David Woodhouse <dwmw2@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: checkpatch
Message-ID: <20080826142825.GG29207@brain>
References: <1219069200.3208.4.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219069200.3208.4.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 07:50:00PM +0530, Jaswinder Singh wrote:
> [jsr@jaswinder jaswinder-git]$ cat test.c
> void test(int i, int j, int k)
> {
> 	printk(KERN_INFO "/* Testing i, j, k */\n");
> 	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
> }
> [jsr@jaswinder jaswinder-git]$ ./linux-2.6/scripts/checkpatch.pl --file test.c
> ERROR: spaces required around that ':' (ctx:VxW)
> #4: FILE: test.c:4:
> +	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
>  	                   ^
> 
> ERROR: need consistent spacing around '%' (ctx:WxV)
> #4: FILE: test.c:4:
> +	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
>  	                     ^
> 
> ERROR: spaces required around that ':' (ctx:VxW)
> #4: FILE: test.c:4:
> +	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
>  	                         ^
> 
> ERROR: need consistent spacing around '%' (ctx:WxV)
> #4: FILE: test.c:4:
> +	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
>  	                           ^
> 
> ERROR: spaces required around that ':' (ctx:VxO)
> #4: FILE: test.c:4:
> +	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
>  	                               ^
> 
> total: 5 errors, 0 warnings, 5 lines checked
> 
> test.c has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> [jsr@jaswinder jaswinder-git]$ cat test_working.c 
> void test(int i, int j, int k)
> {
> 	printk(KERN_INFO "/* Testing i, j, k * /\n");
> 	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
> }
> [jsr@jaswinder jaswinder-git]$ ./linux-2.6/scripts/checkpatch.pl --file test_working.c 
> total: 0 errors, 0 warnings, 5 lines checked
> 
> test_working.c has no obvious style problems and is ready for submission.
> [jsr@jaswinder jaswinder-git]$ diff -uN test.c test_working.c 
> --- test.c	2008-08-18 19:38:32.000000000 +0530
> +++ test_working.c	2008-08-18 19:38:37.000000000 +0530
> @@ -1,5 +1,5 @@
>  void test(int i, int j, int k)
>  {
> -	printk(KERN_INFO "/* Testing i, j, k */\n");
> +	printk(KERN_INFO "/* Testing i, j, k * /\n");
>  	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
>  }
> [jsr@jaswinder jaswinder-git]$ cp test.c test
> [jsr@jaswinder jaswinder-git]$ ./linux-2.6/scripts/checkpatch.pl --file test
> total: 0 errors, 0 warnings, 5 lines checked
> 
> test has no obvious style problems and is ready for submission.
> [jsr@jaswinder jaswinder-git]$ 

Bah, a trivial bug in the comments/quote matcher leading to the apparent
close comment taking effect when quoted.  Should be fixed in my next
batch of updates to akpm (0.23).

-apw
