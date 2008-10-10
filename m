Return-Path: <linux-kernel-owner+w=401wt.eu-S1762042AbYJJXen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762042AbYJJXen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 19:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYJJXef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 19:34:35 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:49525 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975AbYJJXef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 19:34:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAB5+70hMQWq+/2dsb2JhbACBcrp5gWw
Date: Fri, 10 Oct 2008 19:34:29 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: Michael Davidson <md@google.com>, Michael Rubin <mrubin@google.com>,
       Jan Blunck <jblunck@suse.de>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: LTTng new trace format, cleanup, kernel 2.6.27 support
Message-ID: <20081010233428.GA7035@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:52:53 up 128 days,  3:33,  6 users,  load average: 1.21, 0.81,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I just cleaned up the LTTng trace format heavily, got rid of the
heartbeat timer (by checking for overflow at the tracing site), got rid
of the "special" compact channel; it removed about 5 FIXMEs in LTTng
(cpu hotplug and compact channel related). Everything is compact now :

Event header is :

(32-bits alignment)
27-bits TSC
5-bits event ID
 ID #31 reserved to specify extended event ID
 ID #30 reserved to specify both ext. event ID and event size
 ID #29 reserved to specify ext. event ID, event size and ext. TSC
<ext.>
16-bits event ID (opt)
16-bits event size (opt) size = 65535 to specify large event size
32-bits large event size (opt)
64-bits TSC (opt) (aligned on sizeof (void *))
(event payload aligned on the maximum alignment required within the
 payload)

This is much more compact than the previous format, and permits a
"tracer debug mode" in menuconfig which enables the "event size" field,
which helps cross-checking the size expected by the userspace tool and
the size written by the kernel.

Note that this "event size" field can eventually be enabled on a
per-event or per-channel basis. This will probably be useful to encode
"binary blobs"...

I also cleanup up the subbuffer header to make is much smaller than the
previous one by removing unneeded information.

I renamed the "facilities" channel to a better name : "metadata".  It
contains marker descriptions.

The trace major number is bumped to "2" and is completely incompatible
with old LTTV. New version are LTTng 0.38 (for Linux 2.6.27) and LTTV
0.11.0.

Testing especially taking traces and reading them across different
architectures is welcome (e.g. trace taken on powerpc 32, lttv running
on x86_64).

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
