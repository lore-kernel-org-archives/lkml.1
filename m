Return-Path: <linux-kernel-owner+w=401wt.eu-S933424AbXGLB2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424AbXGLB2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763426AbXGLB2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:28:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763151AbXGLB2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:28:04 -0400
Date: Wed, 11 Jul 2007 18:27:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: tytso@mit.edu, "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rocket: Fix mutex locking compile warning
Message-Id: <20070711182721.0c0e2235.akpm@linux-foundation.org>
In-Reply-To: <200707120156.32795.mb@bu3sch.de>
References: <200707120156.32795.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 01:56:32 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> This fixes
> 
> drivers/char/rocket.c: In function ‘rp_write’:
> drivers/char/rocket.c:1705: warning: ignoring return value of ‘mutex_lock_interruptible’, declared with attribute warn_unused_result
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> Index: bu3sch-wireless-dev/drivers/char/rocket.c
> ===================================================================
> --- bu3sch-wireless-dev.orig/drivers/char/rocket.c	2007-05-18 18:09:48.000000000 +0200
> +++ bu3sch-wireless-dev/drivers/char/rocket.c	2007-07-12 01:52:44.000000000 +0200
> @@ -1702,7 +1702,8 @@ static int rp_write(struct tty_struct *t
>  	if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
>  		return 0;
>  
> -	mutex_lock_interruptible(&info->write_mtx);
> +	if (mutex_lock_interruptible(&info->write_mtx))
> +		return -ERESTARTSYS;
>  
>  #ifdef ROCKET_DEBUG_WRITE
>  	printk(KERN_INFO "rp_write %d chars...", count);
> 

Thanks, I already have this queued as
rocketc-fix-unchecked-mutex_lock_interruptible.patch
