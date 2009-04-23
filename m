Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZDWM1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZDWM1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZDWM1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:27:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:38548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZDWM1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:27:20 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Subject: [RFC PATCHSET linux-2.6-block#for-2.6.31] block: lld cleanup patches
Date: Thu, 23 Apr 2009 21:25:41 +0900
Message-Id: <1240489553-15724-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 12:26:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a RFC patchset.  Please do NOT pull directly from the git
tree.

This patchset contains block lld cleanups and is consisted of the
following 12 patches.

 0001-block-update-end_cur.patch
 0002-block-don-t-init-rq-fields-unnecessarily.patch
 0003-amiflop-ataflop-xd-mg_disk-clean-up-unnecessary-stu.patch
 0004-ps3disk-simplify-request-completion.patch
 0005-sunvdc-kill-vdc_end_request.patch
 0006-ubd-cleanup-completion-path.patch
 0007-ubd-drop-unnecessary-rq-sector-manipulation.patch
 0008-hd-clean-up-request-completion-paths.patch
 0009-swim3-clean-up-request-completion-paths.patch
 0010-swim-clean-up-request-completion-paths.patch
 0011-mg_disk-fold-mg_disk.h-into-mg_disk.c.patch
 0012-mg_disk-clean-up-request-completion-paths.patch

0001 fixes a stupid mistake while implementing blk_request_end_cur()
and 0002 and 0003 are pretty straight forward cleanup.  Please feel
free to apply these three patches.

0004-0012 are cleanup patches for various block low level drivers
mostly focusing on completion paths.  The biggest change is use of
standard block layer mechanisms for partial completion instead of
doing it by manipulating request directly.  All the touched drivers
are only compile tested.

I'm planning on testing hd, xd and um but can't test others.  Can you
guys please verify the following drivers work?

 ps3disk, sunvdc, swim3, swim and mg_disk.

The following git tree can be used for testing.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git rfc-block-lld-cleanup

Thanks.

--
tejun
