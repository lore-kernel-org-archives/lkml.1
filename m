Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbYDBCTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbYDBCTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 22:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYDBCTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 22:19:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49414 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbYDBCSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 22:18:45 -0400
Message-ID: <47F2EC87.30205@cn.fujitsu.com>
Date: Wed, 02 Apr 2008 10:16:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: [PATCH -mm 0/3] cgroup: use hash table for css_set
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we attach a process to a different cgroup, the css_set linked-list
will be run through to find a suitable existing css_set to use. This
patch set uses a hash table for better performance.

As we add the hash table, we can totally remove the css_set linked-list.
When we have to run through the linked-list, we can run through the
hash table instead.

I tested the following benmarks:

For N in 1, 5, 10, 50, 100, 500, 1000, create N cgroups with one sleeping
task in each, and then move an additional task through each cgroup in
turn.

Here is a test result:

N	Loop	orig - Time(s)	hash - Time(s)
----------------------------------------------
1	10000	1.201231728	1.196311177
5	2000	1.065743872	1.040566424
10	1000	0.991054735	0.986876440
50	200	0.976554203	0.969608733
100	100	0.998504680	0.969218270
500	20	1.157347764	0.962602963
1000	10	1.619521852	1.085140172

Those patches are based on 2.6.25-rc5-mm1.

Regards,
Li Zefan
