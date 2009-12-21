Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbZLUBWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbZLUBWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbZLUBWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:22:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54868 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756454AbZLUBWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:22:01 -0500
Message-ID: <4B2ECD47.7040202@cn.fujitsu.com>
Date: Mon, 21 Dec 2009 09:20:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: BUG: different symbol address between System.map and /proc/kallsyms
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The symbol address in System.map and /proc/kallsys is different:

# cat System.map | grep _text
  c1000000 T _text
# cat /proc/kallsyms | grep _text
  c0100000 T _text

# readelf -s vmlinux | grep _text
35078: c1000000     0 NOTYPE  GLOBAL DEFAULT    1 _text

So, perf can't get sysmbol address properly:

# ./perf report
# Samples: 29
#
# Overhead  Command        Shared Object  Symbol
# ........  .......  ...................  ......
#
    93.10%    sleep             c014f988  [k] 0x000000c014f988
     3.45%    sleep  libc-2.9.90.so       [.] _int_malloc
     3.45%    sleep  [kernel]             [k] 0x000000c014f988
