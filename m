Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZF0Qiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZF0Qiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 12:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZF0Qin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 12:38:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36233 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbZF0Qim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 12:38:42 -0400
Date: Sat, 27 Jun 2009 18:38:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 -tip] perf_counter tools: Add support to set of
	multiple events in one shot
Message-ID: <20090627163821.GA17638@elte.hu>
References: <1246051852.2988.8.camel@hpdv5.satnam> <1246051927.2988.10.camel@hpdv5.satnam> <1246051996.2988.12.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246051996.2988.12.camel@hpdv5.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Add support for HARDWARE and SOFTWARE events :
>  perf stat -e all-sw-events
>  perf stat -e sw-events
>  perf stat -e all-hw-events
>  perf stat -e hw-events

> +static struct event_type_symbol event_type_symbols[] = {
> + [PERF_TYPE_HARDWARE]	= { "hw-events",	"all-hw-events",	},
> + [PERF_TYPE_SOFTWARE]	= { "sw-events",	"all-sw-events",	},

Hm, this really just special-cases and open-codes these. The better 
solution is what i suggested in my review of your prior patches: 
regex pattern matching.

	Ingo
