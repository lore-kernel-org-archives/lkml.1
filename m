Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZHXH5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZHXH5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZHXH5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:57:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45600 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbZHXH5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:57:04 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCH 0/7] Lazy workqueues v2
Date: Mon, 24 Aug 2009 09:56:49 +0200
Message-Id: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version #2 of the lazy workqueue patchset. Changes since
the initial (v1) posting:

- Attempt to close a few of the races with exiting threads. I have
  not completely audited it yet, but it should be a lot better now
  at least.

- Fix a bug with wq barrier work not setting CPU correctly.

- Fix a bug with remote work sometimes being completed on both the
  local and remote workqueue thread.

- Fix a compile error introduced with LOCKDEP enabled.

- Make the sleep schedule timeout be 1 jiffy longer than the lazy
  exit interval, otherwise we would be going through two sleep cycles
  without doing anything before the thread would be deemed OK to exit.

- One more conversion to lazy workqueues (bio-integrity).

Patches are against 2.6.31-rc7.

-- 
Jens Axboe

