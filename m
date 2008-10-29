Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYJ2IfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYJ2IfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 04:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYJ2Iew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 04:34:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40987 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYJ2Iev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 04:34:51 -0400
Date: Wed, 29 Oct 2008 09:34:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
Message-ID: <20081029083434.GC6364@elte.hu>
References: <1225268796.24095.48.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225268796.24095.48.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> Fix a race condition accessing oops_in_progress.  Which may be 
> changed on multiple CPU simultaneously, but it is changed via 
> non-atomic operation ++/--.  This patch changes the definition of 
> oops_in_process from int to atomic_t, and accessing method to atomic 
> operations.
> 
> 
> ChangeLog
> 
> v2:
> 
> - Includes fixes from Andrew Moton.
> 
> - Re-based on Matthew Wilcox's new atomic_t patch.

hm, there are a couple of places now that do atomic_set(,1) - they 
should be atomic_inc(), correct?

	Ingo
