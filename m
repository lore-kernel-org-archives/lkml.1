Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbZFBLFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbZFBLFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZFBLFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:05:13 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:38735 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZFBLFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:05:12 -0400
Message-Id: <20090602105311.591592481@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 12:53:11 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH/RFC 0/4] Dynamic ftrace support for s390
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds dynamic ftrace support for s390.
The first three patches are actually just preparation and cleanup.
However the first patch touches common code, because I want to be able to
have an arch specific version of probe_kernel_write().
The reason for that is that s390 enables page write protection for the
kernel text segment in order to catch random (broken) writes to kernel
text. Since write proctection is enabled any probe_kernel_write() call
would fail.
Now to solve this, we could disable write protection before writing
to the segment and afterwards enable it again (like the x86 specific
ftrace code does). Alternatively we could use some s390 special
instructions in order to bypass virtual addresses and their protection
and directly access the physical page that belongs to the virtual address.
That's my preferred solution and why I'd like to be able an arch
specific version of probe_kernel_write().

If there are no objections, these patches should go upstream via git-s390
I would guess?

Thanks,
Heiko
