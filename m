Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbZAWJVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbZAWJVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZAWJVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:21:10 -0500
Received: from lazybastard.de ([212.112.238.170]:42927 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZAWJVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:21:08 -0500
Date: Fri, 23 Jan 2009 10:20:56 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Detailed Stack Information Patch [0/3]
Message-ID: <20090123092056.GA13383@logfs.org>
References: <1232446597.784.15.camel@matrix> <20090122194126.GA5352@logfs.org> <1232660368.9652.18.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1232660368.9652.18.camel@matrix>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://en.wikipedia.org/wiki/Posting_style

On Thu, 22 January 2009 22:39:28 +0100, Stefani Seibold wrote:
> 
> First, i had explained what is the reason for the patch.

You did explain your solution.  The problem you are trying to solve was
not clear to me.  It may be my mistake.  If you have the stack
information, what can you do that you couldn't do without?  Notice
overly large stacks and fix the application?  I would guess so, but you
surely know better than me.

> Second, the number of #ifdef is not more or less than other features
> which extends the task_struct on demand.
> 
> There is no way to do this without #ifdef's, only if i add this feature
> without a CONFIG_.... option.

True.  The comment was not about removing them completely but moving
them where they hurt less.  When I'm reading through some generic code
and I read something like this:

	f->f_pos = 0;
	f->f_op = fops_get(inode->i_fop);
	file_move(f, &inode->i_sb->s_files);

	error = security_dentry_open(f);
	if (error)
		goto cleanup_all;

I only get slightly distracted by the security_dentry_open() that I
personally may not care about one bit.  Much nicer than having this:

	f->f_pos = 0;
	f->f_op = fops_get(inode->i_fop);
	file_move(f, &inode->i_sb->s_files);

#ifdef CONFIG_SECURITY
	error = security_dentry_open(f);
	if (error)
		goto cleanup_all;
#endif

See the difference?

> But this patch did nit solve a problem, it is a feature like
> PROC_PAGE_MONITOR or similar. It will help to figure out, how much stack
> will be consumed by a particular process or thread.
> 
> It also not a patch which cares Joe Kernelhacker, it cares Jane
> Userlandhacker!

Fair enough.  So assuming I wanted to reduce or limit stack consumption,
what would I do with this information.  I know the responsible process,
but not the callchain.  kill -QUIT 12345 would give me a core dump and I
could analyse that.

Is that what you try to achieve?  I was only guessing and may have
missed a more important point.

Jörn

-- 
Everything should be made as simple as possible, but not simpler.
-- Albert Einstein
