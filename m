Return-Path: <linux-kernel-owner+w=401wt.eu-S936789AbXHNWLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936789AbXHNWLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbXHNVse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:48:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49233 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764285AbXHNVsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:48:32 -0400
Date: Tue, 14 Aug 2007 14:48:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
In-Reply-To: <20070814214430.GD23308@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708141444590.32110@schroedinger.engr.sgi.com>
References: <p73vebhnauo.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com>
 <20070814203329.GA22202@one.firstfloor.org>
 <Pine.LNX.4.64.0708141341120.31513@schroedinger.engr.sgi.com>
 <20070814204454.GC22202@one.firstfloor.org>
 <Pine.LNX.4.64.0708141414260.31693@schroedinger.engr.sgi.com>
 <20070814212355.GA23308@one.firstfloor.org>
 <Pine.LNX.4.64.0708141425000.31693@schroedinger.engr.sgi.com>
 <20070814212955.GC23308@one.firstfloor.org>
 <Pine.LNX.4.64.0708141436380.31693@schroedinger.engr.sgi.com>
 <20070814214430.GD23308@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > But that still creates lots of overhead each time we take the lru lock!
> 
> A lot of overhead in what way? Setting a flag in a cache hot
> per CPU data variable shouldn't be more than a few cycles.

Could you be a bit more specific? Where do you want to place the data?

What we are talking about is

atomic_inc(&zone->reclaim_cpu[smp_processor_id()]);
smp_wmb();
spin_lock(&zone->lru_lock);

....

spin_unlock(&zone_lru_lock);
smp_wmb();
atomic_dec(&zone->reclaim_cpu[smp_processor_id()]);

That is not light weight.

