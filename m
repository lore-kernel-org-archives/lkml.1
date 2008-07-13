Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYGMI0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYGMI0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 04:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYGMI0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 04:26:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbYGMI0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 04:26:38 -0400
Date: Sun, 13 Jul 2008 01:26:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jakub W. Jozwicki" <jozwicki@aster.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25.10 1/2] libata: fix locking for kmap_atomic
Message-Id: <20080713012630.d5e522f7.akpm@linux-foundation.org>
In-Reply-To: <200807130127.36706.jozwicki@aster.pl>
References: <200807130127.36706.jozwicki@aster.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 01:27:36 +0200 "Jakub W. Jozwicki" <jozwicki@aster.pl> wrote:

> Change locking surrounding kmap_atomic from local_irqsave to 
> local_irqsave_nort. This fixes issues with PREEMPT_RT.
>  

I assume this is a -rt kernel patch.

> 
> --- linux-2.6.25.10/drivers/ata/libata-core.c	2008-07-03 05:46:47.000000000 
> +0200
> +++ linux-2.6.25.10-rt7/drivers/ata/libata-core.c	2008-07-12 
> 23:59:33.132140258 +0200
> @@ -5157,14 +5157,14 @@
>  		unsigned long flags;
>  
>  		/* FIXME: use a bounce buffer */
> -		local_irq_save(flags);
> +		local_irq_save_nort(flags);

eww.  If we're going to have to do stuff like this in mainline then
there might be a revolt.

