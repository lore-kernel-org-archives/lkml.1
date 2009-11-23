Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbZKWVZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbZKWVZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZKWVZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:25:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34183 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbZKWVZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:25:07 -0500
Date: Mon, 23 Nov 2009 22:25:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/4] perf tools: Add support for breakpoint events in
 perf tools
Message-ID: <20091123212501.GA18917@elte.hu>
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
 <1258987355-8751-4-git-send-email-fweisbec@gmail.com>
 <20091123173601.GA7273@in.ibm.com>
 <20091123202525.GA4979@nowhere>
 <20091123210939.GD15547@ghostprotocols.net>
 <20091123211945.GC4979@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123211945.GC4979@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > Using just /proc/kallsyms all we can do is find the size of a 
> > variable by looking at its address and the address of the next one.
> > 
> > - Arnaldo
> 
> Hmm, but I worry a bit about alignment which would return us the wrong 
> size.
> 
> May be can we first try to get the address from /proc/kallsyms, and if 
> we have dwarf, get the size from it, otherwise try some magic with 
> /proc/kallsysms...

Can we extend /proc/kallsyms (or add /proc/kallsyms) to include a size 
field?

Perhaps can we generate some sort of DSO-alike thing in /proc/vmlinux 
(via a default-off debug option in .config), that perf could just 
interpret the usual ELF way - which happens to be the symbol table of 
the kernel? It would use up some RAM, but it would also be quite useful 
for debugging purposes.

	Ingo
