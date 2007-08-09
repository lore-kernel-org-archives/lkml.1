Return-Path: <linux-kernel-owner+w=401wt.eu-S1763408AbXHIEaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408AbXHIEaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXHIEaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:30:46 -0400
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:36874 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977AbXHIEap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:30:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=jq6TPENKJytvcGsWfvUoo61POIxoAHqp3hPxNyTnwb/3PQIaclFi6NONXmBJNlCh;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000a01c7da3d$3f946ae0$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: Question: sched_rt.c : is RT check needed within a RT func? dequeue_task_rt() calls update_curr_rt() which checks for priority of RR or FIFO : 
Date: Wed, 8 Aug 2007 21:24:57 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec798357820c85d3480646dbb162b234ec07350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.93.14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) * Possible wasted stats overhead during dequeue..
sched_rt.c: 
Is RT check needed within a RT func? 
dequeue_task_rt() calls update_curr_rt() 
which checks for priority of RR or FIFO.

WITHIN..
static inline void update_curr_rt(struct rq *rq)

are the two lines..
if (!task_has_rt_policy(curr))
    return;

Generally if I am reading this right, then what
 RT task is neither FIFO or RR???

Thus, I think those two lines could be removed.

2) nit....
The comment within sched_rt.c
----->   Adding/removing a task to/from a priority array:
Is placed before dequeue_task_rt() where
enqueue_task_rt() is placed above the comment

Thus, the comment should be moved above enqueue_task_rt()

Mitchell Erblich




