Return-Path: <linux-kernel-owner+w=401wt.eu-S965564AbXCLLNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbXCLLNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965587AbXCLLNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:13:16 -0400
Received: from www.osadl.org ([213.239.205.134]:58590 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965564AbXCLLNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:13:15 -0400
Subject: Re: [patch] change futex_wait() to hrtimers
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       drepper@redhat.com, oleg@tv-sign.ru, sebastien.dugue@bull.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070312110204.GD2231@elte.hu>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net>
	 <20070312011259.3834A1801C4@magilla.sf.frob.com>
	 <20070312091006.GF21024@elte.hu> <20070312091628.GE28546@wotan.suse.de>
	 <20070312110204.GD2231@elte.hu>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 12:19:45 +0100
Message-Id: <1173698386.13341.87.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 12:02 +0100, Ingo Molnar wrote:
> > Well I did convert futex_wait to an absolute timeout based version in 
> > the subsequent incremental patch. I think that is OK?
> 
> it still has the rounding artifacts: using timer_list there is no way to 
> do a precise long sleep based on many small sleeps.
> 
> even if this means more work for you (i'm sorry about that!) i'm quite 
> sure we should take Sebastien's hrtimers based implementation of 
> futex_wait(), and use the nanosleep method to restart it. There's no 
> point in further tweaking the imprecise approach: whenever some timeout 
> needs to be restarted, it's a candidate for hrtimers.
> 
> until then, glibc already handles timeouts and restarts it manually.

This also allows us to add a seperate absolute time bases futex op,
which allows to remove the conversion of abstime to reltime in glibc.

	tglx


