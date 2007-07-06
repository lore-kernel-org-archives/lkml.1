Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbXGFOLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbXGFOLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXGFOLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:11:35 -0400
Received: from smtp1.netcabo.pt ([212.113.174.28]:58942 "EHLO
	exch01smtp11.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752464AbXGFOLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:11:34 -0400
Message-ID: <9609.194.65.103.1.1183731007.squirrel@www.rncbc.org>
In-Reply-To: <1183582155.3291.160.camel@chaos>
References: <1183582155.3291.160.camel@chaos>
Date: Fri, 6 Jul 2007 15:10:07 +0100 (WEST)
Subject: Re: v2.6.21.5-rt19
From: "Rui Nuno Capela" <rncbc@rncbc.org>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "RT-Users" <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Fernando Lopez-Lezcano" <nando@ccrma.stanford.edu>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.stanford.edu>,
       "Carsten Emde" <carsten.emde@osadl.org>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-OriginalArrivalTime: 06 Jul 2007 14:11:31.0294 (UTC) FILETIME=[8D4E47E0:01C7BFD7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, July 4, 2007 21:49, Thomas Gleixner wrote:
> I'm pleased to announce the v2.6.21.5-rt19 kernel on behalf of Ingo.
>
>
> It can be downloaded from the usual place:
>
> http://people.redhat.com/mingo/realtime-preempt/
>
> More info about the -rt patch set can be found in the RT wiki:
>
> http://rt.wiki.kernel.org
>
> Changes since 2.6.21.5-rt18:
>
> - Fixed a nasty and hard to track down slowness / boot problem on SMP
> machines with CONFIG_NOHZ enabled. The problem was caused by the timer
> wheel base lock held during the get_next_timer_interrupt() call in the
> idle path, which eventually led to a bogus PI boosting of the idle task
> and in consequence a stale wrong scheduler selection for the affected idle
> task.
>
> Kudos to Carsten Emde, who patiently and meticulously isolated the
> problem and provided the traces, which allowed to identify the root cause.
>
> Problem solution: Prevent idle task boosting
>
> - back port of the ntp / clock_was_set fix
>
> - integration of the processor_idle fix from Venki Pallipadi, which
> resolves boot issues on some platforms
>
> - ep93xx clock events fix from Manfred Gruber
>

Maybe someone remember me whining about troubles with 2.6.21-rt2..18 on my
Core2 T7200 laptop (fujitsu-siemens amilo i1520).

Althought I'm still with my fingers crossed, I can tell the good news are
that 2.6.21.5-rt19 (and -rt20) does behave far better now on the very same
box.

I've more than 8 hours up and running now, without a single glimpse of the
bad symptoms, which used to show in a matter of minutes if not earlier
during init time.

Congratulations. I'm not sure whether this problem can be closed for good,
though, just because you mention the slowness fix applies to CONFIG_NOHZ=Y
and I'm quite sure my badness surged either way.

But at least -rt is usable again here and that just makes me happier :)

Cheers.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org

