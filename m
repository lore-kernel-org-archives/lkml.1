Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbXC3XB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbXC3XB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbXC3XB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:01:29 -0400
Received: from xenotime.net ([66.160.160.81]:38296 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932825AbXC3XB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:01:28 -0400
Date: Fri, 30 Mar 2007 16:02:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 1/13] signal/timer/event fds v8 - anonymous inode source
 ...
Message-Id: <20070330160259.6e03705b.rdunlap@xenotime.net>
In-Reply-To: <Pine.LNX.4.64.0703301532500.3721@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415834.1>
	<20070330123943.8df1aa92.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703301532500.3721@alien.or.mcafeemobile.com>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 15:44:15 -0700 (PDT) Davide Libenzi wrote:

> On Fri, 30 Mar 2007, Andrew Morton wrote:
> 
> > > +#include <asm/uaccess.h>
> > > +
> > > +
> > > +
> > 
> > Too many blank lines
> 
> It'd be interesting to know how much is enough. You use one, ppl says it 
> is too dense. You use more, ppl says it's too much.
> There's the one-line rule for inter-function spacing, but what's the 
> include-functions ones? Or the functions-data ones?

1 :)


> > > +static int ainofs_delete_dentry(struct dentry *dentry);
> > > +static struct inode *aino_mkinode(void);
> > 
> > Unneeded forward declaration.
> 
> Same here. You're the third says this, so I'm gonna change it. But pls 
> consider adding it to the coding style.
> 
> 
> 
> > > +static struct file_system_type aino_fs_type = {
> > > +	.name		= "ainofs",
> > > +	.get_sb		= ainofs_get_sb,
> > > +	.kill_sb	= kill_anon_super,
> > > +};
> > > +static struct dentry_operations ainofs_dentry_operations = {
> > > +	.d_delete	= ainofs_delete_dentry,
> > > +};
> > 
> > If this is moved elsewhere we can perhaps remove some or all of the
> > unpleasing static function forward-declarations.
> 
> Grrr :)

you are a puttycat


> > > +/**
> > > + * aino_getfd - creates a new file instance by hooking it up to and anonymous
> > > + *              inode, and a dentry that describe the "class" of the file
> > > + * @pfd:     [out]   pointer to the file descriptor
> > > + * @dpinode: [out]   pointer to the inode
> > > + * @pfile:   [out]   pointer to the file struct
> > > + * @name:    [in]    name of the "class" of the new file
> > > + * @fops     [in]    file operations for the new file
> > > + * @priv     [in]    private data for the new file (will be file's private_data)
> > 
> > The [in] and [out] thing is nice - does kerneldoc handle it appropriately?
> 
> No idea. It should come out as text at least.

Yes, it's just [nice] text.

But the function description needs to fit on one line.  If that's
not enough, put more description after the @params lines, separated
by a
 *
"blank" line.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
