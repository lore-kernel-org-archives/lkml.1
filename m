Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbYAHLeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbYAHLeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYAHLdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:33:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55994 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYAHLdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:33:53 -0500
Date: Tue, 8 Jan 2008 12:33:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Message-ID: <20080108113323.GB11083@elte.hu>
References: <20080108063113.GA21287@fattire.cabal.ca> <20080108091742.GD27671@elte.hu> <200801082228.05218.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801082228.05218.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> +/* FIXME: Risky: returns a pointer into a module w/o lock */

stupid question: since module unloads are so rare, why isnt this via the 
same mechanism that CPU hotplug uses to securely unregister CPUs? I.e. 
quiet all CPUs, disable irqs on all of them, then unlink the module. 
This would make module unload fundamentally safe, and symbols could be 
looked up lockless. (with the exception of crashing within NMIs, but 
that is not lock safe anyway.)

Or is this a rathole for some reason?

	Ingo
