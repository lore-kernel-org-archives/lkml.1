Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYGDN7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYGDN7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbYGDN7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:59:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:16804 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbYGDN7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xil9BhlmEmjeedMwCx+8ug9f0WsotdWxfoh565Cmg+m8hivx1ucz6Jpvcj4F/RJ7bU
         1wyMygoYR0Wy5UA/4rDJxQQNYs/5jrS+48sYWmXFCSI4SlmeC1GxfUd6H6OYalZx2fDf
         YnYcbnfTd3EF5fnlLLCrEnnwyTLeWoLqdvbeM=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>
Cc: Carl Henrik Lunde <chlunde@ping.uio.no>, axboe@kernel.dk,
       matt@bluehost.com, roberto@unbit.it, randy.dunlap@oracle.com,
       Divyesh Shah <dpshah@google.com>, subrata@linux.vnet.ibm.com,
       eric.rannaud@gmail.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] cgroup: block device i/o bandwidth controller (v4)
Date: Fri,  4 Jul 2008 15:58:45 +0200
Message-Id: <1215179928-9767-1-git-send-email-righi.andrea@gmail.com>
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

Tested against latest git (2.6.26-rc8).

The all-in-one patch (and previous versions) can be found at:
http://download.systemimager.org/~arighi/linux/patches/io-throttle/

Most of the changes in v4 are based on the Andrew Morton's review of patchset
v3. Thanks Andrew.

Changelog: (v3 -> v4)
  - avoid potential deadlock in __set_page_dirty() with CONFIG_PREEMPT=n
  - do not treat partitions as separate block devices: only entire block
    devices are allowed to define i/o throttling rules; moreover, i/o activity
    on partitions is accounted to opportune entire block device they belong to.
  - reworked userspace<->kernel interface: accept and store all values in
    bytes/sec (a userspace front-end application will take care of properly
    showing and accepting values in human-readable format)
  - uninlined a lot of functions
  - code formatting fixes
  - more documentation

Todo:
  - see documentation

-Andrea
