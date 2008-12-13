Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbYLMVrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbYLMVrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 16:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYLMVq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 16:46:59 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:33187 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbYLMVq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 16:46:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAOm7Q0lMROB9/2dsb2JhbACBbM0vgn0
Date: Sat, 13 Dec 2008 16:46:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: LTTng 0.66 (dynamic channel allocation, markers modifications)
Message-ID: <20081213214646.GA23687@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:30:37 up 26 days, 22:11,  5 users,  load average: 1.70, 0.81,
	0.61
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just finished a big development iteration on LTTng/markers. It updates
the following tools :

LTTng 0.66, ltt-control 0.60, LTTV 0.12.0

And it changes the trace version number to 2.3.

Those were the last major changes I had to do to LTTng before releasing
it to LKML. It includes :

- Dynamic allocation of channels.
- Channels are declared in a supplementary marker parameter.
- Event IDs are now managed by the marker infrastructure.
- Event IDs are now dynamically allocated per-channel.

With these changes, changing any tracer so it uses the LTTng buffering
mechanism becomes as trivial as declaring a marker (DECLARE_MARKER())
and using the reference to the marker structure in a probe callback to
send the information into LTTng trace buffers. Many traces can be active
at once, each with their own set of active channels. Therefore, a given
tracer might only want to enable its own channel and the metadata
channel so it only gets its own information.

So in the current marker implementation, the marker declaration is
responsible for associating a data source with a :

- Channel
- Event ID within this channel
- Field types (format string)

Currently, the last element missing is the ltt-ascii.ko kernel module
which pretty-prints the information from within the kernel. The trace
clock time-base might not be as shiny as people would want it to
(especially wrt non-synchronized TSCs), but it works. I guess I'll have
to give it another good look before I resubmit it though.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
