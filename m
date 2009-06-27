Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZF0TFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZF0TFu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 15:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZF0TFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 15:05:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:39306 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbZF0TFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 15:05:40 -0400
Subject: Re: [PATCH 2/3 -tip] perf_counter tools: Add support to set of
 multiple events in one shot
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090627163821.GA17638@elte.hu>
References: <1246051852.2988.8.camel@hpdv5.satnam>
	 <1246051927.2988.10.camel@hpdv5.satnam>
	 <1246051996.2988.12.camel@hpdv5.satnam>  <20090627163821.GA17638@elte.hu>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 00:34:58 +0530
Message-Id: <1246129498.32198.27.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 18:38 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Add support for HARDWARE and SOFTWARE events :
> >  perf stat -e all-sw-events
> >  perf stat -e sw-events
> >  perf stat -e all-hw-events
> >  perf stat -e hw-events
> 
> > +static struct event_type_symbol event_type_symbols[] = {
> > + [PERF_TYPE_HARDWARE]	= { "hw-events",	"all-hw-events",	},
> > + [PERF_TYPE_SOFTWARE]	= { "sw-events",	"all-sw-events",	},
> 
> Hm, this really just special-cases and open-codes these. The better 
> solution is what i suggested in my review of your prior patches: 
> regex pattern matching.
> 

parse_events() is responsible to parse events for 'perf stat -e' and it
is parsing by parse_event_symbol()

If you want to use regex pattern matching then either we should make
some another option or if we need to rewrite parse_event_symbol to use
regex pattern matching which will be applicable to all the events.

Let me know which option you are looking for.

Thanks,
--
JSR

