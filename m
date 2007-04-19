Return-Path: <linux-kernel-owner+w=401wt.eu-S1766951AbXDSTWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766951AbXDSTWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766952AbXDSTWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:22:18 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:52609 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766951AbXDSTWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:22:17 -0400
To: a.p.zijlstra@chello.nl
CC: miklos@szeredi.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com
In-reply-to: <1177008406.2934.19.camel@lappy> (message from Peter Zijlstra on
	Thu, 19 Apr 2007 20:46:46 +0200)
Subject: Re: [PATCH 09/12] mm: count unstable pages per BDI
References: <20070417071046.318415445@chello.nl>
	 <20070417071703.710381113@chello.nl>
	 <E1Heafy-0006ia-00@dorka.pomaz.szeredi.hu> <1177006362.2934.13.camel@lappy> <1177008406.2934.19.camel@lappy>
Message-Id: <E1HecBc-0006vS-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 19 Apr 2007 21:20:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6/fs/buffer.c
> ===================================================================
> --- linux-2.6.orig/fs/buffer.c	2007-04-19 19:59:26.000000000 +0200
> +++ linux-2.6/fs/buffer.c	2007-04-19 20:35:39.000000000 +0200
> @@ -733,7 +733,7 @@ int __set_page_dirty_buffers(struct page
>  	if (page->mapping) {	/* Race with truncate? */
>  		if (mapping_cap_account_dirty(mapping)) {
>  			__inc_zone_page_state(page, NR_FILE_DIRTY);
> -			__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
> +			__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIM);

This name suggests it's _under_ reclaim, which is not true.  You might
rather want to call it BDI_RECLAIMABLE, or something similar in
meaning.

Miklos
