Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZA2ErV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZA2ErV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZA2ErM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:47:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52871 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZA2ErM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:47:12 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [ltt-dev] LTTng 0.87 improved page fault tracing
Cc: kosaki.motohiro@jp.fujitsu.com, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090129044356.GA26018@Krystal>
References: <20090129123827.A959.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090129044356.GA26018@Krystal>
Message-Id: <20090129134614.A95F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 29 Jan 2009 13:47:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > Hi
> > 
> > interesting..
> > 
> > > I just combined the 4 page fault handler events that were in the tracing
> > > hot path of LTTng into 2 :
> > > 
> > > kernel page_fault_entry
> > > kernel page_fault_exit
> > > 
> > > They take as parameter the combination of what was available in the
> > > trap_entry/exit events and handle_mm_fault entry/exit events. This
> > > should lessen the performance impact of the tracer when it's active.
> > > I did the related modifications in LTTV 0.12.8.
> > 
> > Just question.
> > 
> > As far as I know, customer has two different requeremtn of the page fault.
> 
>     1 a)
> >   (1) collect number of all page fault
> >       -> if it is too large, too many interrupt decrease performance.
>         (a single event is required for this)
> 
>     1 b) the user may also want to know the time spent in the page fault
>     handler to service those faults, therefore involving page fault
>     entry and exit events.

Indeed.
that's great.


> >   (2) collect number of major page fault
> >       -> major page fault indicate to increase random access I/O,
> >          then, some customer want to collect major page fault
> >          (don't include minor page fault)
> 
> Yes, the trace_page_fault_exit takes the "fault" parameter returned by
> handle_mm_fault (which is recorded to the trace as the "res" event
> field). Using
> 
> res & VM_FAULT_MAJOR
> 
> will give only the major page faults. Note that some knowledge of the
> bitmask is required to interpret the "res" bitfield. This could be done
> by a specific analysis module. I would ideally like to create a LTTng
> module to export tables including those bitfields so we can keep the
> bitfield interpretation in sync with the kernel code changes more or
> less automatically.

Agreed.
thanks for great improvement.


> 
> > 
> > Is this patch fill (2) requirement?
> > 
> 
> Yes.
> 
> Mathieu
> 
> > 
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68



