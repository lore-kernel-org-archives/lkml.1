Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0BJQOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:14:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab0BJQOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:14:23 -0500
Subject: Re: [PATCH]  perf_events: AMD event scheduling (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <20100210160958.GK24679@erda.amd.com>
References: <4b703957.0702d00a.6bf2.7b7d@mx.google.com>
	 <1265803166.11509.286.camel@laptop>  <20100210160958.GK24679@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 17:14:01 +0100
Message-ID: <1265818441.11509.305.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 17:09 +0100, Robert Richter wrote:
> On 10.02.10 12:59:26, Peter Zijlstra wrote:
> > On Mon, 2010-02-08 at 17:17 +0200, Stephane Eranian wrote:
> > >         This patch adds correct AMD Northbridge event scheduling.
> > >         It must be applied on top tip-x86 + hw_perf_enable() fix.
> > > 
> > >         NB events are events measuring L3 cache, Hypertransport
> > >         traffic. They are identified by an event code  >= 0xe0.
> > >         They measure events on the Northbride which is shared
> > >         by all cores on a package. NB events are counted on a
> > >         shared set of counters. When a NB event is programmed
> > >         in a counter, the data actually comes from a shared
> > >         counter. Thus, access to those counters needs to be
> > >         synchronized.
> > > 
> > >         We implement the synchronization such that no two cores
> > >         can be measuring NB events using the same counters. Thus,
> > >         we maintain a per-NB * allocation table. The available slot
> > >         is propagated using the event_constraint structure.
> > > 
> > >         The 2nd version takes into account the changes on how
> > >         constraints are stored by the scheduling code.
> > > 
> > >         The 3rd version fixes formatting issues, code readability
> > >         and one bug in amd_put_event_constraints().
> > > 
> > >         Signed-off-by: Stephane Eranian <eranian@google.com>
> > 
> > OK, took this with the below merged in.
> 
> Peter,
> 
> will this go to tip/perf/core? Or is there another tree?

Currently my quilt queue, should end up in tip/perf/core in a day or so.

