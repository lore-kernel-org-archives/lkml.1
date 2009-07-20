Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZGTLwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZGTLwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 07:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZGTLwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 07:52:14 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:34461 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbZGTLwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 07:52:14 -0400
Date: Mon, 20 Jul 2009 21:47:20 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Always return the parent counter id to
	userspace
Message-ID: <20090720114720.GB9029@kryten>
References: <20090720103825.GA9029@kryten> <1248087346.15751.8437.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248087346.15751.8437.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter,
 
> Please add -p to your diff args, or use
> QUILT_DIFF_OPTS="--show-c-function".

Sorry about that, I lost my .quiltrc somewhere along the line.

> > @@ -2704,8 +2718,10 @@
> >  	if (sample_type & PERF_SAMPLE_ADDR)
> >  		perf_output_put(&handle, data->addr);
> >  
> > -	if (sample_type & PERF_SAMPLE_ID)
> > -		perf_output_put(&handle, counter->id);
> > +	if (sample_type & PERF_SAMPLE_ID) {
> > +		u64 id = primary_counter_id(counter);
> > +		perf_output_put(&handle, id);
> > +	}
> >  
> >  	if (sample_type & PERF_SAMPLE_CPU)
> >  		perf_output_put(&handle, cpu_entry);
> 
> This will actually wreck things.
> 
> It would be impossible to relate PERF_EVENT_PERIOD/THROTTLE (and maybe
> others) to their respective counters.
> 
> If you have inherited counters and each task will have separate ones,
> you need separate IDs in their sample stream to be able to related
> PERIOD and THROTTLE events.

I think I'm missing something. I'm logging two events at once with perf record
(-e page-faults -e dTLB-load-misses) and I added PERF_SAMPLE_ID to be able to
identify each event in the output file.

I'm not seeing a way to inherit and share counters (so we always get a
consistent id which matches the perf.data header), or a way for the new
counters to be written out to the log as they are created (so I can work
back to the original id).

Anton
