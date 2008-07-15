Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbYGOUlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbYGOUlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYGOUk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:40:56 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:58560 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYGOUkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZmZeBvgeJUgkoe/dh7uQNSWp/E918LG0iXy/81C9ZwuLM4lELny6syVZnqt5vv4KYu
         xdHcki+Cfk5a1UOThUhKA+PTBh/WRWhBaoxtchsS8+nv6xGxuIeRZUzCVOpdGP3MxAxw
         fZ3aurev9jtZ65s19++ALmrL6rODTvvBucjok=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org
Cc: Li Zefan <lizf@cn.fujitsu.com>, Carl Henrik Lunde <chlunde@ping.uio.no>,
       axboe@kernel.dk, matt@bluehost.com, roberto@unbit.it,
       Marco Innocenti <m.innocenti@cineca.it>, randy.dunlap@oracle.com,
       Divyesh Shah <dpshah@google.com>, subrata@linux.vnet.ibm.com,
       eric.rannaud@gmail.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/3] cgroup: block device i/o bandwidth controller (v6)
Date: Tue, 15 Jul 2008 22:40:46 +0200
Message-Id: <1216154449-29742-1-git-send-email-righi.andrea@gmail.com>
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

Changelog: (v5 -> v6)
  - do not make kernel threads to sleep
  - do not throttle i/o for pages that need to be urgently reclaimed in
    submit_bio(READ, ...) (i.e. tasks such as pdflush and kswapd when
    performing writeout)
  - minor fixes and improvements (thanks to Li Zefan review)
  - fixed a small typo in the documentation (reported by Marco Innocenti)

TODO:
  - see documentation

-Andrea
