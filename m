Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZHYGjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZHYGjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZHYGjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:39:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42916 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZHYGjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:39:08 -0400
Date: Tue, 25 Aug 2009 08:39:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Anirban Sinha <ASinha@zeugmasystems.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] : eliminate code duplication in kernel/tracepoint.c
Message-ID: <20090825063901.GB14286@elte.hu>
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA8FBB@exchange.ZeugmaSystems.local> <4A933C55.4090808@cn.fujitsu.com> <DDFD17CC94A9BD49A82147DDF7D545C501EA902E@exchange.ZeugmaSystems.local> <4A93760C.4020107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A93760C.4020107@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> 11:57, Anirban Sinha wrote:
> > OK, here's the modified patch:
> > 
> >>From 52cea59801ac5b772c49ae995f4df1940a0d88fa Mon Sep 17 00:00:00 2001
> > From: Anirban Sinha <asinha@zeugmasystems.com>
> > Date: Mon, 24 Aug 2009 20:52:35 -0700
> > Subject: cleanup: eliminate code duplication in kernel/tracepoint.c
> > 
> > 
> > Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
> > ---
> >  kernel/tracepoint.c |    4 ----
> >  1 files changed, 0 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > index 1ef5d3a..35eed9c 100644
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> > @@ -554,13 +554,9 @@ int tracepoint_module_notify(struct notifier_block
> > *self,
> >  
> >  	switch (val) {
> >  	case MODULE_STATE_COMING:
> > -		tracepoint_update_probe_range(mod->tracepoints,
> > -			mod->tracepoints + mod->num_tracepoints);
> > -		break;
> >  	case MODULE_STATE_GOING:
> >  		tracepoint_update_probe_range(mod->tracepoints,
> >  			mod->tracepoints + mod->num_tracepoints);
> > -		break;
> 
> I still think it's better not to remove this break. every "case" 
> should have a break or a return, expect for the falling throught 
> cases.

Correct. That might seem like a superfluous statement, but when we 
add new cases it stays robust while with the missing break one can 
create an unintended fall-through codepath.

	Ingo
