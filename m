Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYGWMdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYGWMdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYGWMdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:33:44 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:56375 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYGWMdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:33:43 -0400
Message-ID: <488722DF.9080003@miraclelinux.com>
Date: Wed, 23 Jul 2008 21:23:59 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: menage@google.com
Subject: [RFC][PATCH][0/3] introduce rlimit cgroup
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.7.23.121701
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I think existing rlimit interface isn't useful.
So I created rlimit interface on cgroup.
Do you think this is a proper way todo it? (or Is there any similar methods already?)

usage
=======================================
# mkdir /dev/cgroup
# mount -t cgroup -o rlimit none /dev/cgroup
# ls /dev/cgroup
notify_on_release  release_agent  rlimit.limits  tasks
# cat /dev/cgroup/rlimit.limits
Number  Limit                  Soft Limit       Hard Limit       Unit
0       Max cpu time           unlimited        unlimited         ms
1       Max file size          unlimited        unlimited         bytes
2       Max data size          unlimited        unlimited         bytes
3       Max stack size         8388608          unlimited         bytes
4       Max core file size     0                unlimited         bytes
5       Max resident set       unlimited        unlimited         bytes
6       Max processes          16300            16300             processes
7       Max open files         1024             1024              files
8       Max locked memory      32768            32768             bytes
9       Max address space      unlimited        unlimited         bytes
10      Max file locks         unlimited        unlimited         locks
11      Max pending signals    16300            16300             signals
12      Max msgqueue size      819200           819200           bytes
13      Max nice priority       0                0
14      Max realtime priority   0                0
15      Max realtime timeout    unlimited        unlimited        us
# echo "1 100000000 200000000" > /dev/cgroup/rlimit.limits
# cat /proc/zero > /tmp/hoge
[1]    2854 file size limit exceeded  cat /dev/zero > /tmp/hoge







