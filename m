Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYAOReG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYAOReG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYAORdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:33:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36487 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYAORdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:33:55 -0500
Date: Tue, 15 Jan 2008 18:36:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080115173658.GA2665@one.firstfloor.org>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115135317.GA13493@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115135317.GA13493@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:53:17PM +0100, Ingo Molnar wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Can you try this out?  It applies after "x86: move all asm/pgtable 
> > constants into one place".
> 
> and here's the patch
> 
> Subject: Re: unify pagetable accessors patch causes double fault II
> From: Jeremy Fitzhardinge <jeremy@goop.org>

The patch does not fix the problem here. When I boot plain git-x86
upto commit 67db3027d691ff8049d19be7bc440eca0e5826d7
on my 6GB machine I still get an recursive oops on entering user space.

The only difference to earlier kernels seems to be that the problem
happens a little latter (in stty, not boot), but that might be just
coincidence.

Config http://halobates.de/config32

stty[1151]: segfault at b7f0ce98 ip b7e03b7a sp bfc31f9c error 7
Eeek! page_mapcount(page) went negative! (-1)
  page pfn = bfc12
  page->flags = 80000014
  page->count = 0
  page->mapping = 00000000
  vma->vm_ops = nfs_file_vm_ops+0x0/0x18
  vma->vm_ops->nopage = 0x0
  vma->vm_ops->fault = filemap_fault+0x0/0x34e
  vma->vm_file->f_op->mmap = nfs_file_mmap+0x0/0x61
------------[ cut here ]------------
kernel BUG at /home/lsrc/git-arch-x86/linux-2.6-x86/mm/rmap.c:631!
invalid opcode: 0000 [#1] SMP

-Andi
