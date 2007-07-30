Return-Path: <linux-kernel-owner+w=401wt.eu-S937819AbXG3DPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937819AbXG3DPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 23:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764790AbXG3DO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 23:14:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39753 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbXG3DO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 23:14:58 -0400
Date: Mon, 30 Jul 2007 08:57:15 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
cc: osst@riede.org, osst-users@lists.sourceforge.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/5] Use mutex instead of semaphore in the OnStream SCSI
 Tape driver
In-Reply-To: <20070729213633.GE3432@traven>
Message-ID: <alpine.LFD.0.999.0707300853390.10861@enigma.security.iitk.ac.in>
References: <20070729212909.GC3432@traven> <20070729213633.GE3432@traven>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Sun, 29 Jul 2007, Matthias Kaehlcke wrote:

> The OnStream SCSI Tape driver uses a semaphore as mutex. Use the mutex
> API instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> [...]
> @@ -3298,7 +3298,7 @@ static ssize_t osst_write(struct file * filp, const char __user * buf, size_t co
>  	char		    * name = tape_name(STp);
>  
>  
> -	if (down_interruptible(&STp->lock))
> +	if (mutex_lock_interruptible(&STp->lock))
>  		return (-ERESTARTSYS);

The () after return existed in the code already, but you could've felt
free to remove them :-)

> @@ -3619,7 +3619,7 @@ static ssize_t osst_read(struct file * filp, char __user * buf, size_t count, lo
>  	char		    * name  = tape_name(STp);
>  
>  
> -	if (down_interruptible(&STp->lock))
> +	if (mutex_lock_interruptible(&STp->lock))
>  		return (-ERESTARTSYS);

Same here.

Reviewed-by: Satyam Sharma <satyam@infradead.org>
