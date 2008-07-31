Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbYGaTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbYGaTz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYGaTzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:55:15 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:19731 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYGaTzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HYeb9G0AucmKGiIVddOGeU43ptU18ejN8wteDYNDFGUNwryFBjZyTvLBb59ykVqmAS
         ZKPffavLplFJAh/i4M6FWiNyI8GOO8i9U68cNXr+1+Y6AhbF+/t/5pgds15XOUZyKdKm
         nIi2jR1J2PYzyKjWEYZjEhZxbO+Iobo87VSyA=
Message-ID: <b647ffbd0807311255w375a90a8v8fa4b05c81f3785f@mail.gmail.com>
Date: Thu, 31 Jul 2008 21:55:11 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Oops in microcode sysfs registration,
Cc: "Alistair John Strachan" <alistair@devzero.co.uk>,
       "Pekka Paalanen" <pq@iki.fi>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       shaohua.li@intel.com, tigran@aivazian.fsnet.co.uk,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <b647ffbd0807311252qddc716ap6a6ec6d83f172028@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
	 <200807291457.58408.alistair@devzero.co.uk>
	 <20080729192214.2d3a4ca5@daedalus.pq.iki.fi>
	 <200807291750.41169.alistair@devzero.co.uk>
	 <b647ffbd0807300207s1ba47899j7220f83ed60d98a8@mail.gmail.com>
	 <b647ffbd0807300335w1bedfe73m4959fba1e5c93401@mail.gmail.com>
	 <20080731165650.GJ26393@elte.hu>
	 <b647ffbd0807311252qddc716ap6a6ec6d83f172028@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/31 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
>>
>> could you please send this patch with a changelog, explanation, etc.?
>
> Now having thought a bit more on that issue, I tend to think that this
> patch is not all that nice (so I agree with Max here).
>
> The root problem is the way set_cpus_allowed_ptr() is used in
> microcode's cpu-hotplug handler. With cpu_active_map in place
> set_cpus_allowed_ptr() can't migrate a task on the soon-to-be-online
> cpu from withing a CPU_ONLINE handler (more in details here:
> http://lkml.org/lkml/2008/7/24/260)
>
> Basically, this patch marks a 'cpu' available for other tasks to be
> migrated to it before sending CPU_ONLINE notification to
> subscribers... [ now, there can be CPU_ONLINE
> http://lkml.org/lkml/2008/7/24/260handlers that has something to do
> with enabling migration/load-balancing. e.g. migration_call() ,
> although it has the highest prio and is supposed to run first in a
> chain ]
>
> In another thread, I've asked whether doing 'microcode update' in
> start_secondary() (or even at the beginning of idle_cpu() would be
> better):
>
> pros:
> - it's done as early as possible (no other tasks has started running
> on a cpu yet);
> - no actions in cpu-hotplug;
>
> cons:
> - microcode sub-systems becomes visible outside of microcode.c _but_
> it's arch-specific part anyway + with object-oriented re-work (which
> is in -tip), I think it'd be that bad.

it was supposed to be "it'd be _not_ that bad"


-- 
Best regards,
Dmitry Adamushko
