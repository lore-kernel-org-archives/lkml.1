Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXB1UfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXB1UfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbXB1UfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:35:21 -0500
Received: from mail.screens.ru ([213.234.233.54]:39509 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbXB1UfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:35:19 -0500
Date: Wed, 28 Feb 2007 23:35:15 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: vatsa@in.ibm.com, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228203515.GA145@tv-sign.ru>
References: <200702272251.28844.rjw@sisk.pl> <200702282043.24779.rjw@sisk.pl> <20070228200853.GA122@tv-sign.ru> <200702282125.53318.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702282125.53318.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Rafael J. Wysocki wrote:
> 
> Okay, but I've just finished the patch that removes the freezability of
> workqueues (appended), so can we please do this in a separate one?

Please, please, no. This patch is of course correct, but it breaks _a lot_
of patches in -mm tree.

May I ask you to send just

> ===================================================================
> --- linux-2.6.21-rc2.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1829,11 +1829,11 @@ xfs_buf_init(void)
>  	if (!xfs_buf_zone)
>  		goto out_free_trace_buf;
>  
> -	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
> +	xfslogd_workqueue = create_workqueue("xfslogd");
>  	if (!xfslogd_workqueue)
>  		goto out_free_buf_zone;
>  
> -	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
> +	xfsdatad_workqueue = create_workqueue("xfsdatad");
>  	if (!xfsdatad_workqueue)
>  		goto out_destroy_xfslogd_workqueue;
>  
> 

this bit?

After that, we can do the "removes the freezability of workqueues" patch
against -mm tree.

Oleg.

