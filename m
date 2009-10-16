Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZJPHeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZJPHeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZJPHeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:34:24 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:34447 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbZJPHeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S6JB2Xnb3UuSqNqQ/VQ7GzW68rPJGencGoVKxB7x3WR8mUqq0EdvCQGJgu/RPFH4d/
         xpOvMQNkqOKx0SWKazt2/iXVZpxZ82xCMA/uApAQLzJhw9MKPtiwBe3c5XIZVhMu41OA
         dWekQ3OjSWx2+RF3P2g/bZrju2z+Img2gUUZc=
Date: Fri, 16 Oct 2009 09:33:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf tools: Add a new generic section in perf.data
Message-ID: <20091016073337.GA5069@nowhere>
References: <1255641017-13958-1-git-send-email-fweisbec@gmail.com> <20091016071046.GD20388@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016071046.GD20388@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 09:10:46AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > +/*
> > + * Version 0: contains trace_info section only
> > + */
> > +struct perf_file_additionals {
> > +	u64				version;
> > +	struct perf_file_section	trace_info;
> > +};
> 
> i dont disagree with the change - but it would be even nicer to simply 
> define a features bitmask, instead of a flat version - and add the 
> trace_info section as a feature.
> 
> That way it's all a lot more manageable: we dont know about versions per 
> se, we know about features. Individual features could be developed (and 
> backported) in a distributed way - without having to worry about a flat 
> version model.
> 
> So i'd suggest something like a bitmask in the perf.data file header:
> 
> 	DECLARE_BITMAP(features, 256);
> 
> Plus every perf version knows about the features it supports:
> 
> 	DECLARE_BITMAP(features_supported, 256);
> 
> The compatibility rule is: perf only touches attributes that belong to 
> features it knows about.
> 
> 	Ingo


Yeah, I've thought about that too but feared about the limitation
of bitweight(u64), although it's probably enough, we never know.
That said I can take a bunch of four u64 to draw this bitmap and 256
features is enough.

Indeed that's way much better as a bitmap. Will do that instead.

