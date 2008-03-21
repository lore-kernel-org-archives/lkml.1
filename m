Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYCULAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYCULAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYCULA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:00:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56659 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbYCULA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:00:27 -0400
Date: Fri, 21 Mar 2008 12:00:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2/2] vmallocinfo: Add caller information
Message-ID: <20080321110008.GW20420@elte.hu>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com> <20080319214227.GA4454@elte.hu> <Pine.LNX.4.64.0803191659410.4645@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803191659410.4645@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 19 Mar 2008, Ingo Molnar wrote:
> 
> > 
> > * Christoph Lameter <clameter@sgi.com> wrote:
> > 
> > > Add caller information so that /proc/vmallocinfo shows where the 
> > > allocation request for a slice of vmalloc memory originated.
> > 
> > please use one simple save_stack_trace() instead of polluting a dozen 
> > architectures with:
> 
> save_stack_trace() depends on CONFIG_STACKTRACE which is only 
> available when debugging is compiled it. I was more thinking about 
> this as a generally available feature.

then make STACKTRACE available generally via the patch below.

	Ingo

------------------------------------------->
Subject: debugging: always enable stacktrace
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Mar 21 11:48:32 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/Kconfig.debug |    1 -
 1 file changed, 1 deletion(-)

Index: linux-x86.q/lib/Kconfig.debug
===================================================================
--- linux-x86.q.orig/lib/Kconfig.debug
+++ linux-x86.q/lib/Kconfig.debug
@@ -387,7 +387,6 @@ config DEBUG_LOCKING_API_SELFTESTS
 
 config STACKTRACE
 	bool
-	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 
 config DEBUG_KOBJECT
