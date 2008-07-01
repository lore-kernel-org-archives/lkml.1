Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbYGAPDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbYGAPDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbYGAPDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:03:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49887 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756999AbYGAPDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:03:31 -0400
Date: Tue, 1 Jul 2008 17:03:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] percpu: Optimize percpu accesses
Message-ID: <20080701150313.GA30476@elte.hu>
References: <20080701121634.865966000@polaris-admin.engr.sgi.com> <20080701145417.GB18522@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701145417.GB18522@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > This patchset provides the following:
> > 
> >   * Cleanup: Fix early references to cpumask_of_cpu(0)
> >   * Generic: Percpu infrastructure to rebase the per cpu area to zero
> >   * x86_64: Fold pda into per cpu area
> >   * x86_64: Rebase per cpu variables to zero
> 
> thanks Mike - i've started testing it in -tip. One small merge fallout 
> fix is below. (it's for the new generic-ipi topic that was not in 
> tip/master yet when you merged percpu-zerobased to it)

ok, -tip testing found an early boot crash caused by your patchset, on 
64-bit x86:

[    0.396000] calling  net_ns_init+0x0/0x143
[    0.400000] net_namespace: 944 bytes
[    0.403578] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[    0.404000] IP: [<ffffffff80e05b0e>] net_ns_init+0x9f/0x143
[    0.404000] PGD 0
[    0.404000] Oops: 0000 [1] SMP
[    0.404000] CPU 0
[...]

full bootlog and config can be found at:

  http://redhat.com/~mingo/misc/crashlog-Tue_Jul__1_16_48_45_CEST_2008.bad
  http://redhat.com/~mingo/misc/config-Tue_Jul__1_16_48_45_CEST_2008.bad

(another 64-bit testbox crashed as well, so this should be readily 
reproducible.)

i've pushed this tree out to tip/tmp.core/percpu-zerobased.Jul__1_16_48 
topic branch, that is the 2.6.26-rc8-tip-00250-g90874b0 kernel you can 
see in the crashlog.

	Ingo
