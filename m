Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXHNVPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXHNVPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbXHNVPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:15:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47099 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754789AbXHNVPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:15:13 -0400
Date: Tue, 14 Aug 2007 14:15:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
In-Reply-To: <20070814204454.GC22202@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708141414260.31693@schroedinger.engr.sgi.com>
References: <20070814153021.446917377@sgi.com> <20070814153501.766137366@sgi.com>
 <p73vebhnauo.fsf@bingen.suse.de> <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com>
 <20070814203329.GA22202@one.firstfloor.org>
 <Pine.LNX.4.64.0708141341120.31513@schroedinger.engr.sgi.com>
 <20070814204454.GC22202@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > Hmmmm... The spinlock is its own flag.
> 
> Yes, but it's not CPU local. Taking the spinlock from another CPU's
> interrupt handler is perfectly safe, just not from the local CPU.
> If you use the spinlock as flag you would need to lock out everybody.

So every spinlock would have an array of chars sized to NR_CPUS and set 
the flag when the lock is taken?

