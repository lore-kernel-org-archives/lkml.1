Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZG1MMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZG1MMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZG1MMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:12:21 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:56176 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbZG1MMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:12:20 -0400
Date: Tue, 28 Jul 2009 21:09:34 +0900 (JST)
Message-Id: <20090728.210934.193696111.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 1/7] blkio-cgroup-v10: Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a new release of blkio-cgroup v10. This release reduces
IO tracking overhead and fixes an issue that could cause a deadlock
since lock_page_cgroup() is no longer used.
Thank you KAMEZAWA-san for your suggestions and pointing out the issue.

This patch can be applied to 2.6.31-rc3-mmotm0716 and 2.6.31-rc4.

The list of the patches:
  [PATCH 1/7] blkio-cgroup-v10: Introduction
  [PATCH 2/7] blkio-cgroup-v10: The new page_cgroup framework
  [PATCH 3/7] blkio-cgroup-v10: Refactoring io-context initialization
  [PATCH 4/7] blkio-cgroup-v10: The body of blkio-cgroup
  [PATCH 5/7] blkio-cgroup-v10: The document of blkio-cgroup
  [PATCH 6/7] blkio-cgroup-v10: Page tracking hooks
  [PATCH 7/7] blkio-cgroup-v10: Add a cgroup support to dm-ioband

About blkio-cgroup:
blkio-cgroup is a block I/O tracking mechanism implemented on the
cgroup memory subsystem. Using this feature the owners of any type of
I/O can be determined. This allows dm-ioband to control block I/O
bandwidth even when it is accepting delayed write requests. dm-ioband
can find the cgroup of each request. It is also for possible that
others working on I/O bandwidth throttling to use this functionality
to control asynchronous I/O with a little enhancement.

Please visit our website, the patches and more information are available.
  Linux Block I/O Bandwidth Control Project
  http://sourceforge.net/apps/trac/ioband/

I'd like to get some feedbacks from the list. Any comments are
appreciated.

Thanks,
Ryo Tsuruta
