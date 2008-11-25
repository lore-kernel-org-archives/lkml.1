Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbYKYR0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbYKYR0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYKYRZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:25:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54019 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbYKYRZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:25:09 -0500
Date: Tue, 25 Nov 2008 12:24:08 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/16] Markers auto enable tracepoints (new API : trace_mark_tp())
Message-ID: <20081125172407.GB16372@redhat.com>
References: <20081114224948.134716055@polymtl.ca> <20081116075928.GB530@elte.hu> <20081125211750.26F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125211750.26F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Nov 25, 2008 at 09:23:57PM +0900, KOSAKI Motohiro wrote:
> Sorry for very late response.
> However, if you do marker removing discussion, I hope CC to Frank Eigler.

Thanks!

> because SystemTap also use marker and tracepoint.  and this patch
> also improvement SystemTap marker support, I think.

I believe that this trace_mark_tp variant would operate at a level
below systemtap's.  It would mainly improve the kernel performance and
simplify kernel code.

> IIRC, Currently, Systemtap also have marker/tracepoint on/off
> synchronization problem.

Right, to the extent that systemtap can currently connect to markers
and not yet tracepoints, so tracepoints need to be converted to
markers or another systemtap-visible hooking mechanism at some point.
This is a temporary state of affairs though, as we hope to talk to
tracepoints directly before too long.


mingo wrote:

> > I was actually hoping for markers (the in-kernel API) to go away 
> > completely - and be replaced with tracepoints.

(If you're seriously contemplating outright removal of this API, then
the earlier worries about how markers would somehow tie its users'
hands to keep them around forever was surely exaggerated.)


> > Markers are the wrong design on several levels. They couple the kernel 
> > dynamically with unknown (to the kernel) entities -  [...]
> > Tracepoints are much more specific - typed and enumerated function 
> > call callback points in essence [...]

You are confusing type safety and "unknown (to the kernel)"-ness.

Markers provide some type safety via the format string; tracepoints
via individual C declarations.

Markers can connect to "unknown (to the kernel)" clients since their
API is EXPORT_SYMBOL_GPL'd.  Tracepoints do exactly the same thing.

There are certainly differences between them, but these two particular
ones are immaterial.


- FChE
