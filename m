Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbYHDHJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbYHDHJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbYHDHJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:09:05 -0400
Received: from bay0-omc3-s18.bay0.hotmail.com ([65.54.246.218]:23680 "EHLO
	bay0-omc3-s18.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757119AbYHDHJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:09:04 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2008 03:09:04 EDT
Message-ID: <BAY121-W448F461B7F7E5DA621A237B6780@phx.gbl>
X-Originating-IP: [199.203.130.251]
From: Kostya B <bkostya@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: __do_softirq and real-time execution context
Date: Mon, 4 Aug 2008 07:02:53 +0000
Importance: Normal
In-Reply-To: <S1754783AbYHDGgc/20080804063632Z+270@vger.kernel.org>
References: <S1754783AbYHDGgc/20080804063632Z+270@vger.kernel.org>
Content-Type: text/plain; charset="windows-1255"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-OriginalArrivalTime: 04 Aug 2008 07:02:53.0813 (UTC) FILETIME=[1DA95A50:01C8F600]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Please consider the following:

__do_softirq could be run from several checkpoints in kernel and even can employ userspace process context. 
For example, under heavy network traffic such process could be blocked for a relatively large period until ksoftirqd wakes up and takes control for Rx/Tx. 

In the case of regular userspace process the ksoftirqd solves the kernel/user trade-off problem pretty well.
However, in the case of _real-time_ process, such behavior may yield severe outcomes. Real-time (e.g. NTPL FIFO thread) might require short responses and low latency.

The proposal is that  __do_softirq should not run its pending tasks in the context of RT process.  Just check has_rt_policy() and immediately wake up ksoftirqd.

Regards,
- Kostya


_________________________________________________________________
Invite your mail contacts to join your friends list with Windows Live Spaces. It's easy!
http://spaces.live.com/spacesapi.aspx?wx_action=create&wx_url=/friends.aspx&mkt=en-us
