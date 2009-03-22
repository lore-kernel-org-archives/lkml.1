Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZCVTu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZCVTu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZCVTur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:50:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbZCVTuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:50:46 -0400
Date: Sun, 22 Mar 2009 20:50:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] tracing: add per-subsystem filtering
Message-ID: <20090322195033.GA15002@elte.hu>
References: <1237710677.7703.49.camel@charm-linux> <20090322190158.GF6002@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322190158.GF6002@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > +int filter_add_subsystem_pred(struct event_subsystem *system,
> > +			      struct filter_pred *pred)
> > +{
> > +	struct ftrace_event_call *call = __start_ftrace_events;
> > +	struct filter_pred *event_pred;
> > +	int i;
> > +
> > +	if (system->preds && !pred->compound)
> > +		filter_free_subsystem_preds(system);
> > +
> > +	if (!system->preds) {
> > +		system->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
> > +					GFP_KERNEL);
> > +		if (!system->preds)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	for (i = 0; i < MAX_FILTER_PRED; i++) {
> > +		if (!system->preds[i]) {
> > +			system->preds[i] = pred;
> > +			break;
> > +		}
> > +		if (i == MAX_FILTER_PRED - 1)
> > +			return -EINVAL;
> 
> 
> Shouldn't it be i == MAX_FILTER_PRED ?

Here we search for a free slot in the array of sub-expressions of 
the subsystem level filters. That condition cannot even be true 
inside a 'i < MAX_FILTER_PRED' loop.

Checking for i==MAX would be fine if done outside of the loop - and 
should probably be done that way. But the code is correct this way 
too i think.

	Ingo
