Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0BMNxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:53:12 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:52220 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab0BMNxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:53:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=nNICGxBMaT45UaEvMNDLmuF6e2rDJe9YUJ8afTvssC0IRg/mQIWYC0psxPV04D3g0H
         ALAmqOFKhOic2cHnVT9sSp92Khc3ipDo72hgegjr+k1kYXTfg+2Vxfuy/vLkPrM48V8I
         Rm4JJkiELQHGZWNvEfSd+NwooO4NVT20M80gw=
Date: Sat, 13 Feb 2010 11:53:00 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH] perf_events: Fix FORK events
Message-ID: <20100213135300.GB2602@ghostprotocols.net>
References: <1265384243.30057.42.camel@laptop>
 <20100208074438.GC24721@elte.hu>
 <1265644666.11509.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265644666.11509.5.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 08, 2010 at 04:57:46PM +0100, Peter Zijlstra escreveu:
> On Mon, 2010-02-08 at 08:44 +0100, Ingo Molnar wrote:
> > 
> > > We could of course just slam the commit in and not worry about it, but
> > > that just doesn't feel right.
> > 
> > Would be nice to figure it out ... 
> 
> OK, so it is real simple, patch 22e19085 ("perf: Honour event state for
> aux stream data") drops all events for !ACTIVE and newly inherited child
> counters are INACTIVE.
> 
> So we can either go with the original patch and send the FORK events to
> the parent because that's always ACTIVE (already true for COMM and
> MMAP), or weaken the state test to < INACTIVE, which would also satisfy
> Anton's case because PERF_EVENT_IOC_DISABLE sets events to OFF.

I saw the missing forks on another testcase and after applying the
original patch I got them, I guess we should apply that one to have
2.6.33 good in this regard, if still possible to get this in.

- Arnaldo
