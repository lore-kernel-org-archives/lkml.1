Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbYESXBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbYESXBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYESXAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:00:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbYESXAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:00:54 -0400
Date: Mon, 19 May 2008 16:00:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       hskinnemoen@atmel.com, linux@maxim.org.za, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_lcdfb: FIFO underflow management
Message-Id: <20080519160006.12a30e71.akpm@linux-foundation.org>
In-Reply-To: <482D7F44.7040404@atmel.com>
References: <482D7F44.7040404@atmel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 14:34:12 +0200
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> Manage atmel_lcdfb FIFO underflow
> 
> Resetting the LCD and DMA allows to fix screen shifting after a 
> FIFO underflow. It follows reset sequence from errata 
> "LCD Screen Shifting After a Reset".
> 

This looks like 2.6.26-worthy bugfix to me?  But as commonly happens,
that isn't terribly clear.

> +	if (status & ATMEL_LCDC_UFLWI) {
> +		dev_warn(info->device, "FIFO underflow %#x\n", status);
> +		/* reset DMA and FIFO to avoid screen shifting */
> +		schedule_work(&sinfo->task);
> +	}
> +	lcdc_writel(sinfo, ATMEL_LCDC_ICR, status);
>  	return IRQ_HANDLED;
>  }

Shouldn't there be a cancel_work_sync() in atmel_lcdfb_exit()?


> +	/* Initialize bottom half workqueue */

Well.  "bottom half" is an ancient term for softirqs, not for the
new-fangled process-context callbacks.
