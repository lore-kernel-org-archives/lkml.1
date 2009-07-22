Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZGVFOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZGVFOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZGVFOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:14:25 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:44715 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZGVFOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:14:24 -0400
Date: Wed, 22 Jul 2009 15:10:53 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Always return the parent counter id to
	userspace
Message-ID: <20090722051052.GC9029@kryten>
References: <20090720103825.GA9029@kryten> <1248087346.15751.8437.camel@twins> <20090720114720.GB9029@kryten> <1248095846.15751.8781.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248095846.15751.8781.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Peter,
 
> Hmm, ok, so how about something like this:
> 
> ---
> Subject: perf_counter: PERF_SAMPLE_ID and inherited counters
> 
> Anton noted that for inherited counters the counter-id as provided by
> PERF_SAMPLE_ID isn't mappable to the id found through PERF_RECORD_ID
> because each inherited counter gets its own id.
> 
> His suggestion was to always return the parent counter id, since that is
> the primary counter id as exposed. However, these inherited counters
> have a unique identifier so that events like PERF_EVENT_PERIOD and
> PERF_EVENT_THROTTLE can be specific about which counter gets modified,
> which is important when trying to normalize the sample streams.
> 
> This patch removes PERF_EVENT_PERIOD in favour of PERF_SAMPLE_PERIOD,
> which is more useful anyway, since changing periods became a lot more
> common than initially thought -- rendering PERF_EVENT_PERIOD the less
> useful solution (also, PERF_SAMPLE_PERIOD reports the more accurate
> value, since it reports the value used to trigger the overflow, whereas
> PERF_EVENT_PERIOD simply reports the requested period changed, which
> might only take effect on the next cycle).
> 
> This still leaves us PERF_EVENT_THROTTLE to consider, but since that
> _should_ be a rare occurrence, and linking it to a primary id is the
> most useful bit to diagnose the problem, we introduce a
> PERF_SAMPLE_STREAM_ID, for those few cases where the full reconstruction
> is important.

I gave it a try and the perf.data results make much more sense.
Thanks!

Anton
