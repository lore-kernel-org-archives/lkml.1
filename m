Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXCAIiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXCAIiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933115AbXCAIiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:38:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34400 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbXCAIiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:38:08 -0500
Date: Thu, 1 Mar 2007 00:37:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: tony@bakeyournoodle.com (Tony Breeds)
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Fix soft lockup with iSeries viocd driver
Message-Id: <20070301003748.5a571916.akpm@linux-foundation.org>
In-Reply-To: <20070301035640.GS4575@bakeyournoodle.com>
References: <20070301035640.GS4575@bakeyournoodle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 14:56:40 +1100 tony@bakeyournoodle.com (Tony Breeds) wrote:

> From: Tony Breeds <tony@bakeyournoodle.com>
> 
> Fix soft lockup with iSeries viocd driver, caused by eventually calling
> end_that_request_first() with nr_bytes 0.
> 
> The lockup is triggered by hald, interrogating the device.
> 

What causes the lockup, and how does this patch fix it?

> 
> Index: linux-2.6.20-rc5/drivers/cdrom/viocd.c
> ===================================================================
> --- linux-2.6.20-rc5.orig/drivers/cdrom/viocd.c
> +++ linux-2.6.20-rc5/drivers/cdrom/viocd.c
> @@ -376,6 +376,25 @@ static int send_request(struct request *
>         return 0;
>  }
>  
> +static void viocd_end_request(struct request *req, int uptodate)
> +{
> +       int nsectors = req->hard_nr_sectors;

Your email client replaces tabs with spaces.  I fixed this patch up.
