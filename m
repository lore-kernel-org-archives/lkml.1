Return-Path: <linux-kernel-owner+w=401wt.eu-S1751614AbZEIF75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbZEIF75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 01:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZEIF7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 01:59:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZEIF7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 01:59:47 -0400
Date: Sat, 9 May 2009 07:59:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/8] proc: export more page flags in /proc/kpageflags
Message-ID: <20090509055914.GA21354@elte.hu>
References: <20090508105320.316173813@intel.com> <20090508111031.020574236@intel.com> <20090508114742.GB17129@elte.hu> <20090508124433.GB15949@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508124433.GB15949@localhost>
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

> > /proc/kpageflags should be done via the proper methods outlined 
> > in the previous mails i wrote on this topic: for example by 
> > using the 'object collections' abstraction i suggested. Clean 
> > enumeration of all pages (files, tasks, etc.) and the definition 
> > of histograms over it via free-form filter expressions is the 
> > right way to do this. It would not only help other subsystems, 
> > it would also be far more capable.
> 
> For the new interfaces(files etc.) I'd very like to use the ftrace 
> interface. For the existing pagemap interfaces, if they can 
> fulfill their targeted tasks, why bother making the shift?

Because they were a mistake to be merged? Because having them 
fragments and thus weakens Linux instrumentation in general? 
Because, somewhat hipocritically, other MM instrumentation patches 
are being rejected under the pretense that they "do not matter" - 
while instrumentation that provably _does_ matter (yours) is added 
outside the existing instrumentation frameworks?

> When the pagemap interfaces cannot satisfy some new applications, 
> and ftrace can provide a superset of the pagemap interfaces and 
> shows clear advantages while meeting the new demands, then we can 
> schedule tearing down of the old interface?

Yes. But meanwhile dont extend it ... otherwise this bad cycle will 
never end. "Oh, we just added this to /proc/kpageflags too, why 
should we go through the trouble of use the generic framework?"

Do you see my position?

	Ingo
