Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbYIYQNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbYIYQNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYIYQNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:13:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:54125 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYIYQNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cFmkjr8wVhz+nvbe1JqNJaF97kA7l3ccVRKyvsMKAfPYzV0NtmkmwGhuf/4aiYXEaZ
         8uHwkf67JNZePGqevAjkpAFw3VO1rwGDmdBBUsXPnXHgSaeWQchvzHHnyTEdFUpjDs5k
         oXV3qHl4+TDtcQRcqR9tUvl2581B3mNX4kGr8=
Message-ID: <c62985530809250913q227a5876k19b1b0ec591ad3cd@mail.gmail.com>
Date: Thu, 25 Sep 2008 18:13:44 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [Patch -tip 3/3] Tracing/ftrace: Don't consume entries unhandled by mmiotrace
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080925183608.283babfb@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DB8408.7080408@gmail.com>
	 <20080925173435.5f525557@daedalus.pq.iki.fi>
	 <c62985530809250744t3ce0011ajebd8343eb748cf24@mail.gmail.com>
	 <20080925183608.283babfb@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/25 Pekka Paalanen <pq@iki.fi>:
> We can (must) return to this if/when multiple tracers are allowed
> to be active simultaneously. But in the current situation, I do not
> see a way to trace more than one thing, but I haven't really looked
> into the other tracers.

You can enable another tracer simultaneously. I never tried it but you can
launch one from debugfs and another from kernel code for example.
The new boot tracer will have to launch the sched_switch tracer.
And since the functions which display the sched_switch entries are
already inside
trace.c I wanted to relay the display to the "default display
functions". That's one of
the reason of my patch (+ the bug).
But I could proceed in a another way than default relaying. Why not
using a function exported
by the tracing engine to display sched_switches.

> but tracing functions is useless
> or harmful in the usual use case of mmiotrace, i.e. tracing a binary-only
> proprietary driver. The functions will be anonymous anyway, and we can't
> disassemble the driver due to possible legal reasons. That's why mmiotrace
> does not even collect instruction pointers by default, although it
> supports them (or did, can't recall if it works now, since it hasn't been
> needed). I assume the goal is to create a free open driver without any
> legal issues by watching what the proprietary driver does.
>
> Even if the log would be cluttered with MMIO from other, uninteresting
> drivers, you can use the physical address to filter the entries by
> device (and therefore driver) afterwards. This is one reason why
> an mmiotrace log starts with the contents of /proc/bus/pci/devices.
>
> Was there some other scenario you were thinking about?

When I wanted to help on the ath5k project, I used to compare madwifi
traces with the ath5k traces. The goal was to find where was the
trouble when support for ar2425 cards didn't worked.
And I wanted to see the name of the functions where the code entered
to see where I was in the traces. That's why I wanted to have
an mmiotrace_printk function primarily :)
But I think one could use it for debugging too. Just to know where we
are in the trace.
