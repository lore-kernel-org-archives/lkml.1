Return-Path: <linux-kernel-owner+w=401wt.eu-S1761461AbYGODL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461AbYGODL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYGODLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:11:49 -0400
Received: from ozlabs.org ([203.10.76.45]:36064 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbYGODLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:11:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] typesafe callbacks
Date: Tue, 15 Jul 2008 13:10:26 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151310.26412.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As featured in linux-next for at least two full revs, and posted here.
Allows (but doesn't require) various callbacks to be the correct type
instead of void *.

kthread and timers for the moment, stop_machine and request_irq are
blocked pending textual clashes.

Added __attribute__((printf)) to kthread_create to this batch: textual
conflicts otherwise.

Thanks,
Rusty.
===
The following changes since commit 50515af207d410c9f228380e529c56f43c3de0bd:
  David Woodhouse (1):
        firmware: Correct dependency on CONFIG_EXTRA_FIRMWARE_DIR

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (5):
      cast_if_type: allow macros functions which take more than one type.
      typesafe_cb: wrappers for typesafe callbacks.
      Label kthread_create() with printf attribute tag.
      typesafe: kthread_create and kthread_run
      typesafe: TIMER_INITIALIZER and setup_timer

 include/linux/compiler-gcc.h   |   18 ++++++++++++++++++
 include/linux/compiler-intel.h |    2 ++
 include/linux/kernel.h         |   35 +++++++++++++++++++++++++++++++++++
 include/linux/kthread.h        |   29 ++++++++++++++++++++++++++---
 include/linux/timer.h          |   32 +++++++++++++++++++++++---------
 kernel/kthread.c               |   29 +++++------------------------
 6 files changed, 109 insertions(+), 36 deletions(-)
