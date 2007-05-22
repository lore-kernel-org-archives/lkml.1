Return-Path: <linux-kernel-owner+w=401wt.eu-S935152AbXEVVxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152AbXEVVxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbXEVVxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:53:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758557AbXEVVxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:53:23 -0400
Date: Tue, 22 May 2007 14:52:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: section mismatches
Message-Id: <20070522145245.727813f3.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


So I bravely did an i386 allmodconfig build on the current -mm lineup:

WARNING: vmlinux(.text+0xc010116f): Section mismatch: reference to .init.text:start_kernel (between 'is386' and 'check_x87')
WARNING: vmlinux(.text+0xc02f7af7): Section mismatch: reference to .init.text: (between 'rest_init' and 'alloc_node_mem_map')
WARNING: vmlinux(.text+0xc02fe08d): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02fe099): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02fe0a5): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02fe0b1): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02f7b83): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'alloc_node_mem_map' and 'zone_wait_table_init')
WARNING: vmlinux(.text+0xc02f7c53): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'zone_wait_table_init' and 'schedule')
WARNING: vmlinux(.text+0xc021dcc8): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_startup' and 'vgacon_scrolldelta')
WARNING: vmlinux(.text+0xc02fe738): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc02fe884): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.data+0xc0439099): Section mismatch: reference to .init.text:xen_start_kernel (between 'startup_xen' and 'boot_gdt_descr')

Could the people who write these bugs, please, like, fix them?

It's not trivial noise.  These things lead to kernel crashes.
