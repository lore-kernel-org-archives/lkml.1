Return-Path: <linux-kernel-owner+w=401wt.eu-S935775AbXGMIQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935775AbXGMIQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760993AbXGMIPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:15:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761377AbXGMIPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:15:53 -0400
Date: Fri, 13 Jul 2007 01:15:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Jin <joe.jin@oracle.com>
Cc: bill.irwin@oracle.com, linux-kernel@vger.kernel.org,
       gurudas.pai@oracle.com, Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070713011543.22797645.akpm@linux-foundation.org>
In-Reply-To: <20070713080336.GB21833@joejin-pc.cn.oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
	<20070712234938.c77f3a48.akpm@linux-foundation.org>
	<20070713080336.GB21833@joejin-pc.cn.oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 16:03:36 +0800 Joe Jin <joe.jin@oracle.com> wrote:

> > > 
> > > The patch looks good for this bug, thanks :)
> > 
> > If you have time could you test it and sent it back at me please?
> > 
> 
> Test passed and panic gone.

Patch gone too ;) I deleted it.  I was hoping that you'd send me the final
finished product (please).

> thanks.
> 
> > > if other caller give a invalid nid to alloc_pages_node(), __alloc_pages
> > > will crash again.
> > 
> > That would be a buggy caller, so we should fix that caller.
> > 
> > > So I think we add some sanity check for nid at alloc_pages_node is
> > > meaningful.  
> > > 
> > > another question, if (nid >= MAX_NUMNODES),  may I set nid to 0 directly
> > > like following code?
> > > 
> > > 	if (unlikly(nid >= MAX_NUMNODES)
> > > 		nid = 0
> > 
> > if (nid > MAX_NUMNODES) then that is a bug and we should report it (doing
> > this via a BUG() is OK) rather than quietly covering it up.
> > 
> > if (nid == MAX_NUMNODES) then we should set it to
> > first_node(node_online_map);
> 
> OK, will do it and send you a patch :)

Thanks.  Please cc Paul Jackson <pj@sgi.com> on that patch.
