Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbZINM2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbZINM2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZINM2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:28:11 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:53237 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbZINM2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:28:03 -0400
Date: Mon, 14 Sep 2009 21:28:05 +0900 (JST)
Message-Id: <20090914.212805.193688121.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@redhat.com
Subject: [PATCH 1/9] I/O bandwidth controller and BIO tracking
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

These are new releases of dm-ioband and blkio-cgroup. The major change
of these releases is that a hierarchical configuration is supported,
a parent cgroup's bandwidth is distributed to its children. The
hierarchical configuration is available when using dm-ioband and
blkio-cgroup together. Please refer to the documentation included in 
this series of patches on how to use it.

The summary of the changes are below:
dm-ioband v1.13.0
  - Introduce a hierarchical grouping mechanism for blkio-cgroup.
  - Change the dmsetup status outputs to be similar to 
    /proc/diskstats and /sys/block/dev/stat files.
blkio-cgroup v12
  - dm-ioband can be configured in a hierarchical manner through the
    cgroup interface.
  - blkio.stat file is added which shows IO statistics per cgroup.

TODO
  - Borrowing and lending bandwidth between a parent and children if
    spare bandwidth is available in them.

These patches can be applied to kernel 2.6.31

The list of the patches:
  [PATCH 1/9] I/O bandwidth controller and BIO tracking
  [PATCH 2/9] dm-ioband-1.13.0: All-in-one patch
  [PATCH 3/9] blkio-cgroup-v12: The new page_cgroup framework
  [PATCH 4/9] blkio-cgroup-v12: Refactoring io-context initialization
  [PATCH 5/9] blkio-cgroup-v12: The body of blkio-cgroup
  [PATCH 6/9] blkio-cgroup-v12: Page tracking hooks
  [PATCH 7/9] blkio-cgroup-v12: The document of blkio-cgroup
  [PATCH 8/9] blkio-cgroup-v12: Add a cgroup support to dm-ioband
  [PATCH 9/9] blkio-cgroup-v12: The document of a cgroup support for dm-ioband

About dm-ioband
  dm-ioband is an I/O bandwidth controller implemented as a
  device-mapper driver and can control bandwidth on per partition, per
  user, per process, per virtual machine (such as KVM or Xen) basis.

About blkio-cgruop
  blkio-cgroup is a block I/O tracking mechanism implemented on the
  cgroup memory subsystem. Using this feature the owners of any type
  of I/O can be determined. This allows dm-ioband to control block I/O
  bandwidth even when it is accepting delayed write requests.
  dm-ioband can find the cgroup of each request. It is also for
  possible that others working on I/O bandwidth throttling to use this
  functionality to control asynchronous I/O with a little enhancement.

Please visit our website, the patches and more information are available.
  Linux Block I/O Bandwidth Control Project
  http://sourceforge.net/apps/trac/ioband/

I'd like to get some feedbacks from the list. Any comments are
appreciated.

Thanks,
Ryo Tsuruta
