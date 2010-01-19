Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492Ab0ASQfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0ASQfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 11:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500Ab0ASQft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 11:35:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:41956 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab0ASQfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:35:48 -0500
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <20100119155508.GE8061@nowhere>
References: <1263825158.4283.590.camel@laptop>
	 <20100118144556.GE10364@nowhere> <1263826601.4283.603.camel@laptop>
	 <20100118161836.GG10364@nowhere> <1263831973.4283.622.camel@laptop>
	 <20100118165114.GJ10364@nowhere> <1263834806.4283.625.camel@laptop>
	 <20100118172935.GM10364@nowhere> <1263903773.4283.657.camel@laptop>
	 <1263907489.4283.663.camel@laptop>  <20100119155508.GE8061@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 17:25:23 +0100
Message-ID: <1263918323.4283.707.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 16:55 +0100, Frederic Weisbecker wrote:
> > Also, I see you set an ->unthrottle, but then don't implement it, but
> > comment it as todo, which is strange because that implies its broken. If
> > there's an ->unthrottle method it will throttle, so if its todo, the
> > safest thing is to not set it.
> 
> 
> Yeah, that's because I have a too vague idea on what is the purpose
> of the unthrottle() callback.
> 
> I've read the concerned codes that call this, several times, and I still
> can't figure out what happens there, not sure what is meant by throttle
> or unthrottle there :-/ 

OK, so not setting it is relatively safe.

As to what it does, it has to undo everything you do when
perf_event_overflow() returns true, which happens when ->unthrottle is
set and we get more than sysctl_perf_event_sample_rate/HZ events in a
jiffy.

If you look at the x86 implementation, you'll see that we simply disable
the hardware counter when the overflow call returns true, so the
unthrottle() callback simply enables it again.


