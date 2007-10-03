Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbXJCPAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbXJCPAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXJCPAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:00:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38785 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbXJCPAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:00:22 -0400
Date: Wed, 03 Oct 2007 23:59:23 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [Patch / 002](memory hotplug) Callback function to create kmem_cache_node.
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0710021128510.30615@schroedinger.engr.sgi.com>
References: <20071002105422.2790.Y-GOTO@jp.fujitsu.com> <Pine.LNX.4.64.0710021128510.30615@schroedinger.engr.sgi.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071003234201.B5F9.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2 Oct 2007, Yasunori Goto wrote:
> 
> > Do you mean that just nr_slabs should be checked like followings?
> > I'm not sure this is enough.
> > 
> >     :
> > if (s->node[nid]) {
> > 	n = get_node(s, nid);
> > 	if (!atomic_read(&n->nr_slabs)) {
> > 		s->node[nid] = NULL;
> > 		kmem_cache_free(kmalloc_caches, n);
> > 	}
> > }
> >     :
> >     :
> 
> That would work. But it would be better to shrink the cache first. The 
> first 2 slabs on a node may be empty and the shrinking will remove those. 
> If you do not shrink then the code may falsely assume that there are 
> objects on the node.

I'm sorry, but I don't think I understand what you mean... :-(
Could you explain more? 

Which slabs should be shrinked? kmem_cache_node and kmem_cache_cpu?

I think kmem_cache_cpu should be disabled by cpu hotplug,
not memory/node hotplug. Basically, cpu should be offlined before
memory offline on the node.

Sorry, I'm confusing now...

-- 
Yasunori Goto 


