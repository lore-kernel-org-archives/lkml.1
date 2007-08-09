Return-Path: <linux-kernel-owner+w=401wt.eu-S938656AbXHIFKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938656AbXHIFKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbXHIFKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:10:31 -0400
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:37739 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754190AbXHIFK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:10:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=fCnJpe72Md+rL7OnD1y7MuZHyPlLy9horgb+C4wCUgarkIOn88p3fl7rBQ1Eznp1;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <001001c7da42$8022a7c0$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: Question : sched_rt.c : Loss of stats?? requeue_task_rt() does not call update_curr_rt() which updates stats
Date: Wed, 8 Aug 2007 22:02:34 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec7941a9aa3d8bd76c78204a360faa68ce26350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.93.14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sched_rt.c : requeue_task_rt()

The comment states the problem requeue no dequeue.
Put task to the end of the run list without the overhead of dequeue
followed by enqueue.

dequeue_task_rt() updates stats. Where without calling
it will skip the stat update.

Thus, shouldn't  requeue_task_rt() call
  update_curr_rt(rq); ???

Mitchell Erblich.
