Return-Path: <linux-kernel-owner+w=401wt.eu-S1765021AbXGNUqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765021AbXGNUqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762762AbXGNUqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:46:46 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37318 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761595AbXGNUqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:46:45 -0400
Date: Sat, 14 Jul 2007 22:47:02 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: MLOCK_LIMIT needs PAGE_SIZE
Message-ID: <20070714204702.GA9378@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 448580132dc7f55493269bb850c2955df9c7d778 in Aug 2004 changed
MLOCK_LIMIT from (32*1024) to (8 * PAGE_SIZE):

        [PATCH] sane mlock_limit

        As David M-T points out, the default per-user mlock limit should
        be at least a single page.

linux/resource.h appears to be a userspace header. PAGE_SIZE is
unavailable because asm/page.h is not included.
Will an extra #include asm/page.h cause any trouble for kernel builds?
It currently gets included via linux/time.h -> linux/seqlock.h ->
linux/spinlock.h -> something.

Userspace PAGE_SIZE will be discussed in another mail.
