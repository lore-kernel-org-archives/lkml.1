Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYGLLbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYGLLbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 07:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYGLLbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 07:31:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:4358 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbYGLLbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 07:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RCdZbrp9WiClpBkuwfA5pvXXHu6qYsm2t0wK5cF25rhjlPUMLzIm9EHBQHp+mBzguR
         4fjOrqZRRfjYrxzxi80naSxsHMe8RIztK9STkHHDVgiq0FcOmG8HuQ9ZAIeKqSg1JEUv
         IWKHmPnkf3pXX1dgcwX1KokaeCbZ1SpTIQwrg=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org
Cc: Li Zefan <lizf@cn.fujitsu.com>, Carl Henrik Lunde <chlunde@ping.uio.no>,
       axboe@kernel.dk, matt@bluehost.com, roberto@unbit.it,
       randy.dunlap@oracle.com, Divyesh Shah <dpshah@google.com>,
       subrata@linux.vnet.ibm.com, eric.rannaud@gmail.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/3] cgroup: block device i/o bandwidth controller (v5)
Date: Sat, 12 Jul 2008 13:31:28 +0200
Message-Id: <1215862291-26719-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The objective of the i/o bandwidth controller is to improve i/o performance
predictability of different cgroups sharing the same block devices.

Respect to other priority/weight-based solutions the approach used by this
controller is to explicitly choke applications' requests that directly (or
indirectly) generate i/o activity in the system.

The direct bandwidth limiting method has the advantage of improving the
performance predictability at the cost of reducing, in general, the overall
performance of the system (in terms of throughput).

Detailed informations about design, its goal and usage are described in the
documentation.

Tested against 2.6.26-rc8-mm1.

The all-in-one patch (and previous versions) can be found at:
http://download.systemimager.org/~arighi/linux/patches/io-throttle/

Thanks to Li Zefan for reviewing.

Changelog: (v4 -> v5)
  - rebase to 2.6.26-rc8-mm1
  - handle AIO opportunely: return -EAGAIN from sys_io_submit(), instead of
    making to sleep tasks doing AIO
  - userspace=>kernel interface now accepts the following syntaxes:
    * dev:0                       <- to delete a limiting rule
    * dev:bw-limit:0              <- define a leaky bucket throttling rule
    * dev:bw-limit:1:bucket-size  <- define a token bucket throttling rule
  - use .write_string and .read_seq_string to simplify iothrottle_read() and
    iothrottle_write() functions
  - use a enum structure to enumerate the various throttling algorithms

TODO:
  - see documentation

-Andrea
