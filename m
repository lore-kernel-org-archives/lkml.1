Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZLWKOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZLWKOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZLWKO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:14:29 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56157 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbZLWKO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:14:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=FASFp6BlQS3y92Zft72y5Fd8OEwtxvIFAnJvFd+x0oi52Z8KK8oEctm6hFDUKKosf/
         QbgfuuDv0bQHUlF7U1hJ1uJVJcIJdmHHYV1ut7RRWXNVG/YjRLyVWHjMSJNflkJXutvO
         eJs6uPvL1cP/m/j2EUfzgcnn/HtMyyVNIlhDw=
MIME-Version: 1.0
Date: Wed, 23 Dec 2009 16:14:27 +0600
Message-ID: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
Subject: SCHED: Is task migration necessary in sched_exec().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Is task migration necessary in sched_exec()?

 In sched_exec function's comment it says:

 "sched_exec - execve() is a valuable balancing opportunity, because at
  this point the task has the smallest effective memory and cache footprint."

Right, but - when a execve() is called then this task will start execution (that
means this task will not waiting on the runqueue as TASK_RUNNING/WAKING,
it will get the CPU). At this point - what is the necessity to try
making it balance.
By looking at point of "smallest effective memory and cache footprint" , we are
missing the point that we are unnecessarily pushing task when its
about to execute.

Isn't it? Or I'm missing anything?


Rakib,
