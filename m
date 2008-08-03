Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbYHCWPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbYHCWPX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 18:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbYHCWPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 18:15:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:9073 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbYHCWPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 18:15:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cn1AKmQd0HjbjCJiaWi3NMOLMHx/raTd5LltwV6O31j+sQx4cP/kImTs9mAPg028YX
         23ZgGOdMvjc4f5xbt518bNVWPvRUHk14OYBgs0+yPsEx4FyhFGpMM/HSf1bIOdvNSdPY
         4P6aFDFgDSZ7R/9KkeqecQVEl/JEcRS3JzG78=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, Li Zefan <lizf@cn.fujitsu.com>,
       Carl Henrik Lunde <chlunde@ping.uio.no>, axboe@kernel.dk,
       matt@bluehost.com, roberto@unbit.it,
       Marco Innocenti <m.innocenti@cineca.it>, randy.dunlap@oracle.com,
       Divyesh Shah <dpshah@google.com>, subrata@linux.vnet.ibm.com,
       eric.rannaud@gmail.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/3] cgroup: block device i/o controller (v8)
Date: Mon,  4 Aug 2008 00:14:55 +0200
Message-Id: <1217801698-13438-1-git-send-email-righi.andrea@gmail.com>
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

Tested against 2.6.27-rc1-mm1.

The all-in-one patch (and previous versions) can be found at:
http://download.systemimager.org/~arighi/linux/patches/io-throttle/

Changelog: (v7 -> v8)
  - rebase to 2.6.27-rc1-mm1
  - implement token bucket iops/s throttling
  - in the cgroup filesystem blockio.bandwidth has been renamed to
    blockio.bandwidth-max and blockio.iops to blockio.iops-max
    (for the future we would like to have also blockio.bandwidth-min and
    blockio.iops-min and implement a mechanism to guarantee minimum performance
    levels as well)
  - token bucket rules can also be defined using the syntax:
    DEV:LIMIT:1 (instead of DEV:LIMIT:1:BUCKET-SIZE)
    In this case BUCKET-SIZE will be set equal to LIMIT (this is valid both for
    I/O bandwidth limiting and I/O operations limiting rules)
  - updated documentation

-Andrea
