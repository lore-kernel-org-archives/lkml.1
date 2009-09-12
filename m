Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbZILP5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbZILP5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 11:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbZILP5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 11:57:34 -0400
Received: from www84.your-server.de ([213.133.104.84]:53818 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbZILP5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 11:57:33 -0400
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
From: Stefani Seibold <stefani@seibold.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090912152814.GG5858@ZenIV.linux.org.uk>
References: <1251563892.13287.11.camel@wall-e>
	 <20090829231650.GA29419@infradead.org> <1251659144.20987.18.camel@wall-e>
	 <20090912152814.GG5858@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sat, 12 Sep 2009 17:57:48 +0200
Message-Id: <1252771068.29135.25.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 12.09.2009, 16:28 +0100 schrieb Al Viro:
> On Sun, Aug 30, 2009 at 09:05:44PM +0200, Stefani Seibold wrote:
> > Switching all users of read_proc_t/write_proc_t to file operation is a
> > huge job. About 180 files must be fixed.
> > 
> > But the main reason not to do this is because the breakage of "out of
> > tree" drivers.
> 
> > I like the current simplified proc interface. It saves a lot of code
> > duplication because the basic operations will be handled inside the
> > kernel and not in the driver.
> 
> _What_ code duplication?  Would that be
>         struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
> and calculation of pde->data currently done by proc_file_write()?
> Pardon me, but that's hard to take seriously.  As for the ->read() side,
> most of those suckers end up switched to use of seq_read() and there's
> not a lot of boilerplate code in the resulting variants...

Hi Al, you are 2 weeks to late, the discussion has already ended. But
lets start it again.... 

There is some code duplication, proc_file_write has 17 lines of code.
And together with my path it will be 19 lines of code. How much lines of
duplicated code are necessary for take them seriously? 

I know that the current mainstream development targets enterprise and
maybe sometime desktop systems. But the truth is that linux will be
mostly used in embedded system with very limited memory constrains.

BTW: I personally think the whole seq_.... interface is IMHO to
complicate to use, procfs is much simpler. But this is only my personal
opinion! 

Greetings,
Stefani


