Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZDXGuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZDXGuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZDXGuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:50:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46159 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZDXGuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:50:03 -0400
Date: Fri, 24 Apr 2009 08:49:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [BUG] 2.6.29.1 debugobjects warning
Message-ID: <20090424064937.GD21739@elte.hu>
References: <20090423140002.GA12852@Krystal> <20090423164638.3b5769c6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423164638.3b5769c6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 23 Apr 2009 10:00:02 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > ODEBUG: init active object type: timer_list

> It seems to be complaining that cpufreq_governor_dbs() is running 
> init_timer() against a timer which has already been initialised 
> once.

Not just already initialized - but also active. There's these states 
for an object:

        ODEBUG_STATE_NONE,
        ODEBUG_STATE_INIT,
        ODEBUG_STATE_INACTIVE,
        ODEBUG_STATE_ACTIVE,
        ODEBUG_STATE_DESTROYED,

So the 'init active object type' warning above suggests that an 
init_timer() has been done on an already running timer. If true then 
that is a bad bug - can corrupt timer state, etc.

Thomas, do you agree?

	Ingo
