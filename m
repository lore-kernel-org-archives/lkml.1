Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZBQTYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZBQTYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZBQTYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:24:10 -0500
Received: from smtp.nokia.com ([192.100.122.233]:58884 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbZBQTYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:24:09 -0500
Subject: Re: [PATCH] ARM fix syscall trace return value
From: Viktor Rosendahl <Viktor.Rosendahl@nokia.com>
To: ext Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Russell King <rmk@arm.linux.org.uk>, ext Tony Lindgren <tony@atomide.com>,
       "Moiseichuk Leonid (Nokia-D/Helsinki)" <leonid.moiseichuk@nokia.com>,
       "Kallioinen Juha (Nokia-D/Helsinki)" <juha.kallioinen@nokia.com>,
       "Siamashka Siarhei (Nokia-D/Helsinki)" <siarhei.siamashka@nokia.com>,
       "Tamminen Eero (Nokia-D/Helsinki)" <eero.tamminen@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <20090217181805.GA15788@Krystal>
References: <20090217181805.GA15788@Krystal>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 21:22:03 +0200
Message-Id: <1234898523.14675.18.camel@viktor.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2009 19:21:45.0585 (UTC) FILETIME=[F8D5AE10:01C99134]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 19:18 +0100, ext Mathieu Desnoyers wrote: 
> Hi Russell,
> 
> I am currently finding core bugs in the Linux kernel implementation of
> the ARM architecture. :-( e.g. return value not being sent to the
> syscall_trace function upon exit (upon which LTTng depends). (patch
> below)
> 
> This is _very_ silly because there is no dependency on the syscall being
> executed, and the syscall_entry/syscall_exit events are recorded at the
> _exact_ same time. Yes, I mean the _exact_ same time : using a clock
> which consists of atomic_add_return monotonic increments, it seems like
> ARM is able to return the _same_ value of an atomic increment return
> *twice* !! I think the atomic.h primitives are broken and that they
> allow concurrent modification of a given atomic variable by the pipeline.
> It sounds weird, and I hope I am not crazy (just getting into the ARM
> world..). ;) Any thoughts ? I'll try adding some barriers to see if it
> helps.

Hi Mathieu,

I am currently investigating a very similar behavior,
(syscall_entry/syscall_exit events having the exact same time in lttng).

However, I am using the CCNT (together with trace-clock-32-to-64.c) for
timestamping. This is, if I understand you correctly, a different clock
than the one you are using, not using atomic_add_return(). Thus, I
suspect that the reason for getting the exact same time for entry/exit
events might be something else than the clocks being broken. 

I have to admit that I cannot explain how it can happen though. Could it
be some weird problem in the lttng trace recording ?

best regards,

Viktor


