Return-Path: <linux-kernel-owner+w=401wt.eu-S1423433AbXD3PrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423433AbXD3PrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423435AbXD3PrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:47:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51398 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423433AbXD3PrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:47:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 0/12] Early USB debug port and i386 boot cleanups
Date: Mon, 30 Apr 2007 09:46:17 -0600
Message-ID: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Modern hardware relies primarily on memory mapped I/O which is typically
at addresses that are not mapped by the kernels initial page tables,
which makes using them currently unusable for early debugging print support.

So this patch set digs in and fixes the early page tables on both
arch/i386 and arch/x86_64 so that set_fixmap works with our initial boot
page tables.   All that is needed is that we allocate preallocate the pte
page that the fixmap entries live on.

On arch/i386 I accomplish this by ensuring the boot time page tables are
in the native mode.  Doing this provides an alternative and slightly
more capable fix to Jeremy's problem of not having the initial memory
mapping covering enough pages to identity map all of low memory.  Because
we are now updating the page table we are running on we add the mappings
we need for the initial page table as we build the initial page table.

Since I was in there I kept cleaning up arch/i386/head.S.
In particular I have gotten as far as removing the early cpuid,
and have added a head32.S.

Eric
