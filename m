Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbXHVAe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbXHVAe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXHVAer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:34:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35841 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754568AbXHVAek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:34:40 -0400
Date: Tue, 21 Aug 2007 17:34:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070822002616.GA1400@Krystal>
Message-ID: <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com>
References: <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com>
 <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com>
 <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
 <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
 <20070822000323.GG29691@Krystal> <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com>
 <20070822002616.GA1400@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:

> As I am going back through the initial cmpxchg_local implementation, it
> seems like it was executing __slab_alloc() with preemption disabled,
> which is wrong. new_slab() is not designed for that.

The version I send you did not use preemption.

We need to make a decision if we want to go without preemption and cmpxchg 
or with preemption and cmpxchg_local.

If we really want to do this then the implementation of all of these 
components need to result in competitive performance on all platforms.



