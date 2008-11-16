Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbYKPI2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbYKPI2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYKPI22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:28:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45942
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbYKPI21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:28:27 -0500
Date: Sun, 16 Nov 2008 00:19:26 -0800 (PST)
Message-Id: <20081116.001926.150424480.davem@davemloft.net>
To: arjan@infradead.org
Cc: laijs@cn.fujitsu.com, akpm@linux-foundation.org, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081115205229.765f7ee3@infradead.org>
References: <491FA28B.2070003@cn.fujitsu.com>
	<20081115205229.765f7ee3@infradead.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Sat, 15 Nov 2008 20:52:29 -0800

> On Sun, 16 Nov 2008 12:33:15 +0800
> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > 
> > some subsystem needs vmalloc() when required memory is large.
> > but current kernel has not APIs for this requirement.
> > this patch introduces simple_malloc() and simple_free().
> 
> I kinda really don't like this approach. vmalloc() (and especially,
> vfree()) is a really expensive operation, and vmalloc()'d memory is
> also slower (due to tlb pressure). Realistically, people should try hard
> to use small datastructure instead....

This is happening in many places, already, for good reason.

There are lots of places where we can't (core hash tables, etc.)  and
we want NUMA spreading and reliable allocation, and thus vmalloc it
is.

And with Nick Piggin's recent patches cost of the vmalloc allocation
operation itself is no longer an issue.

I encouraged people to write this patch because we _ALREADY DO THIS_
in many places and it's pure code duplication.

And whatever particular heuristics you think are best for these cases,
with a common piece of code you can enforce it in ONE place instead of
several which is what is happening right now..
