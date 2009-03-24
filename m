Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZCXB3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZCXB3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 21:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZCXB2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 21:28:53 -0400
Received: from [222.92.8.141] ([222.92.8.141]:45830 "EHLO lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbZCXB2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 21:28:53 -0400
Message-ID: <9313.222.92.8.142.1237857995.squirrel@mail.lemote.com>
Date: Tue, 24 Mar 2009 09:26:35 +0800 (CST)
Subject: [ rt-preempt for mips ] basically is okay on linux-2.6.29-rc6
From: =?gb2312?Q?=CE=E2=D5=C2=BD=F0?= <wuzj@lemote.com>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, all

I have migrated rt-preempt for linux-2.6.29-rc6 to loongson2f(
a mipsel compatible processor), and have tried to port ftrace
and perf_counter to it too.

currently, the status is like this:

1. basic rt-preempt

have tested on fuloong box(a loongson2f based PC) and qemu/mips(malta)
the worst case jitter testing result on fuloong box is about:

0 load: < 29us
100%load(running several "find / > /dev/null" background): < 130 us

2. ftrace for mips

have implemented the following new options for mips including 32bit/64bit,
little/big endianness(in reality loongson2f only support little endianness).

config MIPS
    bool
    default y
    select HAVE_IDE
    select HAVE_OPROFILE
+   select HAVE_FTRACE_MCOUNT_RECORD
+   select HAVE_DYNAMIC_FTRACE
+   select HAVE_FUNCTION_GRAPH_TRACER
+   select HAVE_FUNCTION_TRACER

and also, a new precise ring_buffer_time_stamp for mips have implemented
via adding the cycles from the last timer interrupt(have consider rollover
too).  and also, the cpu_clock called in "function graph tracer" have been
replaced to this new ring_buffer_time_stamp to get precise duration
information.

I have tested it on loongson2f and also qemu/mips(malta), including the 32bit
and 64bit one, all of them seems okay.

3. perf_counter for loongson2f

loongson2f has only two hardware performance counters, which can be set to
count 2 different events simultaneously, but there is only one enable/disable
bit in a relative control register. currently,the basic function for counting
the general events(hard coded in kernel) and the raw events is okay, but not
support two different hardware events simultaneously which need to be fixed
later.

now, a fix on perf_counter for loongson2f need to do, and I'm working on
tunning the rt-performance via ftrace and kgcov.

I hope a patch to the official rt-preempt can be released one or two weeks
later.

best regards,
Wu Zhangjin, Lemote.com, China

