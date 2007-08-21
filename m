Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbXHUVgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbXHUVgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXHUVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:36:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53722 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440AbXHUVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:36:33 -0400
Date: Tue, 21 Aug 2007 14:36:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070821204145.GA23795@Krystal>
Message-ID: <Pine.LNX.4.64.0708211435100.3390@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca>
 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
 <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
 <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
 <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal> <20070821204145.GA23795@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:

> Therefore, in the test where we have separate passes for slub allocation
> and free, we hit mostly the slow path. Any particular reason for that ?

Maybe on SMP you are schedule to run on a different processor? Note that 
I ran my tests at early boot where such effects do not occur.
 
> Note that the alloc/free test (test 2) seems to hit the fast path as
> expected.

It is much more likely in that case that the execution thread stays on one 
processor.
