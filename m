Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZCVTym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZCVTym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZCVTyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:54:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:9494 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZCVTyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bpFmu7E4u+FVa5lOcWO9mfSIYvmRhpTEf6WfkTFuXGGghmdGN/fkvDq6zLJum7MYyv
         obZFnNhitilrrNOz4RVQ8hf/Gi2L9oxSX5UFbBwxP3xEif0QpX3z52FdxSSLWFiNEeSU
         8Sq1wOlNGh9qhUvuu2OdY6c4Vcg1VrFyYGIpE=
Date: Sun, 22 Mar 2009 20:54:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] tracing: add per-subsystem filtering
Message-ID: <20090322195424.GG6002@nowhere>
References: <1237710677.7703.49.camel@charm-linux> <20090322190158.GF6002@nowhere> <20090322195033.GA15002@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322195033.GA15002@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 08:50:33PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > +int filter_add_subsystem_pred(struct event_subsystem *system,
> > > +			      struct filter_pred *pred)
> > > +{
> > > +	struct ftrace_event_call *call = __start_ftrace_events;
> > > +	struct filter_pred *event_pred;
> > > +	int i;
> > > +
> > > +	if (system->preds && !pred->compound)
> > > +		filter_free_subsystem_preds(system);
> > > +
> > > +	if (!system->preds) {
> > > +		system->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
> > > +					GFP_KERNEL);
> > > +		if (!system->preds)
> > > +			return -ENOMEM;
> > > +	}
> > > +
> > > +	for (i = 0; i < MAX_FILTER_PRED; i++) {
> > > +		if (!system->preds[i]) {
> > > +			system->preds[i] = pred;
> > > +			break;
> > > +		}
> > > +		if (i == MAX_FILTER_PRED - 1)
> > > +			return -EINVAL;
> > 
> > 
> > Shouldn't it be i == MAX_FILTER_PRED ?
> 
> Here we search for a free slot in the array of sub-expressions of 
> the subsystem level filters. That condition cannot even be true 
> inside a 'i < MAX_FILTER_PRED' loop.


Darn, I should sleep more!

 
> Checking for i==MAX would be fine if done outside of the loop - and 
> should probably be done that way. But the code is correct this way 
> too i think.
> 


Yes, at least it's harmless.

