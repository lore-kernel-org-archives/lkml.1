Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0BJQKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:10:19 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:44130 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab0BJQKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:10:17 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dN936eM62a3Lzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KXMVKN-01-4EZ-02
X-M-MSG: 
Date: Wed, 10 Feb 2010 17:09:58 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH]  perf_events: AMD event scheduling (v3)
Message-ID: <20100210160958.GK24679@erda.amd.com>
References: <4b703957.0702d00a.6bf2.7b7d@mx.google.com>
 <1265803166.11509.286.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1265803166.11509.286.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Feb 2010 16:09:59.0422 (UTC) FILETIME=[7E8309E0:01CAAA6B]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.02.10 12:59:26, Peter Zijlstra wrote:
> On Mon, 2010-02-08 at 17:17 +0200, Stephane Eranian wrote:
> >         This patch adds correct AMD Northbridge event scheduling.
> >         It must be applied on top tip-x86 + hw_perf_enable() fix.
> > 
> >         NB events are events measuring L3 cache, Hypertransport
> >         traffic. They are identified by an event code  >= 0xe0.
> >         They measure events on the Northbride which is shared
> >         by all cores on a package. NB events are counted on a
> >         shared set of counters. When a NB event is programmed
> >         in a counter, the data actually comes from a shared
> >         counter. Thus, access to those counters needs to be
> >         synchronized.
> > 
> >         We implement the synchronization such that no two cores
> >         can be measuring NB events using the same counters. Thus,
> >         we maintain a per-NB * allocation table. The available slot
> >         is propagated using the event_constraint structure.
> > 
> >         The 2nd version takes into account the changes on how
> >         constraints are stored by the scheduling code.
> > 
> >         The 3rd version fixes formatting issues, code readability
> >         and one bug in amd_put_event_constraints().
> > 
> >         Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> OK, took this with the below merged in.

Peter,

will this go to tip/perf/core? Or is there another tree?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

