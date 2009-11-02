Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbZKBWAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbZKBWAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbZKBWAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:00:36 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:25687 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbZKBWAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:00:36 -0500
Date: Mon, 2 Nov 2009 13:59:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: akpm <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: offload per node attribute registrations fix
Message-Id: <20091102135935.d7bffe05.randy.dunlap@oracle.com>
In-Reply-To: <1257198615.7401.212.camel@useless.americas.hpqcorp.net>
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
	<4AEE56A1.6010100@oracle.com>
	<1257198615.7401.212.camel@useless.americas.hpqcorp.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AEF567D.0027:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Nov 2009 16:50:15 -0500 Lee Schermerhorn wrote:

> 
> Against:  2.6.32-rc5-mmotm-091101-1001
> 
> Fix build failure when MEMORY_HOTPLUG_SPARSE and !HUGETLBFS:
> 
> drivers/base/node.c:484: error: implicit declaration of function 'init_node_hugetlb_work'
> drivers/base/node.c:582: error: 'node_memory_callback' undeclared (first use in this function)
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

Ack.  That works_for_me.  Thanks.


>  drivers/base/node.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.32-rc5-mmotm-091101-1001/drivers/base/node.c
> ===================================================================
> --- linux-2.6.32-rc5-mmotm-091101-1001.orig/drivers/base/node.c	2009-11-02 15:51:43.000000000 -0500
> +++ linux-2.6.32-rc5-mmotm-091101-1001/drivers/base/node.c	2009-11-02 16:41:36.000000000 -0500
> @@ -445,8 +445,12 @@ static int node_memory_callback(struct n
>  }
>  #endif	/* CONFIG_HUGETLBFS */
>  #else	/* !CONFIG_MEMORY_HOTPLUG_SPARSE */
> +
>  static int link_mem_sections(int nid) { return 0; }
> +#endif	/* CONFIG_MEMORY_HOTPLUG_SPARSE */
>  
> +#if !defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || \
> +    !defined(CONFIG_HUGETLBFS)
>  static inline int node_memory_callback(struct notifier_block *self,
>  				unsigned long action, void *arg)
>  {
> @@ -455,7 +459,7 @@ static inline int node_memory_callback(s
>  
>  static void init_node_hugetlb_work(int nid) { }
>  
> -#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
> +#endif
>  
>  int register_one_node(int nid)
>  {
> 
> 


---
~Randy
