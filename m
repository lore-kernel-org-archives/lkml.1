Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZA2EoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZA2EoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZA2En7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:43:59 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:54992 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbZA2En6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:43:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAIjAgElMQWt2/2dsb2JhbACBbshohA+BOAY
Date: Wed, 28 Jan 2009 23:43:56 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng 0.87 improved page fault tracing
Message-ID: <20090129044356.GA26018@Krystal>
References: <20090127210203.GA13478@Krystal> <20090129123827.A959.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090129123827.A959.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:36:36 up 28 days,  4:34,  2 users,  load average: 0.06, 0.08,
	0.02
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi
> 
> interesting..
> 
> > I just combined the 4 page fault handler events that were in the tracing
> > hot path of LTTng into 2 :
> > 
> > kernel page_fault_entry
> > kernel page_fault_exit
> > 
> > They take as parameter the combination of what was available in the
> > trap_entry/exit events and handle_mm_fault entry/exit events. This
> > should lessen the performance impact of the tracer when it's active.
> > I did the related modifications in LTTV 0.12.8.
> 
> Just question.
> 
> As far as I know, customer has two different requeremtn of the page fault.

    1 a)
>   (1) collect number of all page fault
>       -> if it is too large, too many interrupt decrease performance.
        (a single event is required for this)

    1 b) the user may also want to know the time spent in the page fault
    handler to service those faults, therefore involving page fault
    entry and exit events.


>   (2) collect number of major page fault
>       -> major page fault indicate to increase random access I/O,
>          then, some customer want to collect major page fault
>          (don't include minor page fault)

Yes, the trace_page_fault_exit takes the "fault" parameter returned by
handle_mm_fault (which is recorded to the trace as the "res" event
field). Using

res & VM_FAULT_MAJOR

will give only the major page faults. Note that some knowledge of the
bitmask is required to interpret the "res" bitfield. This could be done
by a specific analysis module. I would ideally like to create a LTTng
module to export tables including those bitfields so we can keep the
bitfield interpretation in sync with the kernel code changes more or
less automatically.

> 
> Is this patch fill (2) requirement?
> 

Yes.

Mathieu

> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
