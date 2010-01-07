Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594Ab0AGCt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0AGCt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942Ab0AGCt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:49:59 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:46438 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0AGCt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:49:58 -0500
From: Miles Bader <miles@gnu.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tools/perf: "perf record" restricted to root in latest kernel?
References: <buopr5nol26.fsf@dhlpc061.dev.necel.com>
	<20100106205911.GC18919@ghostprotocols.net>
Reply-To: Miles Bader <miles@gnu.org>
System-Type: x86_64-unknown-linux-gnu
Blat: Foop
Date: Thu, 07 Jan 2010 11:49:34 +0900
In-Reply-To: <20100106205911.GC18919@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 6 Jan 2010 18:59:11 -0200")
Message-ID: <buovdfeocht.fsf@dhlpc061.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo <acme@infradead.org> writes:
>> Next I updated to the latest linus tree (c5974b835a), and recompiled perf.
>> It still seems to work, and has obviously had a lot of features added, but
>> now it only wants to let me run "perf record" if I'm root.
>
> Don't recall noticing such problem, here it works just fine:
>
> [acme@doppio linux-2.6-tip]$ mkdir tmp
> [acme@doppio linux-2.6-tip]$ cd tmp
> [acme@doppio tmp]$ time perf record find ~/git/ > /dev/null
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.053 MB perf.data (~2312 samples) ]

Weird... if I try your recipe, I get:

   $ cd /usr/local/tmp
   $ ls
   gstlfilt.zip  q2.jpg  q3.jpg
   $ time perf record find /usr/local/src/git/ > /dev/null
     Fatal: Permission error - are you root?

   real	0m0.032s
   user	0m0.004s
   sys	0m0.012s

> [acme@doppio linux-2.6-tip]$ uname -r
> 2.6.33-rc3-tip+

Perhaps the newer version of perf works better with newer kernels, or
with some specific option enabled?  [Since it's a fairly new tool, I
suppose it may not work well unless the perf version and the kernel
version are in sync.]

I'm using a standard debian kernel:

   $ uname -r
   2.6.32-trunk-amd64

   $ grep PERF_ /boot/config-2.6.32-trunk-amd64 
   CONFIG_HAVE_PERF_EVENTS=y
   CONFIG_PERF_EVENTS=y
   # CONFIG_PERF_COUNTERS is not set
   # CONFIG_DEBUG_PERF_USE_VMALLOC is not set

I notice that the system call which results in an error for me changed
between the two versions of perf -- from "sys_perf_counter_open" to
"sys_perf_event_open" -- though I don't understand the difference.

Thanks,

-Miles

-- 
Youth, n. The Period of Possibility, when Archimedes finds a fulcrum,
Cassandra has a following and seven cities compete for the honor of endowing a
living Homer.
