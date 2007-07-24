Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbXGXMXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbXGXMXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXGXMXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:23:14 -0400
Received: from ns1.suse.de ([195.135.220.2]:51396 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbXGXMXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:23:14 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.22.1-rt5
References: <20070724120436.GA14466@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Jul 2007 15:18:04 +0200
In-Reply-To: <20070724120436.GA14466@elte.hu>
Message-ID: <p73644aszxv.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>    
> more info about the -rt patchset can be found in the RT wiki:
>     
>   http://rt.wiki.kernel.org
>  
> to build a 2.6.22.1-rt5 tree, the following patches should be applied:
> 
>  http://kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.23-rc1.tar.bz2
>  http://redhat.com/~mingo/realtime-preempt/patch-2.6.23-rc1-rt0

This patch is needed to build on x86-64 with only the tracing options,
but no preempt enabled.

-Andi

Fix build in latency_hist.c

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.23-rc1-rt0/kernel/latency_hist.c
===================================================================
--- linux-2.6.23-rc1-rt0.orig/kernel/latency_hist.c
+++ linux-2.6.23-rc1-rt0/kernel/latency_hist.c
@@ -15,6 +15,7 @@
 #include <linux/percpu.h>
 #include <linux/latency_hist.h>
 #include <asm/atomic.h>
+#include <asm/div64.h>
 
 typedef struct hist_data_struct {
 	atomic_t hist_mode; /* 0 log, 1 don't log */
