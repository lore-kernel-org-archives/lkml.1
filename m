Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbXJDCB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbXJDCB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 22:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXJDCBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 22:01:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42438 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbXJDCBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 22:01:46 -0400
Date: Thu, 04 Oct 2007 11:00:12 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [Patch / 002](memory hotplug) Callback function to create kmem_cache_node.
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0710031057150.3570@schroedinger.engr.sgi.com>
References: <20071003234201.B5F9.Y-GOTO@jp.fujitsu.com> <Pine.LNX.4.64.0710031057150.3570@schroedinger.engr.sgi.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071004103830.6A6A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 3 Oct 2007, Yasunori Goto wrote:
> 
> > > 
> > > That would work. But it would be better to shrink the cache first. The 
> > > first 2 slabs on a node may be empty and the shrinking will remove those. 
> > > If you do not shrink then the code may falsely assume that there are 
> > > objects on the node.
> > 
> > I'm sorry, but I don't think I understand what you mean... :-(
> > Could you explain more? 
> > 
> > Which slabs should be shrinked? kmem_cache_node and kmem_cache_cpu?
> 
> The slab for which you are trying to set the kmem_cache_node pointer to 
> NULL needs to be shrunk.
>  
> > I think kmem_cache_cpu should be disabled by cpu hotplug,
> > not memory/node hotplug. Basically, cpu should be offlined before
> > memory offline on the node.
> 
> Hmmm.. Ok for cpu hotplug you could simply disregard the per cpu 
> structure if the per cpu slab was flushed first.
> 
> However, the per node structure may hold slabs with no objects even after 
> all objects were removed on a node. These need to be flushed by calling
> kmem_cache_shrink() on the slab cache.
> 
> On the other hand: If you can guarantee that they will not be used and 
> that no objects are in them and that you can recover the pages used in 
> different ways then zapping the per node pointer like that is okay.

Thanks for your advise. I'll reconsider and fix my patches.

Bye.

-- 
Yasunori Goto 


