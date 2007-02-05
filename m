Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbXBENtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbXBENtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXBENtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:49:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47431 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522AbXBENtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:49:08 -0500
Date: Mon, 5 Feb 2007 14:47:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.20-rt1, yum/rpm
Message-ID: <20070205134708.GA6318@elte.hu>
References: <20070205065636.GA1652@elte.hu> <6bffcb0e0702050459y692359ai67cbd4f93e11d06e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0702050459y692359ai67cbd4f93e11d06e@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4375]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> It looks like a bug to me
> 
> BUG: MAX_LOCKDEP_ENTRIES too low!
> turning off the locking correctness validator.

hm, the patch below should solve this.

	Ingo

Index: linux/kernel/lockdep_internals.h
===================================================================
--- linux.orig/kernel/lockdep_internals.h
+++ linux/kernel/lockdep_internals.h
@@ -15,7 +15,7 @@
  * table (if it's not there yet), and we check it for lock order
  * conflicts and deadlocks.
  */
-#define MAX_LOCKDEP_ENTRIES	8192UL
+#define MAX_LOCKDEP_ENTRIES	16384UL
 
 #define MAX_LOCKDEP_KEYS_BITS	11
 #define MAX_LOCKDEP_KEYS	(1UL << MAX_LOCKDEP_KEYS_BITS)

