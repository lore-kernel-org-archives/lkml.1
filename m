Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYKLXdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYKLXdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYKLXd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:33:28 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48275 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbYKLXd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:33:28 -0500
Message-Id: <20081112231551.473569400@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 18:15:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [patch 00/17] Trace Clock v3
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 12 Nov 2008 23:33:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In this new version, I have integrated the changes I did following the comments
I received for v2. I also reimplemented the "generic" trace clock so it is less
intrusive and simply use a standard timer. I is not as bound to the xtime_lock
as it previously was and it does not have to modify kernel/time.c anymore.

I think this is pretty close to a mergeable state. I plan to keep more exotic
features, such as dealing with non-synchronized TSCs without cache-line
bouncing, for future improvement. As a reminder, when the trace clock detects an
unsynchronized TSC on the machine, it prints the information about which kernel
command line arguments must be used so the user can have synchronized timestamp
counters. However, if the user wants to use his system with non-synchronized
TSCs, the cache-line bouncing fallback is used.

This patchset applies on top of 2.6.28-rc4.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
