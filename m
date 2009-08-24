Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZHXIyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZHXIyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZHXIyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:54:01 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:39582 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbZHXIyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:54:00 -0400
Date: Mon, 24 Aug 2009 17:54:02 +0900 (JST)
Message-Id: <20090824.175402.193692180.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 1/8] blkio-cgroup-v11: Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a new release of blkio-cgroup v11.

Changes:
- The function cgroup_get_from_page() is added which determines to
  which cgroup a given page belongs. This function is introduced from
  Vivek's io-controller patch. Thanks Vivek.
- Fix a type mismatch of the refcount of io_context. The refcount has
  been changed to atomic_long_t.

This patch can be applied to 2.6.31-rc7.

The list of the patches:
  [PATCH 1/8] blkio-cgroup-v11: Introduction
  [PATCH 2/8] blkio-cgroup-v11: The new page_cgroup framework
  [PATCH 3/8] blkio-cgroup-v11: Refactoring io-context initialization
  [PATCH 4/8] blkio-cgroup-v11: The body of blkio-cgroup
  [PATCH 5/8] blkio-cgroup-v11: Page tracking hooks
  [PATCH 6/8] blkio-cgroup-v11: The document of blkio-cgroup
  [PATCH 7/8] blkio-cgroup-v11: Add a cgroup support to dm-ioband
  [PATCH 8/8] blkio-cgroup-v11: The document of a cgroup support for dm-ioband

About blkio-cgroup:
blkio-cgroup is a block I/O tracking mechanism implemented on the
cgroup memory subsystem. Using this feature the owners of any type of
I/O can be determined. This allows dm-ioband to control block I/O
bandwidth even when it is accepting delayed write requests. dm-ioband
can find the cgroup of each request. It is also for possible that
others working on I/O bandwidth throttling to use this functionality
to control asynchronous I/O with a little enhancement.

Please visit our website, all-in-one-patch and more information are
available.
  Linux Block I/O Bandwidth Control Project
  http://sourceforge.net/apps/trac/ioband/

I'd like to get some feedbacks from the list. Any comments are
appreciated.

Thanks,
Ryo Tsuruta
