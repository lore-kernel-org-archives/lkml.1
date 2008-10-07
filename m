Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYJGKD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYJGKD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYJGKDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:03:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:37289 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYJGKDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ecEqSRYkqdFpZsWhBV9W5juO324zWUfMgWOGM/UmTNNXX03q1D4ErmIb0J82QKHaUX
         cw3j1rX0LayH0qDITnLczM1XaM1AiA/pcP+RNzeNFIfFsCK3nRkMBMQ1U+9TbxKp2Fy7
         oyvcBYKQsqrNn8S7ONntX9QQH6uCooEy1WVIg=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>
Cc: agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       Hirokazu Takahashi <taka@valinux.co.jp>, Li Zefan <lizf@cn.fujitsu.com>,
       Marco Innocenti <m.innocenti@cineca.it>, matt@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/6] cgroup: block device i/o controller (v11)
Date: Tue,  7 Oct 2008 12:03:32 +0200
Message-Id: <1223373818-13687-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The objective of the i/o controller is to improve i/o performance
predictability of different cgroups sharing the same block devices.

Respect to other priority/weight-based solutions the approach used by this
controller is to explicitly choke applications' requests that directly (or
indirectly) generate i/o activity in the system.

The direct bandwidth and/or iops limiting method has the advantage of improving
the performance predictability at the cost of reducing, in general, the overall
performance of the system (in terms of throughput).

Detailed informations about design, its goal and usage are described in the
documentation.

Patchset against 2.6.27-rc5-mm1:

  [PATCH 0/6] cgroup: block device i/o controller (v11)
  [PATCH 1/6] i/o controller documentation
  [PATCH 2/6] introduce ratelimiting attributes and functionality to res_counter
  [PATCH 3/6] i/o controller infrastructure
  [PATCH 4/6] memcg: interface to charge the right cgroup of asynchronous i/o activity
  [PATCH 5/6] i/o controller instrumentation: accounting and throttling
  [PATCH 6/6] export per-task i/o throttling statistics to userspace

The all-in-one patch (and previous versions) can be found at:
http://download.systemimager.org/~arighi/linux/patches/io-throttle/

There are no significant changes respect to v10, I've only implemented/fixed
some suggestions I received.

Changelog: (v10 -> v11)

* report per block device i/o statistics (total bytes read/written and iops)
  in blockio.stat for i/o limited cgroups
* distinct bandwidth and iops statistics: both in blockio.throttlecnt and
  /proc/PID/io-throttle-stat (suggested by David Radford)
* merge res_counter_ratelimit functionality into res_counter, to avoid code
  duplication (suggested by Paul Manage)
* use kernel-doc style for documenting struct res_counter attributes
  (suggested by Randy Dunalp)
* udpated documentation

Thanks to all for the feedback!
-Andrea
