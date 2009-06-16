Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbZFPKAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbZFPKAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZFPKAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:00:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45506 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZFPKAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:00:21 -0400
Date: Tue, 16 Jun 2009 12:00:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616100015.GD6432@elte.hu>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com> <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk> <20090616085028.GA13771@elte.hu> <20090616095706.36f01282@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616095706.36f01282@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


got the debug data off-list (it's large):

 lock-classes:                         1763 [max: 8191]
 direct dependencies:                  9104 [max: 16384]
 indirect dependencies:              129622
 all direct dependencies:           1129624
 dependency chains:                    9781 [max: 32768]
 dependency chain hlocks:             27553 [max: 163840]
 in-hardirq chains:                    1573
 in-softirq chains:                     131
 in-process chains:                    8077
 stack-trace entries:                262144 [max: 262144]

stack-trace entries ran out. And it seems like you didnt quadruple 
MAX_STACK_TRACE_ENTRIES to 1 million entries.

Do we run out of entries right during bootup? Are you 
loading/unloading modules a lot perhaps? Could you send your .config 
please? (assuming a plain bootup triggers it - that should make it 
reproducible to me too)

Thanks,

	Ingo
