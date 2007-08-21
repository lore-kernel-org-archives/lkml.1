Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbXHUXO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbXHUXO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXHUXOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:14:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59702 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751630AbXHUXOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:14:20 -0400
Date: Tue, 21 Aug 2007 16:14:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070821173849.GA8360@Krystal>
Message-ID: <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca>
 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
 <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
 <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
 <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:

> - Changed smp_rmb() for barrier(). We are not interested in read order
>   across cpus, what we want is to be ordered wrt local interrupts only.
>   barrier() is much cheaper than a rmb().

But this means a preempt disable is required. RT users do not want that.
Without preemption the processor can be moved after c has been determined.
That is why the smp_rmb() is there.
