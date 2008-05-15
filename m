Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYEOD3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYEOD3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYEOD3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:29:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37582 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYEOD3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:29:15 -0400
Date: Thu, 15 May 2008 12:34:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 2/6] memcg: remove refcnt
Message-Id: <20080515123423.db3f79e2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080515105740.66e210db.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080514170236.23c9ddd7.kamezawa.hiroyu@jp.fujitsu.com>
	<20080514170703.db2d9802.kamezawa.hiroyu@jp.fujitsu.com>
	<482B950C.2060408@cn.fujitsu.com>
	<20080515105740.66e210db.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 10:57:40 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > >  #ifdef CONFIG_DEBUG_VM
> > > Index: linux-2.6.26-rc2/mm/shmem.c
> > > ===================================================================
> > > --- linux-2.6.26-rc2.orig/mm/shmem.c
> > > +++ linux-2.6.26-rc2/mm/shmem.c
> > > @@ -961,13 +961,14 @@ found:
> > >  		shmem_swp_unmap(ptr);
> > >  	spin_unlock(&info->lock);
> > >  	radix_tree_preload_end();
> > > -uncharge:
> > > -	mem_cgroup_uncharge_page(page);
> > >  out:
> > >  	unlock_page(page);
> > >  	page_cache_release(page);
> > >  	iput(inode);		/* allows for NULL */
> > >  	return error;
> > > +uncharge:
> > > +	mem_cgroup_uncharge_cache_page(page);
> > > +	goto out;
> > >  }
> > >  
> > 
> > Seems the logic is changed here. is it intended ?
> > 
> intended. (if success, uncharge is not necessary because there is no refcnt.
> I'll add comment.
> 
But, it seems patch 6/6 doesn't seem to be optimal in this case.
and have some troubles...I'll find a workaround.
It seems that shmem's memcg is complicated...

Thanks,
-Kame


