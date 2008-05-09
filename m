Return-Path: <linux-kernel-owner+w=401wt.eu-S1765358AbYEIQ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765358AbYEIQ2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbYEIQ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:28:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40862 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756913AbYEIQ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:28:15 -0400
Date: Fri, 9 May 2008 09:28:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
In-Reply-To: <20080509102607.GF19617@elte.hu>
Message-ID: <Pine.LNX.4.64.0805090926260.18195@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
 <20080507073017.GJ32195@elte.hu> <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
 <20080509102607.GF19617@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Ingo Molnar wrote:

> hm, there was some lockdep complication in this area. I guess we could 
> use the 'nice' variants too if their irq-enabling/disabling was properly 
> lockdep annotated and tracked by the irqflags machinery?

I thought that we already fall back to the functions that spin while 
having interrupts disabled if lockdep is on?

One issue: The BREAKLOCK value needs to be 1 in the fallback case 
otherwise we needlessly run atomic ops.

---
 kernel/spinlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/spinlock.c
===================================================================
--- linux-2.6.orig/kernel/spinlock.c	2008-05-07 16:00:06.000000000 -0700
+++ linux-2.6/kernel/spinlock.c	2008-05-07 16:00:29.000000000 -0700
@@ -218,7 +218,7 @@ do {									\
 
 #else
 
-#define BREAKLOCK(lock)	0
+#define BREAKLOCK(lock)	1
 #define BREAKLOCK_ENABLE(lock)	do { } while (0)
 #define BREAKLOCK_DISABLE(lock) do { } while (0)
 
