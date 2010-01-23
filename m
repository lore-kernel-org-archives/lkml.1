Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236Ab0AWAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0AWAHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621Ab0AWAG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:06:59 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:48137 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab0AWAG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:06:57 -0500
Message-ID: <4B5A3D00.8080901@bx.jp.nec.com>
Date: Fri, 22 Jan 2010 19:04:16 -0500
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: lwoodman@redhat.com, linux-mm@kvack.org, mingo@elte.hu, tzanussi@gmail.com,
       riel@redhat.com, rostedt@goodmis.org, akpm@linux-foundation.org,
       fweisbec@gmail.com, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Subject: [RFC PATCH -tip 0/2 v2] pagecache tracepoints proposal
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is v2 of a patchset to add some tracepoints for pagecache.

I would propose several tracepoints for tracing pagecache behaviors and
a script for these.
By using both the tracepoints and the script, we can monitor pagecache usage
with high resolution. Example output of the script looks like:

[file list]
                            cached
        device      inode    pages
  --------------------------------
         253:0    1051413      130
         253:0    1051399        2
         253:0    1051414       44
         253:0    1051417      154

o postmaster-2330
                            cached    added  removed      indirect
        device      inode    pages    pages    pages removed pages
  ----------------------------------------------------------------
         253:0    1051399        0        2        0             0
         253:0    1051417      154        0        0             0
         253:0    1051413      130        0        0             0
         253:0    1051414       44        0        0             0
  ----------------------------------------------------------------
  total:                       337        2        0             0

We can now know system-wide pagecache usage by /proc/meminfo.
But we have no method to get higher resolution information like per file or
per process usage than system-wide one.
A process may share some pagecache or add a pagecache to the memory or
remove a pagecache from the memory.
If a pagecache miss hit ratio rises, maybe it leads to extra I/O and
affects system performance.

So, by using the tracepoints we can get the following information.
 1. how many pagecaches each process has per each file
 2. how many pages are cached per each file
 3. how many pagecaches each process shares
 4. how often each process adds/removes pagecache
 5. how long a pagecache stays in the memory
 6. pagecache hit rate per file

Especially, the monitoring pagecache usage per each file would help us tune
some applications like database.

Changelog since v1
o Add a script based on "perf trace stream scripting support".

Any comments are welcome.
--
Keiichi Kii <k-keiichi@bx.jp.nec.com>


