Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbZCMLEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbZCMLEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZCMLEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:04:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39918 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZCMLEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:04:21 -0400
Date: Fri, 13 Mar 2009 12:03:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 1/5] x86, bts: detect size of DS fields
Message-ID: <20090313110357.GC31094@elte.hu>
References: <20090313104218.A30096@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313104218.A30096@sedona.ch.intel.com>
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


Applied your patches to tip:tracing/hw-branch-tracer, thanks 
Markus!

I did a small cleanup patch - see it in this thread.

One detail i noticed:

static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);

That PER_CPU indirection should be removed - it's enough to have 
system-wide configuration settings. We dont generally support 
assymetric CPU capabilities in the same system, and the per_cpu 
indirection here slows the code down and obfuscates it.

Thanks,

	Ingo
