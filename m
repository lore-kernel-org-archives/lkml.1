Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYIWC0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYIWC0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYIWC0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:26:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:54464 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbYIWC0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:26:37 -0400
Message-ID: <e17d46420809221926g1396fbb4id5b9c934bad1d96e@mail.gmail.com>
Date: Mon, 22 Sep 2008 19:26:36 -0700
From: "Darren Hart" <darren@dvhart.com>
To: "Mathieu Desnoyers" <compudj@krystal.dyndns.org>
Subject: Re: Unified tracing buffer
Cc: "Roland Dreier" <rdreier@cisco.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Masami Hiramatsu" <mhiramat@redhat.com>,
       "Martin Bligh" <mbligh@google.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <20080923020216.GC24937@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <48D7F5E8.3000705@redhat.com>
	 <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>
	 <48D81B5F.2030702@redhat.com>
	 <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
	 <48D832B6.3010409@redhat.com>
	 <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org>
	 <adaod2f649o.fsf@cisco.com> <20080923020216.GC24937@Krystal>
X-Google-Sender-Auth: 3d63f44a910f46f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 7:02 PM, Mathieu Desnoyers <compudj@krystal.dyndns.org>
> So only in the specific case of instrumentation of things like locking,
> where it is possible to insure that instrumentation is synchronized with
> the instrumented operation, does it make a difference to choose the TSC
> (which implies a slight delta between the TSCs due to cache line delays
> at synchronization and delay due to TSCs drifts caused by temperature)
> over an atomic increment.
>

Hrm, i think that overlooks the other reason to use a time based counter over
an atomic increment: you might care about time.  Perhaps one might be less
concerned with actual order tightly grouped events and more concerned with the
actual time delta between more temporally distant events.  In that case, using
a clocksource would still be valuable. Although admitedtly the caller could
embed that in their payload, but since we seem to agree we need some kind of
counter, the time-based counter appears to be the most flexible.

Thanks,

-- 
Darren Hart
