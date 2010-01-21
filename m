Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149Ab0AUKMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab0AUKMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670Ab0AUKMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:12:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0AUKMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:12:15 -0500
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <bd4cb8901001210208h758a546cw19fc81300164ec55@mail.gmail.com>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop>
	 <20100118144556.GE10364@nowhere>
	 <bd4cb8901001210208h758a546cw19fc81300164ec55@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 11:11:52 +0100
Message-ID: <1264068712.4283.1141.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:08 +0100, Stephane Eranian wrote:
> >> > Do you mean this:
> >> >
> >> > hw_perf_group_sched_in_begin(&x86_pmu);
> >> >
> >> > for_each_event(event, group) {
> >> >         event->enable();        //do the collection here
> >> > }
> >> >
> >> >
> >> > if (hw_perf_group_sched_in_end(&x86_pmu)) {
> >> >         rollback...
> >> > }
> >> >
> >> > That requires to know in advance if we have hardware pmu
> >> > in the list though (can be a flag in the group).
> >>
> 
> I don't think this model can work without scheduling for each event.
> 
> Imagine the situation where you have more events than you have
> counters. At each tick you:

No it wont indeed, but it will work for where we now use
hw_perf_group_sched_in() without having to replicate lots of code.

For the cases you mention I see no other way than to try and schedule
each event individually.

