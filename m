Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYGYKsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYGYKsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYGYKsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:48:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48042 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYGYKsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:48:01 -0400
Date: Fri, 25 Jul 2008 19:46:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 30/30] nfs: fix various memory recursions possible with swap over NFS.
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>
In-Reply-To: <20080724141531.486682621@chello.nl>
References: <20080724140042.408642539@chello.nl> <20080724141531.486682621@chello.nl>
Message-Id: <20080725194517.86BB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> GFP_NOFS is not enough, since swap traffic is IO, hence fall back to GFP_NOIO.

this comment imply turn on GFP_NOIO, but the code is s/NOFS/NOIO/. why?



>  struct nfs_write_data *nfs_commitdata_alloc(void)
>  {
> -	struct nfs_write_data *p = kmem_cache_alloc(nfs_wdata_cachep, GFP_NOFS);
> +	struct nfs_write_data *p = kmem_cache_alloc(nfs_wdata_cachep, GFP_NOIO);




