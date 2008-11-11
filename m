Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYKKKgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYKKKgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYKKKf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:35:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34851 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbYKKKfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:35:55 -0500
Date: Tue, 11 Nov 2008 11:35:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>, Frank Mayhar <fmayhar@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, adobriyan@gmail.com,
       Doug Chapman <doug.chapman@hp.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] for account_group_exec_runtime(), make sure ->signal
	can't be freed under rq->lock
Message-ID: <20081111103532.GA8869@elte.hu>
References: <20081110143930.GA28275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110143930.GA28275@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> The patch is ugly, but I don't see the better fix for now. Needs the 
> review from Peter/Ingo.

this is indeed too ugly, and if we do it we'll get both this ugliness 
and the CPU loop upstream forever. Frank, if you dont have time to fix 
this code, then i guess the best thing is to do the full revert that 
Peter sent.

Regarding this teardown bug. Stupid question: why cannot the signal 
structure live as long as the last user is around? It's a tiny amount 
of RAM.

	Ingo
