Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbXFQQO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbXFQQO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXFQQOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:14:40 -0400
Received: from science.horizon.com ([192.35.100.1]:19774 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752866AbXFQQOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:14:40 -0400
Date: 17 Jun 2007 12:14:39 -0400
Message-ID: <20070617161439.8470.qmail@science.horizon.com>
From: linux@horizon.com
To: linux-kernel@vger.kernel.org
Subject: msleep(1000) vs. schedule_timeout_uninterruptible(HZ+1)
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at some of the stupider code that calls msleep(),
particularly that which does
	msleep(jiffies_to_msecs(jiff))

and I noticed that msleep() just calls schedule_timeout_uninterruptible().
But it does it in a loop.

The basic question is, when does the loop make a difference?
Is it only when you're on a wait queue?  Or are there other kinds of
unexpected wakeups that can arrive?

I see all kinds of uses of both kinds for simple "wait a while" operations,
and I'm not sure if one is more correct than the other.

(And, in drivers/media/video/cpia2/cpia2_v4l.c:cpia2_exit(), a lovely
example of calling schedule_timeout() without set_current_state() first.)
