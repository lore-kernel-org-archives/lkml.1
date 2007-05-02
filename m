Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbXEBFeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbXEBFeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXEBFeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:34:44 -0400
Received: from haxent.com ([65.99.219.155]:2153 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbXEBFem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:42 -0400
Message-Id: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:35 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 00/22] pollfs: filesystem abstraction for pollable objects
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces a new file system for the delivery of pollable
events through file descriptors. To the detriment of debugability, pollable
objects are a nice adjunct to nonblocking/epoll/event-based servers.

The pollfs filesystem abstraction provides better mechanisms needed for
creating and maintaining pollable objects. Also the pollable futex approach
is far superior (send and receive events from userspace or kernel) to eventfd
and fixes (supercedes) FUTEX_FD at the same time.

The (non) blocking and object size (user <-> kernel) semantics and are handled
internally, decoupling the core filesystem from the "subsystems" (mere push and
pop operations).

Currently implemented waitable "objects" are: signals, futexes, ai/o blocks and
timers.

More details at each patch.

http://haxent.com/~davi/pollfs/

Comments are welcome.

--
Davi Arnaut
