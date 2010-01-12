Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156Ab0ALKmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0ALKmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 05:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079Ab0ALKmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 05:42:36 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33764 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab0ALKmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 05:42:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=bBMxvKduDDItjHoeYfy9C6+Z4UYkSTAnt7DJI9IZzvMrcabCiUf4wr0zSzM9K09unz
         NsxR5QP7c2jUxK2IurJQg5iCqQqIgy+t0AyD4qRxKl3LPpIBP3/3ZQ0EucdOoUoiytSj
         ioDAZGTHOoCTilyrcHXKqdA7RIK+SOv2dn+5w=
MIME-Version: 1.0
Date: Tue, 12 Jan 2010 16:42:35 +0600
Message-ID: <b9df5fa11001120242p46fa3d07rc005cf314bf0fd32@mail.gmail.com>
Subject: [PATCH] sched: Move level 'again' after get_cpu() in sched_exec.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

            sched: move level again after get_cpu().

 We can get this_cpu by calling get_cpu() once and it remains
same. We don't need to call it again.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/kernel/sched.c	2010-01-06 20:11:10.000000000 +0600
+++ rakib/kernel/sched.c	2010-01-12 16:01:54.000000000 +0600
@@ -3143,8 +3143,8 @@ void sched_exec(void)
 	unsigned long flags;
 	struct rq *rq;

-again:
 	this_cpu = get_cpu();
+again:
 	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == this_cpu) {
 		put_cpu();
