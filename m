Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbXKGS7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbXKGS7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbXKGS7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:59:42 -0500
Received: from lazybastard.de ([212.112.238.170]:43086 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbXKGS7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:59:42 -0500
Date: Wed, 7 Nov 2007 19:54:53 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Johannes Weiner <hannes-kernel@saeurebad.de>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 04/23] dentries: Extract common code to remove dentry from lru
Message-ID: <20071107185452.GD8918@lazybastard.org>
References: <20071107011130.382244340@sgi.com> <20071107011227.298491275@sgi.com> <20071107085027.GA6243@cataract> <20071107094348.GB7374@lazybastard.org> <Pine.LNX.4.64.0711071054240.11906@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0711071054240.11906@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 November 2007 10:55:09 -0800, Christoph Lameter wrote:
> 
> From: Christoph Lameter <clameter@sgi.com>
> Subject: dcache: use the correct variable.
> 
> We need to use "loop" instead of "dentry"
> 
> Acked-by: Joern Engel <joern@logfs.org>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Index: linux-2.6/fs/dcache.c
> ===================================================================
> --- linux-2.6.orig/fs/dcache.c	2007-11-07 10:26:20.000000000 -0800
> +++ linux-2.6/fs/dcache.c	2007-11-07 10:26:27.000000000 -0800
> @@ -610,7 +610,7 @@ static void shrink_dcache_for_umount_sub
>  			spin_lock(&dcache_lock);
>  			list_for_each_entry(loop, &dentry->d_subdirs,
>  					    d_u.d_child) {
> -				dentry_lru_remove(dentry);
> +				dentry_lru_remove(loop);
>  				__d_drop(loop);
>  				cond_resched_lock(&dcache_lock);
>  			}

Erm - wouldn't this break git-bisect?

Jörn

-- 
Joern's library part 5:
http://www.faqs.org/faqs/compression-faq/part2/section-9.html
