Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbXGaJZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbXGaJZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbXGaJZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:25:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbXGaJZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:25:31 -0400
Date: Tue, 31 Jul 2007 11:25:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] RT: Preemptible Function-Call-IPI Support
Message-ID: <20070731092521.GA16177@elte.hu>
References: <20070730211350.5162.99143.stgit@novell1.haskins.net> <20070730211539.5162.87483.stgit@novell1.haskins.net> <20070731091903.GA15822@elte.hu> <20070731092119.GA15968@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731092119.GA15968@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Gregory Haskins <ghaskins@novell.com> wrote:
>  
> > This code allows FUNCTION_CALL IPIs to become preemptible by 
> > executing them in kthread context instead of interrupt context.  
> > They are referred to as "Virtual Function Call IPIs" (VFCIPI) 
> > because we no longer rely on the actual FCIPI facility.  Instead we 
> > schedule a thread to run.  This essentially replaces the synchronous 
> > FCIPI with an async RESCHEDULE IPI.
> 
> why do we need this? It's quite complex and brings little extra 
> AFAICS. See the "schedule_on_each_cpu-enhance.patch" from Peter 
> Ziljstra that lets a function to be executed on all CPUs. That should 
> be extended (trivially) to execute a function on another CPU. That's 
> all we need.

as far as the prioritization of function calls goes, _that_ makes sense, 
but it should not be a separate API but should be done to our normal 
workqueue APIs. That not only extends the effects of priorities to all 
current workqueue using kernel subsystems, but also keeps the API more 
unified. We really dont want to have too many -rt specific APIs.

	Ingo
