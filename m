Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYJ1P06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYJ1P06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYJ1P0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:26:47 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:53086 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbYJ1P0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:26:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8EAH/LBklMQWro/2dsb2JhbACBdsg5g1A
Date: Tue, 28 Oct 2008 11:21:43 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: Jan Blunck <jblunck@suse.de>, Martin Bligh <mbligh@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com
Subject: Updated TODO list before releasing LTTng buffering to LKML
Message-ID: <20081028152143.GD1136@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:39:27 up 145 days, 19:19,  9 users,  load average: 0.80, 0.71,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Thanks for the steady work those past weeks. We are close to a
releasable result. I have been delighted to see people from Fujitsu
helping on various items in the past weeks. Thanks to all those who
report issues and/or provide patches.

Here is an updated Todo list before posting LTTng-buffering to LKML

Timestamping :

- Use kernel/time/tsc-sync.c in MIPS to detect unsync TSCs.
- Tweak kernel/time/tsc-sync.c so it supports sync detection between two
  CPUs so it can be used to replace arch/x86/kernel/tsc_sync.c
- I plan to leave the current cache-line bouncing time source for CPUs
  which have unsynched TSC, but to printk a warning telling the user to
  disabled freq. scaling and halt in idle to make sure the clocks are
  synchronized if he expects precise timestamping and good scalability
  to large number of nodes. Let's keep room for improvement on this
  aspect for later.


Markers :

- Tie the markers to event IDs and buffer name. That will permit to
  simplify a lot of stuff currently in ltt-marker-control.ko. It will
  also remove the need for a global event ID assignation, making it
  per-buffer (in LTTng terminology : per-channel).
  (will be done by myself soon)

- move ltt/ltt-marker-control.c /proc interface to debugfs
  I think we should integrate its directory tree to the new LTTng tracer
  debugfs API like this :

  /debugfs/ltt/events/buffer_name/marker_name/
    where we find files like :
    state
      write : 1/0 (on/off)
      read  : 1/0 (on/off)
    format
      read : marker format string

  (being done by Fujistsu)


LTTng tracer :

- Rip apart ltt/ltt-core.c and put it in ltt/ltt-tracer.c. This
  "builtin" part of LTTng can now sit in a module without any problem.
  This can be done because we have the markers to abstract all
  interactions with the tracer.
  (will be done by myself soon)

- switch ltt-control.ko (currently over netlink) to debugfs
  (being done by Fujistsu)

- Create a ltt-ascii.ko kernel module which merge-sorts the buffers and exports
  them to userspace through a debugfs file.
  (will be done by Fujistu)

- merge a simplified lttv in lttng
  (will be done by myself)

As always, feel free to indicate if you are willing to help on any of
these items. If you need some pointers to the current state of work for
a particular item, just ask and I'll give you the pointer to the patch
within the -lttng git tree.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
