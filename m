Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbZF1PQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbZF1PQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZF1PQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:16:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:48255 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZF1PQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:16:41 -0400
Subject: Re: [PATCH 2/3 -tip] perf_counter tools: Add support to set of
 multiple events in one shot
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090628132926.GD31988@elte.hu>
References: <1246051852.2988.8.camel@hpdv5.satnam>
	 <1246051927.2988.10.camel@hpdv5.satnam>
	 <1246051996.2988.12.camel@hpdv5.satnam> <20090627163821.GA17638@elte.hu>
	 <1246129498.32198.27.camel@hpdv5.satnam>  <20090628132926.GD31988@elte.hu>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 20:46:06 +0530
Message-Id: <1246202166.2982.8.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 15:29 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Sat, 2009-06-27 at 18:38 +0200, Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > > Add support for HARDWARE and SOFTWARE events :
> > > >  perf stat -e all-sw-events
> > > >  perf stat -e sw-events
> > > >  perf stat -e all-hw-events
> > > >  perf stat -e hw-events
> > > 
> > > > +static struct event_type_symbol event_type_symbols[] = {
> > > > + [PERF_TYPE_HARDWARE]	= { "hw-events",	"all-hw-events",	},
> > > > + [PERF_TYPE_SOFTWARE]	= { "sw-events",	"all-sw-events",	},
> > > 
> > > Hm, this really just special-cases and open-codes these. The better 
> > > solution is what i suggested in my review of your prior patches: 
> > > regex pattern matching.
> > > 
> > 
> > parse_events() is responsible to parse events for 'perf stat -e' 
> > and it is parsing by parse_event_symbol()
> > 
> > If you want to use regex pattern matching then either we should 
> > make some another option or if we need to rewrite 
> > parse_event_symbol to use regex pattern matching which will be 
> > applicable to all the events.
> 
> As i mentioned it before, i think the most intuitive solution is to 
> extend the --event syntax with regex patterns. No new option - just 
> richer -e syntax.
> 
> We could have this syntax:
> 
>   hw-cpu-cycles
>   hw-instructions
>   hw-cache-references
>   hw-cache-misses
>   hw-branch-instructions
>   hw-branch-misses
>   hw-bus-cycles
> 
>   sw-cpu-clock
>   sw-task-clock
>   sw-page-faults
>   sw-minor-faults
>   sw-major-faults
>   sw-context-switches
>   sw-cpu-migrations
> 
> regex patterns like:
> 
>   hw-*
>   sw-*
>   *
> 
> the first one would select all hardware events - the second all 
> software events - the third all events in general. But other regex 
> patterns make sense too, like:
> 
>   *branch*
>   *cache*
>   *fault*
> 
> And as the number of generic events increases, so will regex 
> patterns become more and more useful.
> 

This is a good approach, but this should be done separately because
these will effect all the events.

Currently I send patches to support multiple events in one shot which is
adding new feature.

And you telling to use regex wildcard for all the events in
parse_event_symbol() which is enhancement and should be done in series
of patches.

Do not you think you are mixing 2 things. I request you to accept
"multiple events in one shot" patches. And then we will do enhancement.

Thanks,
--
JSR



