Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbXH0Tjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbXH0Tjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbXH0Tjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:39:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34564 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756455AbXH0Tjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:39:37 -0400
Date: Mon, 27 Aug 2007 12:39:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <1188197539.6114.426.camel@twins>
Message-ID: <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca>  <20070820201822.597720007@polymtl.ca>
  <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> 
 <20070820204126.GA22507@Krystal>  <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
  <20070820212922.GA27011@Krystal>  <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
  <20070820215413.GA28452@Krystal>  <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
  <20070821173849.GA8360@Krystal>  <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
 <1188197539.6114.426.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Peter Zijlstra wrote:

> So, if the fast path can be done with a preempt off, it might be doable
> to suffer the slow path with a per cpu lock like that.

Sadly the cmpxchg_local requires local per cpu data access. Isnt there 
some way to make this less expensive on RT? Acessing cpu local memory is 
really good for performance on NUMA since the data is optimally placed and 
one can avoid/reduce locking if the process stays tied to the processor.

