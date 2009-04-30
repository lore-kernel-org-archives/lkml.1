Return-Path: <linux-kernel-owner+w=401wt.eu-S1764387AbZD3QEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764387AbZD3QEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764076AbZD3QDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:03:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762277AbZD3QDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:03:43 -0400
Date: Thu, 30 Apr 2009 18:00:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>, Eric Dumazet <dada1@cosmosbay.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430160054.GB4723@elte.hu>
References: <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu> <alpine.DEB.1.10.0904300938220.22262@qirst.com> <20090430141446.GD14696@elte.hu> <alpine.DEB.1.10.0904301013110.14178@qirst.com> <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com> <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904301114440.4028@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> http://article.gmane.org/gmane.linux.kernel.cross-arch/1128
> http://article.gmane.org/gmane.linux.kernel.cross-arch/1132
> http://article.gmane.org/gmane.linux.kernel.cross-arch/1134
> http://article.gmane.org/gmane.linux.kernel.cross-arch/1138
> http://article.gmane.org/gmane.linux.kernel.cross-arch/1139
> http://article.gmane.org/gmane.linux.kernel.cross-arch/1145 VM stats
> http://article.gmane.org/gmane.linux.kernel.cross-arch/1160 NFS stats
> http://article.gmane.org/gmane.linux.kernel.cross-arch/1161 Genhd stats
> http://article.gmane.org/gmane.linux.kernel.cross-arch/1164 SRCU

The new percpu APIs could be used in most of these places already, 
straight away. This is a really good TODO list for places to 
enhance.

Then a second set of patches could convert percpu_add() / etc. uses 
to __percpu_add() ... but that should be done by those architectures 
that need it (and to the extent they need it), because it's not 
really testable on x86.

I dont really like the PER_CPU / CPU_INC etc. type of all-capitals 
APIs you introduced in the patches above:


+		__CPU_INC(bt->sequence);
+	CPU_FREE(bt->sequence);

was there any strong reason to go outside the well-established 
percpu_* name space and call these primitives as if they were 
macros?

	Ingo
