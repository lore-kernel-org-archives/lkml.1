Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbXHUXfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbXHUXfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbXHUXfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:35:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60238 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755244AbXHUXfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:35:31 -0400
Date: Tue, 21 Aug 2007 16:35:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070821232133.GB29691@Krystal>
Message-ID: <Pine.LNX.4.64.0708211630240.6062@schroedinger.engr.sgi.com>
References: <20070820201822.597720007@polymtl.ca>
 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
 <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
 <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
 <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal> <20070821174424.GB8360@Krystal>
 <20070821232133.GB29691@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:

> * cmpxchg_local Slub test
> kmalloc(8) = 83 cycles	    kfree = 363 cycles
> kmalloc(16) = 85 cycles	    kfree = 372 cycles
> kmalloc(32) = 92 cycles	    kfree = 377 cycles
> kmalloc(64) = 115 cycles	  kfree = 397 cycles
> kmalloc(128) = 179 cycles	  kfree = 438 cycles

So for consecutive allocs of small slabs up to 128 bytes this effectively 
doubles the speed of kmalloc.

> kmalloc(256) = 314 cycles	  kfree = 564 cycles
> kmalloc(512) = 398 cycles	  kfree = 615 cycles
> kmalloc(1024) = 573 cycles	kfree = 745 cycles

Less of a benefit.

> kmalloc(2048) = 629 cycles	kfree = 816 cycles

Allmost as before.

> kmalloc(4096) = 473 cycles	kfree = 548 cycles
> kmalloc(8192) = 659 cycles	kfree = 745 cycles
> kmalloc(16384) = 724 cycles	kfree = 843 cycles

Page allocator pass through measurements.
