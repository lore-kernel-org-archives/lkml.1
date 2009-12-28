Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbZL1Ij6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbZL1Ij6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZL1Ij5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:39:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZL1Ij4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:39:56 -0500
Subject: Re: [RFC PATCH] asynchronous page fault.
From: Peter Zijlstra <peterz@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
In-Reply-To: <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261915391.15854.31.camel@laptop>
	 <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 09:30:47 +0100
Message-ID: <1261989047.7135.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 09:36 +0900, KAMEZAWA Hiroyuki wrote:
> 
> > The idea is to let the RCU lock span whatever length you need the vma
> > for, the easy way is to simply use PREEMPT_RCU=y for now, 
> 
> I tried to remove his kind of reference count trick but I can't do that
> without synchronize_rcu() somewhere in unmap code. I don't like that and
> use this refcnt. 

Why, because otherwise we can access page tables for an already unmapped
vma? Yeah that is the interesting bit ;-)



