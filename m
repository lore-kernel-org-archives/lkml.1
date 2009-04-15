Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZDOQWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZDOQWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZDOQV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:21:57 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:42616 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbZDOQV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:21:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AgHdZH65eafZdLZX74RTBVLHAtddeO6YfxwzIEImrHlRYukvjhpd8xR/sKaFQut2Dz
         fGBxvaCGLnm7tnBOECag6JMfbG+XU7iTRZSFLAfMICqHo/uTvVpHVu5olPQ3fvfu8Gow
         4NiANuUk2EnW4W6n4moGeGb8Y1UMWxOrKRkI4=
Date: Wed, 15 Apr 2009 18:21:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] tracing/filters: allow on-the-fly filter switching
Message-ID: <20090415162151.GH5989@nowhere>
References: <1239610670.6660.49.camel@tropicana> <20090414205635.GA5968@nowhere> <1239769945.7852.21.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239769945.7852.21.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 11:32:25PM -0500, Tom Zanussi wrote:
> On Tue, 2009-04-14 at 22:56 +0200, Frederic Weisbecker wrote:
> > On Mon, Apr 13, 2009 at 03:17:50AM -0500, Tom Zanussi wrote:
> 
> [...]
> 
> > 
> > 
> > BTW, this issue might be already present before this patch.
> > What happens if:
> > 
> > 
> > 	T1				T2
> > 
> > event_filter_read() {
> >   filter_print_preds() {
> >     for (i = 0; i < n_preds; i++) {
> > 	pred = preds[i];
> > 				    event_filter_write() {
> > 					filter_disable_preds();
> > 					filter_clear_preds() {
> > 					  kfree(pred->field_name);
> > 	field_name = pred->field_name;
> > 	// CRASH!!!
> > 
> > 
> > You need a mutex to protect these two callbacks.
> > It would also protect concurrent calls to event_filter_write(),
> > which would result in random.
> > 
> 
> Yeah, Li Zefan had already fixed this, but it wasn't included in this
> patch.  Looks like he'll be resubmitting that part...
> 
> > 
> > 
> 
> [...]
> 
> > Also, is filter_add_pred() supposed to be available for in-kernel
> > uses by other tracers or something?
> 
> No, the current callers were the only ones I'd planned on (it's not
> static because code in trace_events.c needs to call it).  But, do you
> see a use for it by other tracers?



May be in the future, it's possible that a tracer might want to
set filters by itself.
But I don't think it has to be fixed now because there are nothing
like that for now.

So, no problem :-)

Frederic.

 
> > If this is planned, the locking could be even deeper than my comments.
> > 
> > Other than these comments:
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > Thanks!
> > 
> 
> Thanks for reviewing it!
> 
> Tom
> 

