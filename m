Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbYEGTLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbYEGTLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbYEGTK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:10:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850AbYEGTKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:10:20 -0400
Date: Wed, 7 May 2008 21:09:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507190956.GA16412@elte.hu>
References: <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu> <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org> <20080507174900.GB13591@elte.hu> <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org> <20080507181714.GA14980@elte.hu> <alpine.LFD.1.10.0805071125090.3024@woody.linux-foundation.org> <20080507184304.GA15554@elte.hu> <alpine.LFD.1.10.0805071150140.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071150140.3024@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In contrast, these "try to emulate bad behavior with the old known-ok 
> semaphores" don't show anything AT ALL. We already know it's related 
> to semaphores. And your patches aren't even guaranteed to show the 
> same issue.

yeah, i was just trying to come up with patches to probe which one of 
the following two possibilities is actually the case:

 - if the regression is due to the difference in scheduling behavior of 
   new semaphores (different wakeup patterns, etc.), that's fixable in 
   the new semaphore code => then the BKL code need not change.

 - if the regression is due due to difference in the fastpath cost, then 
   the new semaphores can probably not be improved (much of their appeal 
   comes from them not being complex and not being in assembly) => then 
   the BKL code needs to change to become cheaper [i.e. then we want 
   your patch].

	Ingo
