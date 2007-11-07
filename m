Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbXKGIv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbXKGIv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 03:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbXKGIvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 03:51:49 -0500
Received: from saeurebad.de ([85.214.36.134]:41582 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbXKGIvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 03:51:48 -0500
Date: Wed, 7 Nov 2007 09:50:27 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 04/23] dentries: Extract common code to remove dentry from lru
Message-ID: <20071107085027.GA6243@cataract>
Mail-Followup-To: Christoph Lameter <clameter@sgi.com>,
	akpm@linux-foundatin.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>
References: <20071107011130.382244340@sgi.com> <20071107011227.298491275@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107011227.298491275@sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Tue, Nov 06, 2007 at 05:11:34PM -0800, Christoph Lameter wrote:
> @@ -613,11 +606,7 @@ static void shrink_dcache_for_umount_sub
>  			spin_lock(&dcache_lock);
>  			list_for_each_entry(loop, &dentry->d_subdirs,
>  					    d_u.d_child) {
> -				if (!list_empty(&loop->d_lru)) {
> -					dentry_stat.nr_unused--;
> -					list_del_init(&loop->d_lru);
> -				}
> -
> +				dentry_lru_remove(dentry);

Shouldn't this be dentry_lru_remove(loop)?

	Hannes
