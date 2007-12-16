Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbXLPLjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbXLPLjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765532AbXLPLi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:38:56 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4996 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760524AbXLPLiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:38:55 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Date: Sun, 16 Dec 2007 12:40:53 +0100
User-Agent: KMail/1.9.7
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, davem@davemloft.net
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <200712161114.39437.m.kozlowski@tuxland.pl> <200712161141.50012.m.kozlowski@tuxland.pl>
In-Reply-To: <200712161141.50012.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712161240.54594.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>         cat /proc/kpageflags on sparc64 causes the box to lock.
> I can not write on any terminal - but I can issue sysrqs and switch
> between consoles.
> 
> cat process hangs in read(3, ...

cat /proc/kpagecount produces similar symptoms. box is locked - sysrq-w sshd trace:

__down
__down_interruptible
kobject_get
lock_kernel
chrdev_open
__dentry_open
nameidata_to_filp
open_pathname
do_sys_open
sparc32_open
linux_sparc_syscall32

then again:

BUG: soft lockup - CPU#0 stuck for 11s! [sshd:3242]
...
TPC: spitfire_xcall_helper+0xa0/0x100
...
RPC: spitfire_xcall_helper+0xac/0x100
...
I7: flush_dcache_page_all+0x1a4/0x1e0

or:

BUG: soft lockup - CPU#0 stuck for 11s! [sshd:3242]
...
TPC: tick_get_tick+0xc/0x20
...
RPC: __handle_softirq_continue+0x20/0x24
...
I7: __delay+0x2c/0x60

Box is unusable. Easy to reproduce - every time.

Regards,

	Mariusz
