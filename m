Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYIYQB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYIYQB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYIYQA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:00:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62620 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYIYQA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:00:56 -0400
Message-Id: <20080925155807.158539649@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 25 Sep 2008 11:58:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC PATCH 0/2 v2] Unified trace buffer (take two)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Again: this is a proof of concept, just spitting out code for comments.

Here's my second attempt.

Changes since version 1:

 - Ripped away all the debugfs and event registration from ring buffers.

 - Removed the mergesort from the ringbuffer and pushed that up to the
   tracer.

 - Changed the event header to what Linus suggested (we can discuss this
   and try other suggestions for v3, namely Peter Zijlstras ideas).

 struct {
 	u32 time_delta:27, type:5;
	u32 data;
	u64 array[];
 };

 - Added timestamp at beginning of each page and implemented a way
   for all events to get the full timestamp from the previous.

 - The changes to ftrace on this release was much less than the first
   one.

Comments?

-- Steve

