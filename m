Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZD3G7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZD3G7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbZD3G7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:59:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34170 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbZD3G7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:59:12 -0400
Date: Thu, 30 Apr 2009 08:58:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: powerpc: allow use of limited-function
	counters
Message-ID: <20090430065856.GA16737@elte.hu>
References: <18936.19035.163066.892208@cargo.ozlabs.ibm.com> <20090429130915.GA23563@elte.hu> <18936.56613.479043.380867@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18936.56613.479043.380867@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar wrote:
> 
> > [ Note, i saw some fuzz in those files. It applied fine but maybe 
> >   you have some local changes in them that are not in 
> >   tip:perfcounters/core yet? You might want to double check that. ]
> 
> I think it was just Robert Richter's changes that caused the fuzz. 
> The end result seems to be OK.

ah, indeed - the rename:

  4aeb0b4: perfcounters: rename struct hw_perf_counter_ops into struct pmu

changed context lines in your patch causing the fuzz. The mechanic 
rename changed quite a bit of stuff in the powerpc driver - we were 
lucky that your rather large patch still merged cleanly.

Btw, if in the future such renames cause problems for any pending 
patch of yours we can always pick up your patches first and then 
re-do the rename.

	Ingo
