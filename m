Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYBGJUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYBGJUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYBGJUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:20:05 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18476 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYBGJUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:20:00 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com, npiggin@suse.de
Subject: [PATCH 0/8] IO queuing and complete affinity
Date: Thu,  7 Feb 2008 10:18:57 +0100
Message-Id: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.22.g7a20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since I'll be on vacation next week, I thought I'd send this out in
case people wanted to play with it. It works here, but I haven't done
any performance numbers at all.

Patches 1-7 are all preparation patches for #8, which contains the
real changes. I'm not particularly happy with the arch implementation
for raising a softirq on another CPU, but it should be fast enough
so suffice for testing.

Anyway, this patchset is mainly meant as a playground for testing IO
affinity. It allows you to set three values per queue, see the files
in the /sys/block/<dev>/queue directory:

completion_affinity
	Only allow completions to happen on the defined CPU mask.
queue_affinity
	Only allow queuing to happen on the defined CPU mask.
rq_affinity
	Always complete a request on the same CPU that queued it.

As you can tell, there's some overlap to allow for experimentation.
rq_affinity will override completion_affinity, so it's possible to
have completions on a CPU that isn't set in that mask. The interface
is currently limited to all CPUs or a specific CPU, but the implementation
is supports (and works with) cpu masks. The logic is in
blk_queue_set_cpumask(), it should be easy enough to change this to
echo a full mask, or allow OR'ing of CPU masks when a new CPU is passed in.
For now, echo a CPU number to set that CPU, or use -1 to set all CPUs.
The default is all CPUs for no change in behaviour.

Patch set is against current git as of this morning. The code is also in
the block git repo, branch is io-cpu-affinity.

git://git.kernel.dk/linux-2.6-block.git io-cpu-affinity

-- 
Jens Axboe



