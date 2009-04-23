Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbZDWTRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbZDWTRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbZDWTRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:17:13 -0400
Received: from mail2.shareable.org ([80.68.89.115]:50714 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbZDWTRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:17:12 -0400
Date: Thu, 23 Apr 2009 20:17:08 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] Add function graph tracer support for ARM (resend)
Message-ID: <20090423191708.GC13326@shareable.org>
References: <49F0B4FE.8070107@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F0B4FE.8070107@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> The use of "already_here" works around trace entry nesting
> (I believe due to instrumentation of either cpu_clock or
> raw_smp_processor_id).  Advice on the best way to deal
> with this would be appreciated.  (that is, whether
> to use the guard variable, or just un-instrument the
> offending routines).

I think it's better to keep functions instrumented where possible, if
checking for context isn't too expensive.  Sometimes it's interesting
to see how many times they are called.

But it's not much use instrumenting those functions if activity on a
different CPU suppresses it.  Is there no way to make "already_here"
task/CPU specific?

What do other architectures do?  Consistency is good.

-- Jamie
