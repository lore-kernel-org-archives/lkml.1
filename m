Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbZLZSZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbZLZSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 13:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZLZSZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 13:25:28 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51974 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZLZSZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 13:25:27 -0500
Date: Sat, 26 Dec 2009 23:55:19 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegardno@ifi.uio.no>, Oleg Nesterov <oleg@redhat.com>
Subject: [RFC Patch 0/2][Bugfix][x86][hw-breakpoint] Bugfixes for
	hw_breakpoint_handler
Message-ID: <20091226182519.GA9494@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please find a patchset of two patches that

Patch 1/2: Clears the arch-reserved bits from debug status register. This
helps easy bitwise operations - such as the check for non-trap bits in
hw_breakpoint_handler. A check for the same using
"if (dr6 & (~DR_TRAP_BITS))" throws incorrect results due to the 
presence of preset reserved bits.

This patch is copied to maintainers of code (such as kmemcheck, kprobe,
ptrace, etc) who make use of local dr6 value in do_debug() that verify
and handle exceptions.

Patch 2/2: Return NOTIFY_DONE from hw_breakpoint_handler() for user-space
breakpoints only (and not for kernel-space) since this could lead to
further processing in do_debug() with undesirable consequences.

Let me know if there are any concerns about the patch.

Thanks,
K.Prasad

