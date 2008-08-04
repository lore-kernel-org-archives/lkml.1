Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbYHDHlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbYHDHlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYHDHlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:41:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:57221 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYHDHlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:41:23 -0400
Subject: Re: __do_softirq and real-time execution context
From: Peter Zijlstra <peterz@infradead.org>
To: Kostya B <bkostya@hotmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BAY121-W448F461B7F7E5DA621A237B6780@phx.gbl>
References: <S1754783AbYHDGgc/20080804063632Z+270@vger.kernel.org>
	 <BAY121-W448F461B7F7E5DA621A237B6780@phx.gbl>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 09:41:23 +0200
Message-Id: <1217835683.11946.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 07:02 +0000, Kostya B wrote:
> Hello,
> 
> Please consider the following:
> 
> __do_softirq could be run from several checkpoints in kernel and even can employ userspace process context. 
> For example, under heavy network traffic such process could be blocked for a relatively large period until ksoftirqd wakes up and takes control for Rx/Tx. 
> 
> In the case of regular userspace process the ksoftirqd solves the kernel/user trade-off problem pretty well.
> However, in the case of _real-time_ process, such behavior may yield severe outcomes. Real-time (e.g. NTPL FIFO thread) might require short responses and low latency.
> 
> The proposal is that  __do_softirq should not run its pending tasks in the context of RT process.  Just check has_rt_policy() and immediately wake up ksoftirqd.

Please look at the -rt patches.

