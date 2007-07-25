Return-Path: <linux-kernel-owner+w=401wt.eu-S935597AbXGYTTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935597AbXGYTTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbXGYTTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:19:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54735 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760118AbXGYTS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:18:59 -0400
Date: Wed, 25 Jul 2007 21:18:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <20070725191848.GB4463@elte.hu>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu> <1185387605.14095.16.camel@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185387605.14095.16.camel@tongli.jf.intel.com>
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


* Li, Tong N <tong.n.li@intel.com> wrote:

> The problem I see is that the current load balancing code is quite 
> hueristic and can be quite inaccurate sometimes. Its goal is to 
> maintain roughly equal load on each core, where load is defined to be 
> the sum of the weights of all tasks on a core. If all tasks have the 
> same weight, this is a simple problem. If different weights exist, 
> this is an NP-hard problem and our current hueristic can perform badly 
> under various workloads. A simple example, if we have four tasks on 
> two cores and they have weights 1, 5, 7, 7. The balanced partition 
> would have 1 and 7 on core 1 and 5 and 7 on core 2. But you can see 
> the load isn't evenly distributed; in fact, it's not possible to 
> evenly distribute the load in this case. Thus, my opinion is that only 
> balancing the load as we do now is not enough to achieve SMP fairness. 
> My patch was intended to address this problem.

could you please try my patch nevertheless and see how much it differs 
in practice from your solution, and cite specific examples and 
measurements? (please measure over longer periods of time such as 120 
seconds or 300 seconds - so that slow-rate balancing has its chance to 
work)

	Ingo
