Return-Path: <linux-kernel-owner+w=401wt.eu-S1762720AbXH0VES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762720AbXH0VES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760205AbXH0VEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:04:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41143 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758956AbXH0VEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:04:08 -0400
Date: Mon, 27 Aug 2007 14:04:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070827203913.GA7416@Krystal>
Message-ID: <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com>
References: <20070820212922.GA27011@Krystal>
 <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
 <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
 <1188197539.6114.426.camel@twins> <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
 <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com>
 <20070827203913.GA7416@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think the simplest solution may be to leave slub as done in the patch 
that we developed last week. The arch must provide a cmpxchg_local that is 
performance wise the fastest possible. On x86 this is going to be the 
cmpxchg_local on others where cmpxchg is slower than interrupt 
disable/enable this is going to be the emulation that does

interrupt disable

cmpchg simulation

interrupt enable


If we can establish that this is not a performance regression then we have 
a clean solution source code wise. It also minimizes the interrupt holdoff 
for the non-cmpxchg_local arches. However, it means that we will have to 
disable interrupts twice for the slow path. If that is too expensive then 
we need a different solution.


