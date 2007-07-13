Return-Path: <linux-kernel-owner+w=401wt.eu-S933872AbXGMIFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbXGMIFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934513AbXGMIFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:05:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41670 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbXGMIFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:05:07 -0400
Date: Fri, 13 Jul 2007 16:03:36 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org, gurudas.pai@oracle.com
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-ID: <20070713080336.GB21833@joejin-pc.cn.oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com> <20070712221842.f5e47065.akpm@linux-foundation.org> <20070713064004.GA21833@joejin-pc.cn.oracle.com> <20070712234938.c77f3a48.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712234938.c77f3a48.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > The patch looks good for this bug, thanks :)
> 
> If you have time could you test it and sent it back at me please?
> 

Test passed and panic gone.
thanks.

> > if other caller give a invalid nid to alloc_pages_node(), __alloc_pages
> > will crash again.
> 
> That would be a buggy caller, so we should fix that caller.
> 
> > So I think we add some sanity check for nid at alloc_pages_node is
> > meaningful.  
> > 
> > another question, if (nid >= MAX_NUMNODES),  may I set nid to 0 directly
> > like following code?
> > 
> > 	if (unlikly(nid >= MAX_NUMNODES)
> > 		nid = 0
> 
> if (nid > MAX_NUMNODES) then that is a bug and we should report it (doing
> this via a BUG() is OK) rather than quietly covering it up.
> 
> if (nid == MAX_NUMNODES) then we should set it to
> first_node(node_online_map);

OK, will do it and send you a patch :)
