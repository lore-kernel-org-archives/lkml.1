Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYAIWsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYAIWsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYAIWse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:48:34 -0500
Received: from emroute3.ornl.gov ([160.91.4.110]:48343 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbYAIWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:48:33 -0500
Date: Wed, 09 Jan 2008 17:48:32 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: CONFIG_NO_HZ breaks blktrace timestamps
To: linux-btrace@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-id: <1199918912.8388.13.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to gain some insight into a disk issue, I found that
blktrace/blkparse was giving me bogus traces -- I was seeing requests
complete before they were even dispatched or queued even! I had thought
that maybe this was an issue with SMP on the box, but when running with
'maxcpus=1', it told me that my 53 second test run only took 3.5
seconds.

I started tracking this down, and upon looking at cpu_clock(), and found
that it uses sched_clock(), which is based on jiffies. At this point I
had an ahah! moment and remembered that I had NO_HZ enabled.

Turning that off got blktrace to report the proper time for the test
run.

I'm not sure of the proper fix, nor am I sure I'm going to have much
time to track this down at the momenet, but I thought someone should
know.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


