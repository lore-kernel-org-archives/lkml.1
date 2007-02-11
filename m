Return-Path: <linux-kernel-owner+w=401wt.eu-S932323AbXBKUDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbXBKUDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 15:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbXBKUDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 15:03:31 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:57612 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbXBKUD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 15:03:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       systemtap@sources.redhat.com, ltt-dev@shafik.org
Subject: [PATCH 00/05] Linux Kernel Markers - kernel 2.6.20
Date: Sun, 11 Feb 2007 15:03:22 -0500
Message-Id: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers - kernel 2.6.20

Hi,

You will find, in the following posts, the latest revision of the Linux Kernel
Markers. Due to the need some tracing projects (LTTng, SystemTAP) has of this
kind of mechanism, it could be nice to consider it for mainstream inclusion.

Recently added : completed correct support for Intel XMC-safe code modification
(erratum 49 of the Pentium III). I am not using the kprobe infrastructure
because it forbids instrumentation of too much core kernel functions (traps
handlers, lockdep.c, ...). I also made the "GEN_MARK" marker available at all
time : it will force using the generic version of the markers at a specific
instrumentation site. It is intended to be used at instrumentation sites that
are not reentrant with respect to the breakpoint handler.
lockdep.c/trace_hardirqs_on/off() is a good example of where it is needed :
the breakpoint handler calls hardirq tracing event when it returns.

The following patches apply on 2.6.20.

These patches compile fine against :

arm
i686
ia64
m68k
mips
mipsel
x86_64
ppc 405
powerpc 970
s390
sparc
sparc64

Signed-off-by : Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
