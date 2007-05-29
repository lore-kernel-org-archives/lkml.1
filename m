Return-Path: <linux-kernel-owner+w=401wt.eu-S1762024AbXE2NVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762024AbXE2NVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbXE2NVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:21:32 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:55982 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758870AbXE2NVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:21:31 -0400
Message-Id: <20070529125248.877196281@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 29 May 2007 14:52:48 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/5] lock contention tracking -v3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use the lockdep infrastructure to track lock contention and other lock
statistics.

It tracks lock contention events, and the first four unique call-sites that
encountered contention.

It also measures lock wait-time and hold-time in nanoseconds. The minimum and
maximum times are tracked, as well as a total (which together with the number
of event can give the avg).

All statistics are done per lock class, per write (exclusive state) and per read
(shared state). 

The statistics are collected per-cpu, so that the collection overhead is
minimized via having no global cachemisses.

This new lock statistics feature is independent of the lock dependency checking
traditionally done by lockdep; it just shares the lock tracking code. It is
also possible to enable both and runtime disabled either component - thereby
avoiding the O(n^2) lock chain walks for instance.


Andrew, can we give this a spin in -mm?


