Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZKXF0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZKXF0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZKXF0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:26:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53211 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbZKXF0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:26:00 -0500
Message-ID: <4B0B6E44.6090106@cn.fujitsu.com>
Date: Tue, 24 Nov 2009 13:25:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 0/5] perf kmem: Add more functions and show more statistics
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

List of new things:

- Add option "--raw-ip", to print raw ip instead of symbols.

- Sort the output by fragmentation by default, and support
  multi keys.

- Collect and show cross node allocation stats.

- Collect and show alloc/free ping-pong stats.

- And help file.

---
 tools/perf/Documentation/perf-kmem.txt |   44 ++++
 tools/perf/builtin-kmem.c              |  353 ++++++++++++++++++++++++++------
 tools/perf/command-list.txt            |    1 +
 3 files changed, 331 insertions(+), 67 deletions(-)


Pekka, do you think we can remove kmemtrace now?

With kmem trace events, low-level analyzing can be done using
ftrace, and high-level analyzing can be done using perf-kmem.

And chance is, more people may use and improve perf-kmem, and it
will be well-maintained within the perf infrastructure. On the
other hand, I guess few people use and contribute to kmemtrace-user.

BTW, seems kmemtrace-user doesn't work with ftrace. I got setfault:

	# ./kmemtraced
	Copying /proc/kallsyms...
	Logging... Press Control-C to stop.
	^CSegmentation fault


