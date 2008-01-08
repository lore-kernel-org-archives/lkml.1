Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYAHJSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYAHJSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYAHJSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:18:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbYAHJSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:18:09 -0500
Date: Tue, 8 Jan 2008 10:17:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Message-ID: <20080108091742.GD27671@elte.hu>
References: <20080108063113.GA21287@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108063113.GA21287@fattire.cabal.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


(Rusty Cc:-ed)

* Kyle McMartin <kyle@mcmartin.ca> wrote:

> handle_sysrq can be called from interrupt context. 
> sysrq_timer_list_show eventually starts poking at module symbols which 
> take the module mutex.
> 
> so instead, let's just kick off a workqueue.
> 
> [ doesn't happen on my laptop with the keyboard, but does when
>   triggered from /proc/sysrq-trigger ]

hmmm. This really shouldnt be happening - how come we hit the module 
mutex on simple things like symbol lookups?

	Ingo
