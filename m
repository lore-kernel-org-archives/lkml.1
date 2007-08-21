Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbXHUXis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbXHUXis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbXHUXil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:38:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60365 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755215AbXHUXil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:38:41 -0400
Date: Tue, 21 Aug 2007 16:38:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070821232133.GB29691@Krystal>
Message-ID: <Pine.LNX.4.64.0708211635320.6062@schroedinger.engr.sgi.com>
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

> kmalloc(8)/kfree = 112 cycles
> kmalloc(16)/kfree = 103 cycles
> kmalloc(32)/kfree = 103 cycles
> kmalloc(64)/kfree = 103 cycles
> kmalloc(128)/kfree = 112 cycles
> kmalloc(256)/kfree = 111 cycles
> kmalloc(512)/kfree = 111 cycles
> kmalloc(1024)/kfree = 111 cycles
> kmalloc(2048)/kfree = 121 cycles

Looks good. This improves handling for short lived objects about 
threefold.

> kmalloc(4096)/kfree = 650 cycles
> kmalloc(8192)/kfree = 1042 cycles
> kmalloc(16384)/kfree = 1149 cycles

Hmmm... The page allocator is really bad here....

Could we use the cmpxchg_local approach for the per cpu queues in the 
page_allocator? May have an even greater influence on overall system 
performance than the SLUB changes.

