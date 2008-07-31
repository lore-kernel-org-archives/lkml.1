Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbYGaAVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbYGaAVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763418AbYGaAUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:20:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763432AbYGaAUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:20:21 -0400
Date: Wed, 30 Jul 2008 17:20:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: eegorov@ru.mvista.com
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: pro_arm_davinci_watchdog_fix.patch
Message-Id: <20080730172011.8d86d215.akpm@linux-foundation.org>
In-Reply-To: <1216726599.3538.3.camel@localhost.localdomain>
References: <1216726599.3538.3.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 15:36:39 +0400
Egorov Evgeny <eegorov@ru.mvista.com> wrote:

>     This patch fix bug of watchdog driver's write fuction
>     which allow to prevent wdt timeout. 
> 
> Index: linux-2.6.18/drivers/char/watchdog/davinci_wdt.c
> ===================================================================
> --- linux-2.6.18.orig/drivers/char/watchdog/davinci_wdt.c
> +++ linux-2.6.18/drivers/char/watchdog/davinci_wdt.c
> @@ -133,13 +133,8 @@ static ssize_t
>  davinci_wdt_write(struct file *file, const char *data, size_t len,
>  		  loff_t *ppos)
>  {
> -	/*  Can't seek (pwrite) on this device  */
> -	if (ppos != &file->f_pos)
> -		return -ESPIPE;
> -
>  	if (len)
>  		wdt_service();
> -
>  	return len;
>  }

Thanks, but 2.6.25's drivers/watchdog/davinci_wdt.c already has this
fix, and we're not maintaining any kernels which are older than that.

