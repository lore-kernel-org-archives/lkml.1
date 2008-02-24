Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbYBXDIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbYBXDIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 22:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYBXDIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 22:08:42 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:19635 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYBXDIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 22:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XfyITC4sRzFvI4PgnRbkyStWfdWR+cZrua/cC14H4m73Lyt3Xfku/aVSPhfnIoaLDREm6BKf5dfrxpjKAXpz5mx0osqmNNK5HgBb6IrRWNZ+LUyZ6mVC7mpUCE9/dkCWa5D7UU/VQs+spKUyRp5n4qE/tC4EOAcloL4Tyrl84PQ=
Message-ID: <998d0e4a0802231908h37978d07wa5379d5c01b2c2ee@mail.gmail.com>
Date: Sun, 24 Feb 2008 04:08:38 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Please, put 64-bit counter per task and incr.by.one each ctxt switch.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We will need 64 bit counters of the slow context switches,
  one counter for each new created task (e.g. u64 ctxt_switch_counts;)

We will only need them during the lifetime of the tasks.

To increment by +1 the task's 64 bit counter (it's fast)
  each one slow context switch.

*kernel/sched.c:
void context_switch(...) { ... } # incr. +1 here.
void wake_up_new_task(...) { ... } # ->ctxt_switch_counts = 0ULL;

*include/linux/sched.h:
struct task_struct { ... } # add 64-bit (u64 ctxt_switch_counts;) here.

Please, do it and we can do it better than CFS fair scheduler.

I will explain your later why of it.

   O:)
