Return-Path: <linux-kernel-owner+w=401wt.eu-S1946760AbXBJAkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946760AbXBJAkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946516AbXBJAkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:40:23 -0500
Received: from mail.screens.ru ([213.234.233.54]:51671 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946760AbXBJAkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:40:22 -0500
Date: Sat, 10 Feb 2007 03:39:58 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + smaps-add-clear_refs-file-to-clear-reference.patch added to -mm tree
Message-ID: <20070210003958.GA3047@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
>
> +static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> ...
> +	task = get_proc_task(file->f_path.dentry->d_inode);
> +	if (!task)
> +		return -ESRCH;
> +	clear_refs_smap(task->mm->mmap);

task->mm may be NULL and not stable, this needs get_task_mm() (may fail).

Don't we also need ->mmap_sem to iterate vmas?

Oleg.

