Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbYJKRa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbYJKRa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 13:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761012AbYJKRaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 13:30:09 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:38643 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761003AbYJKRaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 13:30:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAON58EhMQWq+/2dsb2JhbACBcrhVgWw
Date: Sat, 11 Oct 2008 13:25:02 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Michael Davidson <md@google.com>, Martin Bligh <mbligh@google.com>,
       Ingo Molnar <mingo@elte.hu>, Jan Blunck <jblunck@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] LTTng new trace format, cleanup, kernel 2.6.27
	support
Message-ID: <20081011172502.GA12718@Krystal>
References: <20081010233428.GA7035@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081010233428.GA7035@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:21:02 up 128 days, 22:01,  6 users,  load average: 0.36, 0.47,
	0.51
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just released LTTng 0.39 and lttv 0.11.1, trace format 2.1, which
fixes the subbuffer header 32-64 bits portability.

I do not use packed structures anymore since trace format 2.0 because
gcc generates inefficient code (at least on mips and powerpc). However,
I make sure the fields fall on their natural alignment within the
structure so the compiler does not have to add ABI-specific padding. I
also added a header_end[0] field at the end of the header to be able to
easily compute the header size without including any supplementary
padding the compiler would add at the end of the structure.

Mathieu

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> Hi everyone,
> 
> I just cleaned up the LTTng trace format heavily, got rid of the
> heartbeat timer (by checking for overflow at the tracing site), got rid
> of the "special" compact channel; it removed about 5 FIXMEs in LTTng
> (cpu hotplug and compact channel related). Everything is compact now :
> 
> Event header is :
> 
> (32-bits alignment)
> 27-bits TSC
> 5-bits event ID
>  ID #31 reserved to specify extended event ID
>  ID #30 reserved to specify both ext. event ID and event size
>  ID #29 reserved to specify ext. event ID, event size and ext. TSC
> <ext.>
> 16-bits event ID (opt)
> 16-bits event size (opt) size = 65535 to specify large event size
> 32-bits large event size (opt)
> 64-bits TSC (opt) (aligned on sizeof (void *))
> (event payload aligned on the maximum alignment required within the
>  payload)
> 
> This is much more compact than the previous format, and permits a
> "tracer debug mode" in menuconfig which enables the "event size" field,
> which helps cross-checking the size expected by the userspace tool and
> the size written by the kernel.
> 
> Note that this "event size" field can eventually be enabled on a
> per-event or per-channel basis. This will probably be useful to encode
> "binary blobs"...
> 
> I also cleanup up the subbuffer header to make is much smaller than the
> previous one by removing unneeded information.
> 
> I renamed the "facilities" channel to a better name : "metadata".  It
> contains marker descriptions.
> 
> The trace major number is bumped to "2" and is completely incompatible
> with old LTTV. New version are LTTng 0.38 (for Linux 2.6.27) and LTTV
> 0.11.0.
> 
> Testing especially taking traces and reading them across different
> architectures is welcome (e.g. trace taken on powerpc 32, lttv running
> on x86_64).
> 
> Mathieu
> 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
