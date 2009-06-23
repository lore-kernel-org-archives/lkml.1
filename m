Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZFWF4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZFWF4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZFWFz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:55:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbZFWFz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:55:58 -0400
Date: Mon, 22 Jun 2009 22:55:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] printk boot_delay: use loops_per_msec instead of 
 printk_delay_msec
Message-Id: <20090622225553.8aa1dfb7.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0906160202r7124b8a7x29ace04cd910df52@mail.gmail.com>
References: <a8e1da0906160202r7124b8a7x29ace04cd910df52@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 17:02:24 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> Sorry, should post this firstly because the previous printk_delay
> patch depends on this,
> please review, thanks.
> --
> 
> Use loops_per_msec instead of printk_delay_msec for boot printk delay.
> 

The changelog is poor, because it fails to describe _why_ this change
is being made.  I rewrote it to

  Rename `printk_delay_msec' to `loops_per_msec', because the patch
  "printk: add printk_delay to make messages readable for some
  scenarios" wishes to more appropriately use the `printk_delay_msec'
  identifier.

> 
> --- linux-2.6.orig/kernel/printk.c	2009-06-15 10:53:10.000000000 +0800
> +++ linux-2.6/kernel/printk.c	2009-06-15 13:17:13.000000000 +0800
> @@ -198,12 +198,11 @@ __setup("log_buf_len=", log_buf_len_setu
>  #ifdef CONFIG_BOOT_PRINTK_DELAY
> 
>  static unsigned int boot_delay; /* msecs delay after each printk
> during bootup */
> -static unsigned long long printk_delay_msec; /* per msec, based on
> boot_delay */

Your email client is wordwrapping the patches.

