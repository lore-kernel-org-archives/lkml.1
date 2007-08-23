Return-Path: <linux-kernel-owner+w=401wt.eu-S933611AbXHWXlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611AbXHWXlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765653AbXHWXlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:41:24 -0400
Received: from ozlabs.org ([203.10.76.45]:54567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764210AbXHWXlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:41:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18126.6941.186345.839232@cargo.ozlabs.ibm.com>
Date: Fri, 24 Aug 2007 09:41:17 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] 2.6.23-rc3-mm1 Oops: Machine check, sig: 7 [#1]
In-Reply-To: <20070822090858.b8f62539.akpm@linux-foundation.org>
References: <46CC387D.4000605@linux.vnet.ibm.com>
	<20070822090858.b8f62539.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> Dunno, it beats me.  powerpc booted OK for me.  Ben, have you been playing
> around in powerpc mmap code?  How come the oops claims it died at
> kernel_execve+0x8/0x14 but the call trace points up into the vma management
> code?

The exception c01 in kernel_execve is just the system call entry.  The
real problem is the machine check that happened in rb_insert_color,
called from __vma_link_rb.

However, a machine check is an imprecise exception, so whatever caused
the problem may have happened a little earlier than that.  Most likely
it is due to an attempt to access a physical address where nothing
exists.

Paul.
