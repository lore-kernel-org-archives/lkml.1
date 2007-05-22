Return-Path: <linux-kernel-owner+w=401wt.eu-S934163AbXEVRAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163AbXEVRAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758341AbXEVRAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:00:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33401 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbXEVRAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:00:40 -0400
Subject: Re: use mutex instead of semaphore in RocketPort driver
From: Arjan van de Ven <arjan@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: matthias.kaehlcke@gmail.com
In-Reply-To: <200705081903.l48J3lr1012622@hera.kernel.org>
References: <200705081903.l48J3lr1012622@hera.kernel.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 22 May 2007 09:59:01 -0700
Message-Id: <1179853142.3296.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> -	down_interruptible(&info->write_sem);
> +	mutex_lock_interruptible(&info->write_mtx);
>  
>  #ifdef ROCKET_DEBUG_WRITE
>  	printk(KERN_INFO "rp_write %d chars...", count);
> @@ -1773,7 +1776,7 @@ end:
>  		wake_up_interruptible(&tty->poll_wait);
>  #endif
>  	}
> -	up(&info->write_sem);
> +	mutex_unlock(&info->write_mtx);
>  	return retval

this code is very very buggy.

mutex_lock_interruptible() may not get the mutex in case a signal
happens... and yet you unlox the mutex unconditionally!!!


