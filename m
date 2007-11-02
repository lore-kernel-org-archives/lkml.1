Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXKBK3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXKBK3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 06:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbXKBK24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 06:28:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58412 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXKBK2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 06:28:55 -0400
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
	access overhead
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: clameter@sgi.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
In-Reply-To: <20071101.155805.65012933.davem@davemloft.net>
References: <Pine.LNX.4.64.0711011511450.22508@schroedinger.engr.sgi.com>
	 <20071101.153824.91808126.davem@davemloft.net>
	 <Pine.LNX.4.64.0711011545370.23379@schroedinger.engr.sgi.com>
	 <20071101.155805.65012933.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 11:28:46 +0100
Message-Id: <1193999326.27652.348.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 15:58 -0700, David Miller wrote:

> Since you're the one who wants to change the semantics and guarentees
> of this interface, perhaps it might help if you did some greps around
> the tree to see how alloc_percpu() is actually used.  That's what
> I did when I started running into trouble with your patches.

This fancy new BDI stuff also lives off percpu_counter/alloc_percpu().

That means that for example each NFS mount also consumes a number of
words - not quite sure from the top of my head how many, might be in the
order of 24 bytes or something.

I once before started looking at this, because the current
alloc_percpu() can have some false sharing - not that I have machines
that are overly bothered by that. I like the idea of a strict percpu
region, however do be aware of the users.


