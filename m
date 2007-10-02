Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbXJBS37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbXJBS37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbXJBS3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:29:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49138 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752195AbXJBS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:29:51 -0400
Date: Tue, 2 Oct 2007 11:29:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [Patch / 002](memory hotplug) Callback function to create
 kmem_cache_node.
In-Reply-To: <20071002105422.2790.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0710021128510.30615@schroedinger.engr.sgi.com>
References: <20071001183316.7A9B.Y-GOTO@jp.fujitsu.com>
 <Pine.LNX.4.64.0710011334090.19779@schroedinger.engr.sgi.com>
 <20071002105422.2790.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Yasunori Goto wrote:

> Do you mean that just nr_slabs should be checked like followings?
> I'm not sure this is enough.
> 
>     :
> if (s->node[nid]) {
> 	n = get_node(s, nid);
> 	if (!atomic_read(&n->nr_slabs)) {
> 		s->node[nid] = NULL;
> 		kmem_cache_free(kmalloc_caches, n);
> 	}
> }
>     :
>     :

That would work. But it would be better to shrink the cache first. The 
first 2 slabs on a node may be empty and the shrinking will remove those. 
If you do not shrink then the code may falsely assume that there are 
objects on the node.
