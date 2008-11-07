Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYKGBIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYKGBIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYKGBI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:08:27 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:41369 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbYKGBI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:08:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAKcdE0lMQWxa/2dsb2JhbACBdso6g1Y
Date: Thu, 6 Nov 2008 20:08:22 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: LTTng 0.52, scheduler instrumentation
Message-ID: <20081107010821.GA23269@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:53:27 up 155 days,  5:33, 10 users,  load average: 1.33, 0.69,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released LTTng 0.52 for 2.6.27.4. It fixes the stuff I dreamt
about this morning. ;-)

Ingo what do you think about this first point ?

- I now only use 2 bytes to encode the task->state field in the trace.
  However it seems that 1 byte would be enough (bitmask of values 0 to
  127), except that -1 is used for "unrunnable". But when it's
  unrunnable, it should "never" be reach scheduler events, right ?

Changelog :
- Add kernel command line : force_tsc_sync=1 to force tsc
  synchronization at boot.
- Supports AMD64 X2 box with unsynchronized TSCs very well. Includes
  a warning that tells users to try
  force_tsc_sync=1 idle=poll and to disable PowerNow or Speedstep to get
  synchronized timestamp counters on x86. This workaround works very
  well.
- Default to no LTT alignment for traces if
  HAVE_EFFICIENT_UNALIGNED_ACCESS is selected.
- Fixed mixed up irq entry field names in (appeared in 0.51).

Some testing would be required with virtualization to see how it
behaves.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
