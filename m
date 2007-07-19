Return-Path: <linux-kernel-owner+w=401wt.eu-S937288AbXGSIo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937288AbXGSIo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762191AbXGSIor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:44:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34828 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761878AbXGSIoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:44:46 -0400
Date: Thu, 19 Jul 2007 10:44:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/sched.c: remove 2 unused exports
Message-ID: <20070719084439.GA22825@elte.hu>
References: <20070712235211.GS3492@stusta.de> <20070717192233.GG26283@elte.hu> <20070719061051.GO3801@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719061051.GO3801@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@stusta.de> wrote:

> On Tue, Jul 17, 2007 at 09:22:33PM +0200, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > This patch removes the following unused exports:
> > > - EXPORT_SYMBOL(cond_resched_softirq);
> > > - EXPORT_SYMBOL_GPL(__wake_up_sync);
> > 
> > these are there for API completeness - their counterparts are exported.
> 
> Why is something with a comment "For internal use only" part of the 
> API?

yeah, you are right about __wake_up_sync. We'll likely remove sync 
wakeups anyway, and the export is GPL, so it's not a big issue.

The point remains for cond_resched_softirq() though - it's a symmetric 
export to cond_resched()'s export. (I think you should smarten your 
scripts about such 'API family' exports, to avoid false positives.)

	Ingo
