Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYKTLIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYKTLIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYKTLH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:07:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57330 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbYKTLH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:07:56 -0500
Message-ID: <4925445C.10302@cn.fujitsu.com>
Date: Thu, 20 Nov 2008 19:05:00 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       Hirokazu Takahashi <taka@valinux.co.jp>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 0/7] introduce bio-cgroup into io-throttle
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

For the moment, io-throttle can trace buffered-io by means of memcg. This 
patchset introduces bio-cgroup into io-throttle, and splits it from memcg.
For the current implemetation, there are two ways can be used to trace
buffered-io. The first is mount io-throttle and bio-cgroup together.
This is a aggressive way, because there might have some troubles if other
subsystem also want to use bio-cgroup.
The other way is more gentle, io-throttle can use the bio-cgroup id to 
associate with a given bio-cgroup. If an association is created, synchronization 
between two groups will be performed automatically. This means if one task
adds into or removes from an associated bio-cgroup group, the corresponding 
io-throttle group will also add or remove this task.
If one io-throttle associates with a bio-cgroup group, tasks moving in this 
io-throttle group is forbidden.
A new io-throttle file blockio.bio_id is added. This file is used to create or remove an 
association. blockio.bio_id accessing in root hierarchy is not allowed. Following command
is valid.
$echo 1 > /mnt/throttle/group1/blockio.bio_id (associate this io-throttle group with bio-cgroup 1)
$echo -1 > /mnt/throttle/group1/blockio.bio_id (remove association between this io-throttle group and bio-cgroup 1)

One bio-cgroup group can't be associated twice. If you do so, error message will show.
If io-throttle has been mounted with bio-cgroup, all blockio.bio_id related actions are of no effect.

Dependency checking callback is introduced into cgroup.
You can't mount io-throttle with other subsystems except bio-cgroup. Beacuse other subsystem might break
the association between io-throttle and bio-cgroup.

This patchset is against 2.6.28-rc2-mm1.

-- 
Regards
Gui Jianfeng






