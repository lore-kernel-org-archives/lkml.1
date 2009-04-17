Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbZDQQcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbZDQQcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761406AbZDQQcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:32:10 -0400
Received: from gw.goop.org ([64.81.55.164]:42882 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998AbZDQQcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:32:10 -0400
Message-ID: <49E8AF03.6070509@goop.org>
Date: Fri, 17 Apr 2009 09:32:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 3/5] tracing/events: add rcu locking around trace event
 prints
References: <20090416021830.556671772@goodmis.org> <20090416021928.467656424@goodmis.org> <alpine.DEB.2.00.0904171004210.14919@gandalf.stny.rr.com> <20090417161820.GA26479@mit.edu>
In-Reply-To: <20090417161820.GA26479@mit.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> I haven't been following all of the e-mail threads about the include
> hell problem; what are the issues, exactly?  What's the problem with
> simply including <linux/rcuupdate.h>, and any needed prequisites in
> ftrace.h?

I'm adding tracing support to paravirt.h, which in turn gets included in 
various low-level arch/x86 headers.  If it starts including other 
high-level linux/ headers, we quickly get into deep #include recursion 
problems and undefined symbols.

    J
