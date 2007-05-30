Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbXE3NMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbXE3NMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbXE3NMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:12:09 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:13091 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752160AbXE3NMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:12:08 -0400
Message-Id: <20070530124903.882133089@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 30 May 2007 14:49:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/6] lock contention tracking -v4
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

--

Changes since -v3
 - reshuffled code to reduce #ifdef mess
 - changed some long long to [us]64
 - split the 'lockstat core' vs 'human readabilty tweaks' differently

