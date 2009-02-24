Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZBXVRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZBXVRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZBXVRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:17:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47318 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZBXVRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:17:23 -0500
Date: Tue, 24 Feb 2009 22:16:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk
	allocation
Message-ID: <20090224211659.GA3687@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224201718.GE28772@elte.hu> <20090224205105.GA19460@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090224205105.GA19460@elte.hu>
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


> > >   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git 
> > >   tj-percpu

ok, but these seem to be genuinely yours.

one build failure:

 arch/x86/kernel/setup_percpu.c: In function ‘setup_per_cpu_areas’:
 arch/x86/kernel/setup_percpu.c:442: error: ‘ptr’ undeclared (first use in this function)
 arch/x86/kernel/setup_percpu.c:442: error: (Each undeclared identifier is reported only once
 arch/x86/kernel/setup_percpu.c:442: error: for each function it appears in.)

one new warning:

 mm/percpu.c: In function ‘pcpu_map’:
 mm/percpu.c:604: warning: unused variable ‘last’

and one tip:master merge impact due to API change:

 kernel/trace/trace_functions_graph.c: In function ‘graph_trace_close’:
 kernel/trace/trace_functions_graph.c:836: error: implicit declaration of function ‘percpu_free’

that's free_percpu() now, right?

Btw., why was this rename done? We generally standardize on 
hierarchical names, going from the more general to the more 
specific names, left to right. So we have 
<subsystem>_<functionality>_<subtype> sort of names generally.

	Ingo
