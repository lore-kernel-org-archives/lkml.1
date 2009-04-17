Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbZDQQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbZDQQOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbZDQQOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:14:04 -0400
Received: from gw.goop.org ([64.81.55.164]:43609 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701AbZDQQOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:14:02 -0400
Message-ID: <49E8AAC8.5080004@goop.org>
Date: Fri, 17 Apr 2009 09:14:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: mathieu.desnoyers@polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/4] x86/pvops: target CREATE_TRACE_POINTS to particular
 subsystems
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-3-git-send-email-jeremy@goop.org> <alpine.DEB.2.00.0904171149100.14919@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904171149100.14919@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Instead of doing it this way, what about not having this new header, and 
> just do:
>
>
> #ifdef CREATE_IRQ_TRACE_POINTS
> #define CREATE_TRACE_POINTS
> #endif
> #include <trace/define_trace.h>
>
> Heck, define_trace.h is only defined when CREATE_TRACE_POINTS is defined, 
> why not just remove that and have:
>
> #ifdef CREATE_IRQ_TRACE_POINTS
> #define <trace/define_trace.h>
> #endif
>
> The whole trickery with the CREATE_TRACE_POINTS was to avoid the #if in 
> the trace headers anyway. If we can't avoid it. We don't need to add more 
> confusion to the mix.
>   

OK, and remove the test for CREATE_TRACE_POINTS in define_trace.h 
altogether?  Works for me.
Uh, still needs the #undef CREATE_IRQ_TRACE_POINTS.

    J
