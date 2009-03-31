Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbZCaOpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbZCaOpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZCaOoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:44:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34707 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZCaOoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:44:55 -0400
Date: Tue, 31 Mar 2009 16:40:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, dhowells@redhat.com,
       ebiederm@xmission.com, hch@lst.de, matthltc@us.ibm.com
Subject: Re: + mm-remove-struct-mm_struct-exe_file-et-al.patch added to -mm
	tree
Message-ID: <20090331144051.GA3951@redhat.com>
References: <200903302344.n2UNi3xd027136@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903302344.n2UNi3xd027136@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/mm-commits/lkml/

On 03/30, Andrew Morton wrote:
>
> From: Alexey Dobriyan <adobriyan@gmail.com>
>
> Commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07 ("procfs task exe
> symlink").  introduced struct mm_struct::exe_file and struct
> mm_struct::num_exe_file_vmas.
>
> The rationale is weak: unifying MMU and no-MMU version of /proc/*/exe
> code.  For this a) struct mm_struct becomes bigger, b) mmap/munmap/exit
> become slower, c) patch adds more code than removes in fact.
>
> ->exe_file maybe well defined, but doesn't make sense always.  After
> original executable is unmapped, /proc/*/exe will still report it and,
> more importantly, pin corresponding struct file.

I never liked the change which introduced mm->exe_file, so I vote for
this patch.

But, as a advocatus diaboli... There was anotrher reason for ->exe_file,
iirc.

bprm->file->f_op->mmap() can change vma->vm_file, this means proc_exe_link()
can report the "wrong" path. The original file is not pinned in this case.

Matt?

Oleg.

