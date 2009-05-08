Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbZEHLs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbZEHLs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbZEHLsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:48:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53386 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbZEHLsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:48:17 -0400
Date: Fri, 8 May 2009 13:47:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH 4/8] proc: export more page flags in /proc/kpageflags
Message-ID: <20090508114742.GB17129@elte.hu>
References: <20090508105320.316173813@intel.com> <20090508111031.020574236@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508111031.020574236@intel.com>
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


* Wu Fengguang <fengguang.wu@intel.com> wrote:

> Export all page flags faithfully in /proc/kpageflags.

Ongoing objection and NAK against extended haphazard exporting of 
kernel internals via an ad-hoc ABI via ad-hoc, privatized 
instrumentation that only helps the MM code and nothing else. It was 
a mistake to introduce the /proc/kpageflags hack a year ago, and it 
even more wrong today to expand on it.

/proc/kpageflags should be done via the proper methods outlined in 
the previous mails i wrote on this topic: for example by using the 
'object collections' abstraction i suggested. Clean enumeration of 
all pages (files, tasks, etc.) and the definition of histograms over 
it via free-form filter expressions is the right way to do this. It 
would not only help other subsystems, it would also be far more 
capable.

So this should be done in cooperation with instrumentation folks, 
while improving _all_ of Linux instrumentation in general. Or, if 
you dont have the time/interest to work with us on that, it should 
not be done at all. Not having the resources/interest to do 
something properly is not a license to introduce further 
instrumentation crap into Linux.

	Ingo
