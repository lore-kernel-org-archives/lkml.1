Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYDRWVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYDRWVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 18:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYDRWVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 18:21:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbYDRWVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 18:21:06 -0400
Date: Fri, 18 Apr 2008 15:20:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb: add kgdb internal test suite
Message-Id: <20080418152043.5beea7b2.akpm@linux-foundation.org>
In-Reply-To: <200804181900.m3IJ0mn0011597@hera.kernel.org>
References: <200804181900.m3IJ0mn0011597@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 19:00:48 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e8d31c204e36e019b9134f2a11926cac0fcf9b19
> Commit:     e8d31c204e36e019b9134f2a11926cac0fcf9b19
> Parent:     737a460f21febe551ff1d2299b63bae9b154078f
> Author:     Jason Wessel <jason.wessel@windriver.com>
> AuthorDate: Fri Mar 7 16:34:17 2008 -0600
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu Apr 17 20:05:42 2008 +0200
> 
>     kgdb: add kgdb internal test suite
>
> ...
>
> +static const char hexchars[] = "0123456789abcdef";

42!  That's a great place to stop.

> +static char get_buf[BUFMAX];

This really needs to be renamed.

> +	int (*run_test) (int, int);
> +	int (*validate_put) (char *);
> +};
> +
> +static struct test_state ts;
> +
> +static int kgdbts_unreg_thread(void *ptr)
> +{
> +	/* Wait until the tests are complete and then ungresiter the I/O
> +	 * driver.
> +	 */
> +	while (!final_ack)
> +		msleep_interruptible(1500);

Why 1.5 seconds?  Seems like a pointless wats of time - can we use just 1
here?

> +#ifdef CONFIG_X86

btw, is the selftest code known to work on any other architectures?



afacit pretty much all of this code could/should be __init, but isn't?
