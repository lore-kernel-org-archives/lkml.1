Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbXEJEXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbXEJEXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbXEJEXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:23:20 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1490 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbXEJEXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:23:18 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Definition of fairness (was Re: [patch] CFS scheduler, -v11)
Date: Wed, 9 May 2007 21:22:45 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEBIDLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070509180205.GA27462@in.ibm.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 09 May 2007 22:22:57 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 09 May 2007 22:22:57 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Ex: consider two equally important tasks T1 and T2 running on
> same CPU and
> whose execution nature is:
>
> 	T1 = 100% cpu hog
> 	T2 = 60% cpu hog (run for 600ms, sleep for 400ms)
>
> Over a arbitrary observation period of 10 sec,
>
> 	T1 was ready to run for all 10sec
> 	T2 was ready to run for 6 sec
>
> Over this observation period, how much execution time should T2 get,
> under a "fair" scheduler?

	Anywhere between 30% and 50% of the CPU is fair. There is nothing
particularly fair or unfair about how much credit you give an interactive
task. Less than 30% is unfair as the task is being punished for voluntarily
yielding. More than 50% is unfair as the task should not be entitled to more
than half the CPU if another task with equal static priority wants as much
CPU as possible.

	Slightly less than 30% or slightly more than 50% can also be reasonable due
to rounding or the scheduling interval beating against T2's internal timing.

	From a practical standpoint, we'd like such a task to get a bit more than
30%. How much more may reasonably depend on exactly what the sleep/run
interval is for the task. It would be unreasonable to expect a task to be
credited for sleeping for an entire day, but unreasonable to expect a task
to not get any credit for voluntarily yielding the CPU when it is later
ready-to-run.

	Typical UNIX schedulers bump a task's dynamic priority when it voluntarily
yields. As a result, it can pre-empty a CPU-burner when it later becomes
ready-to-run. This is intended more to reduce latency than to increase CPU
share. However, it should also have the effect of giving a polite task more
CPU than pure CPU-burned when it needs it. (That's only fair.)

	DS


