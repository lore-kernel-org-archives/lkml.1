Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZD1Jet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZD1Jet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZD1Jek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:34:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50108 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZD1Jej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:34:39 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Cc: kosaki.motohiro@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-2022-JP?B?RnIbJEJxRXFTGyhCaWM=?= Weisbecker 
	<fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090428092918.GC21085@elte.hu>
References: <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com> <20090428092918.GC21085@elte.hu>
Message-Id: <20090428183237.EBDE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 28 Apr 2009 18:34:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > I have no idea how expensive tracepoints are but I suspect they 
> > don't make too much sense for this particular scenario. After all, 
> > kmemtrace is mainly interested in _allocation patterns_ whereas 
> > this patch seems to be more interested in "memory layout" type of 
> > things.
> 
> My point is that the allocation patterns can be derived from dynamic 
> events. We can build a map of everything if we know all the events 
> that led up to it. Doing:
> 
>   echo 3 > /proc/sys/vm/drop_caches
> 
> will clear 99% of the memory allocations, so we can build a new map 
> from scratch just about anytime. (and if boot allocations are 
> interesting they can be traced too)
> 
> _And_ via this angle we'll also have access to the dynamic events, 
> in a different 'view' of the same tracepoints - which is obviously 
> very useful for different purposes.

I am one of most strongly want guys to MM tracepoint.
but No, many cunstomer never permit to use drop_caches.

I believe this patch and tracepoint are _both_ necessary and useful.



