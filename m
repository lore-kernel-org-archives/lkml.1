Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbYARSEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbYARSEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760292AbYARSES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:04:18 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:34059 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312AbYARSES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:04:18 -0500
Message-ID: <4790E9F4.2000602@bintz.net>
Date: Fri, 18 Jan 2008 12:03:32 -0600
Reply-To: lists+lkml@bintz.net
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CONFIG_PREEMPT and real time kthreads
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Miles Bintz <miles@bintz.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying to find information about the effects of CONFIG_PREEMPT 
on real time kernel threads.   The description of CONFIG_PREEMPT says 
"...allow preemption of user processes that are executing system 
calls...".  Most of the discussion seems to revolve around the 
modification of the locking implementation.

Suppose:  I have two or more kernel threads using the SCHED_FIFO policy 
and they have differing priorities.  Lets pretend the high priority 
kthread is doing a down_interruptible() and the low priority kthread is 
cheerfully executing.  An interrupt fires and does an up() enabling the 
high priority kthread....  Heck, lets say there's no interrupt and the 
low priority kthread does the up().... Without compiling my kernel with 
CONFIG_PREEMPT=y, will the high priority task get scheduled during the 
up()?  Or will the low priority task run until it yields?   In general, 
I'm assuming the scheduler will always reschedule on return from 
interrupts and after the release of a synchronization primitive?

       Miles




