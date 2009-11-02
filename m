Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZKBNBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZKBNBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZKBNBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:01:49 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:42021 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbZKBNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:01:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O1QtcCvH2qGR4e0J1EWJDgAmlRTPk34/mqrg8TlAhCmFNtXNGcQbiMNq9Fl6BZIiEj
         1rBjq2DEJiMw9mTEMr2fTvj506GARXTaaojkv70C1XCPARqVI7Yh5xIUbpplgY5IW3PB
         e/3xdb9JN/ufeDbw8Nw/5VJqQ39PONJaKzEqw=
Date: Mon, 2 Nov 2009 14:01:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 3/6] perf/core: Add a callback to perf events
Message-ID: <20091102130147.GB4878@nowhere>
References: <4AE55B1B.2030006@web.de> <1257109753-6464-4-git-send-email-fweisbec@gmail.com> <19182.22220.389174.916544@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19182.22220.389174.916544@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 02:49:32PM +1100, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > @@ -4335,6 +4336,15 @@ perf_event_alloc(struct perf_event_attr *attr,
> >  
> >  	event->state		= PERF_EVENT_STATE_INACTIVE;
> >  
> > +	if (!callback) {
> > +		if (parent_event)
> > +			event->callback = parent_event->callback;
> > +		else
> > +			event->callback = NULL;
> > +	} else {
> > +		event->callback		= callback;
> > +	}
> 
> Wouldn't this be simpler and clearer as:
> 
> 	if (!callback && parent_event)
> 		callback = parent_event->callback;
> 	event->callback = callback;
> 
> ?
> 
> Paul.


Yep, I'm going to change that.
Thanks.

