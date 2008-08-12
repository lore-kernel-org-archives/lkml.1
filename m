Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYHLPER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYHLPER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYHLPEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:04:05 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:41032 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbYHLPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:04:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADRAoUhMRKxB/2dsb2JhbACBYK1tgSk
Date: Tue, 12 Aug 2008 11:04:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: LTTng 0.16 for 2.6.27-rc2 (ftrace integration)
Message-ID: <20080812150401.GB11838@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:51:41 up 68 days, 19:32,  7 users,  load average: 5.08, 2.35,
	1.18
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released the latest LTTng version I used to pinpoint the "prove
locking correctness" latency issue. It integrates with ftrace (only the
dynamic function tracing part) with what I call a "tap".

See http://lkml.org/lkml/2008/8/5/321 to find out how I dug in this
problem.

Basically, a "tap" is a set of "enable/disable" probes one can connect
on specific markers/tracepoints. These probes enable/disable a "tap",
which controls recording of specific events to the trace.

Since dynamic function tracing is very high overhead, this tap mechanism
can be used to control the event flow to only trace the interesting code
areas. All markers named "tap_*" are also controlled by such mechanism.
By removing a comment from the ltt-armall script, one can use the tap to
enable lockdep event tracing.

See the new ltt-armtap and the modified ltt-armall scripts in the
ltt-control package for details.

New versions :

LTTng gitweb
http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=shortlog;h=2.6.27-rc2-lttng

LTTng Git tree
git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git 2.6.27-rc2-lttng

LTTng tarball
http://www.kernel.org/pub/linux/kernel/people/compudj/patches/2.6/2.6.27-rc2/lttng-2.6.27-rc2-0.16.tar.bz2

ltt-control
http://ltt.polymtl.ca/lttng/ltt-control-0.51-12082008.tar.gz

LTTV
http://ltt.polymtl.ca/packages/lttv-0.10.0-pre15-12082008.tar.gz


Testing, especially of the new tap scripts, is welcome.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
