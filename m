Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbYKPIWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbYKPIWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYKPIV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:21:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46418
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbYKPIV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:21:56 -0500
Date: Sun, 16 Nov 2008 00:21:55 -0800 (PST)
Message-Id: <20081116.002155.74280893.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: arjan@infradead.org, laijs@cn.fujitsu.com, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081115210334.3870cdf6.akpm@linux-foundation.org>
References: <491FA28B.2070003@cn.fujitsu.com>
	<20081115205229.765f7ee3@infradead.org>
	<20081115210334.3870cdf6.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 15 Nov 2008 21:03:34 -0800

> On Sat, 15 Nov 2008 20:52:29 -0800 Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > Realistically, people should try hard
> > to use small datastructure instead....
> 
> Yup, it makes it easier for people to do something which we strongly
> discourage.  The risk got worse with all these 64-bit machines with
> vast amounts of virtual address space.  It makes it easier for people
> to develop and "test" code which isn't reliable on smaller machines.

I don't see it as being used for common operations (unlike vmap BTW,
which XFS does like crazy).  It's mainly for core hash tables and
similarly large structures.  And also, for those things, the NUMA
spreading helps.

And, in any event, for those cases:

1) we are already doing this exact thing

2) due to #1 we have N copies of the same damn code

So whatever policy fits your fancy, wouldn't it be better to "enforce"
this in one spot instead of the 12 copies we have already?

