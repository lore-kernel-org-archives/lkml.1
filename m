Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZILP2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZILP2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 11:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbZILP2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 11:28:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56558 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbZILP2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 11:28:21 -0400
Date: Sat, 12 Sep 2009 16:28:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stefani Seibold <stefani@seibold.net>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
Message-ID: <20090912152814.GG5858@ZenIV.linux.org.uk>
References: <1251563892.13287.11.camel@wall-e> <20090829231650.GA29419@infradead.org> <1251659144.20987.18.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251659144.20987.18.camel@wall-e>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 09:05:44PM +0200, Stefani Seibold wrote:
> Switching all users of read_proc_t/write_proc_t to file operation is a
> huge job. About 180 files must be fixed.
> 
> But the main reason not to do this is because the breakage of "out of
> tree" drivers.

> I like the current simplified proc interface. It saves a lot of code
> duplication because the basic operations will be handled inside the
> kernel and not in the driver.

_What_ code duplication?  Would that be
        struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
and calculation of pde->data currently done by proc_file_write()?
Pardon me, but that's hard to take seriously.  As for the ->read() side,
most of those suckers end up switched to use of seq_read() and there's
not a lot of boilerplate code in the resulting variants...
