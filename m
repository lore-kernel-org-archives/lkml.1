Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYKPFEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYKPFEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 00:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYKPFEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 00:04:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYKPFEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 00:04:14 -0500
Date: Sat, 15 Nov 2008 21:03:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Message-Id: <20081115210334.3870cdf6.akpm@linux-foundation.org>
In-Reply-To: <20081115205229.765f7ee3@infradead.org>
References: <491FA28B.2070003@cn.fujitsu.com>
	<20081115205229.765f7ee3@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2008 20:52:29 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

> On Sun, 16 Nov 2008 12:33:15 +0800
> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > 
> > some subsystem needs vmalloc() when required memory is large.
> > but current kernel has not APIs for this requirement.
> > this patch introduces simple_malloc() and simple_free().
> 
> Hi
> 
> I kinda really don't like this approach. vmalloc() (and especially,
> vfree()) is a really expensive operation, and vmalloc()'d memory is
> also slower (due to tlb pressure).

And it can fragment, which effectively means a dead box.

> Realistically, people should try hard
> to use small datastructure instead....

Yup, it makes it easier for people to do something which we strongly
discourage.  The risk got worse with all these 64-bit machines with
vast amounts of virtual address space.  It makes it easier for people
to develop and "test" code which isn't reliable on smaller machines.

