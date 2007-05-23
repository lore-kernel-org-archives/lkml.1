Return-Path: <linux-kernel-owner+w=401wt.eu-S1765844AbXEWKEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765844AbXEWKEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765248AbXEWKCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:02:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765165AbXEWKCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:02:45 -0400
Message-Id: <20070523072618.129001605@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 23 May 2007 11:57:16 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/7] lock contention tracking -v2
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

TODO:
 - create new output format

-- 

