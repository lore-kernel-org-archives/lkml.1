Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYIMKH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYIMKH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 06:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYIMKHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 06:07:19 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:49254 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755128AbYIMKHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 06:07:17 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: "karthikeyan S" <karthispeaks@gmail.com>
Cc: linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: Re: A bug (probably) in stop_all_threads
Date: Sat, 13 Sep 2008 20:07:04 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <o44nc4dd8tpl94vf9bv81oklq8lt29112t@4ax.com>
References: <3bedf6ab0809130127j7ed9d372pcb15e1b001178600@mail.gmail.com>
In-Reply-To: <3bedf6ab0809130127j7ed9d372pcb15e1b001178600@mail.gmail.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008 13:57:28 +0530, "karthikeyan S" <karthispeaks@gmail.com> wrote:

CC added.

>Hi,
>
>Apologies if I am posting this message in an incorrect mailing list
>and for bringing up an issue with older kernel version (2.4), and if
>the issue had been brought up earlier and I missed it.
>
>There seems to be a bug with stop_all_threads function in 2.4. The
>function sends SIGSTOP to all the threads in the thread group and
>waits until all the threads get their state changed accordingly.
>
>While waiting, if it finds that the event has not occurred, it tires
>to yield the processor to other processes by calling
>schedule_timeout().
>
>Bur before calling schedule_timeout() it does not set the task state
>to either TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE.
>So schedule_timeout() does not do anything effectively.
>
>This causes a problem in our device which uses kernel 2.4. When we
>have a sigsegv from the task which runs at highest priority, the
>control is stuck waiting for all the threads in the thread group to
>change their task state. But the other threads never get a chance to
>run and the SIGSTOP sent to them is of no effect.
>
>When  I changed the stop_all_threads function to set the task state to
>TASK_INTERRUPTIBLE, the problem disappears.
>
>So is this a real issue that stop_all_threads() does not set the
>current task to TASK_INTERRUPTIBLE before calling schedule_timeout()?
>
>Please provide your feedback. Thanks a lot.
>
>-karthik

