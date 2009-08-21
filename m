Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbZHURvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbZHURvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932482AbZHURvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:51:16 -0400
Received: from mx2.netapp.com ([216.240.18.37]:16637 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472AbZHURvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:51:12 -0400
X-IronPort-AV: E=Sophos;i="4.44,251,1249282800"; 
   d="scan'208";a="228875685"
Subject: Re: [PATCH -mmotm] nfs/cache_lib: fix sunrpc struct build error
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <20090821095756.390c102e.randy.dunlap@oracle.com>
References: <200908210222.n7L2Musb015815@imap1.linux-foundation.org>
	 <20090821095756.390c102e.randy.dunlap@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Fri, 21 Aug 2009 13:51:12 -0400
Message-Id: <1250877072.27154.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 21 Aug 2009 17:51:13.0663 (UTC) FILETIME=[F993E8F0:01CA2287]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 09:57 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add header file for struct delayed_work:
> 
> In file included from fs/nfs/cache_lib.c:14:
> include/linux/sunrpc/rpc_pipe_fs.h:35: error: field 'queue_timeout' has incomplete type
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  include/linux/sunrpc/rpc_pipe_fs.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- mmotm-2009-0820-1918.orig/include/linux/sunrpc/rpc_pipe_fs.h
> +++ mmotm-2009-0820-1918/include/linux/sunrpc/rpc_pipe_fs.h
> @@ -3,6 +3,8 @@
>  
>  #ifdef __KERNEL__
>  
> +#include <linux/workqueue.h>
> +
>  struct rpc_pipe_msg {
>  	struct list_head list;
>  	void *data;

Thanks Randy! Bruce Fields beat you to this bug by a few hours, so I've
already applied his fix. It should hit linux-next et al today.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
