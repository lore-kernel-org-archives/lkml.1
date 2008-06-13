Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbYFMAkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbYFMAkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 20:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYFMAkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 20:40:00 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:52284 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688AbYFMAj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 20:39:59 -0400
Message-ID: <4851C1CC.7070607@ct.jp.nec.com>
Date: Thu, 12 Jun 2008 17:39:40 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 06/24] vmscan: split LRU lists into anon & file sets
References: <20080611184214.605110868@redhat.com> <20080611184339.159161465@redhat.com>
In-Reply-To: <20080611184339.159161465@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Split the LRU lists in two, one set for pages that are backed by
> real file systems ("file") and one for pages that are backed by
> memory and swap ("anon").  The latter includes tmpfs.
> 
> The advantage of doing this is that the VM will not have to scan
> over lots of anonymous pages (which we generally do not want to
> swap out), just to find the page cache pages that it should evict.
> 
> This patch has the infrastructure and a basic policy to balance
> how much we scan the anon lists and how much we scan the file
> lists. The big policy changes are in separate patches.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Hi,

nitpick

...
> Index: linux-2.6.26-rc5-mm2/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.26-rc5-mm2.orig/mm/page_alloc.c	2008-06-10 13:34:48.000000000 -0400
> +++ linux-2.6.26-rc5-mm2/mm/page_alloc.c	2008-06-10 13:35:23.000000000 -0400
> @@ -1834,10 +1834,13 @@ void show_free_areas(void)
>  		}
>  	}
>  
> -	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n"
> +	printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"

inactive_anon:%lu?

thanks,
Hiroshi Shimamoto
