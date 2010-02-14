Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab0BNA2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 19:28:01 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:34388 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0BNA17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 19:27:59 -0500
From: Matt Helsley <matthltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/4] Check O_* flags set with fcntl() on anon_inode files.
Date: Sat, 13 Feb 2010 16:27:43 -0800
Message-Id: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anon_inode interfaces often do not support flags that can be set
by fcntl(). Right now using fcntl() to set these flags falsely
reports success for things like O_ASYNC yet SIGIO is not delivered.

I relied on the flags allowed by the syscalls that create
these files to determine the flags that are allowed to be set by
fcntl().

Each patch checks flags for one anonymous inode interface:

[PATCH 1/4] signalfd
[PATCH 2/4] timerfd
[PATCH 3/4] epoll
[PATCH 4/4] eventfd

I did not check the perf, kvm-vm, or kvm-vcpu uses of anon_inodes.

Cheers,
	-Matt Helsley
