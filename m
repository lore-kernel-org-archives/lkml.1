Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbYHHGeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbYHHGeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYHHGeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:34:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781AbYHHGeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:34:05 -0400
Date: Thu, 7 Aug 2008 23:33:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
Message-Id: <20080807233325.8fb76c8b.akpm@linux-foundation.org>
In-Reply-To: <1218175943.17093.107.camel@raven.themaw.net>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com>
	<20080807114030.4142.76568.stgit@web.messagingengine.com>
	<20080807141041.e0d5cccc.akpm@linux-foundation.org>
	<1218166760.17093.69.camel@raven.themaw.net>
	<20080807223109.e67f46e4.akpm@linux-foundation.org>
	<1218175943.17093.107.camel@raven.themaw.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Aug 2008 14:12:21 +0800 Ian Kent <raven@themaw.net> wrote:

> > > No problem.
> > > You mentioned this last time as well.
> > > 
> > > Since there are a couple of possible approaches and I wasn't sure which
> > > way to go I thought I'd post it as is and get feedback then make it a
> > > followup patch.
> > > 
> > > Could the pthreads user space daemon exec something between fd_install()
> > > and set_close_on_exec()? 
> > 
> > Gee, I don't know, it would depend on the context.
> > 
> > Is that a private file*?  Was it just created, and is there no
> > possibility that any other thread can be sharing it anyway?  If so,
> > there's no problem.
> 
> The problem is that autofs threads can exec mount or umount at any time
> and we see annoying selinux file descriptor leak security violation
> messages. So the point of this is to set the bit at the same time as the
> file is inserted into the table.
> 
> > 
> > > Perhaps there are some other alternative approaches to this.
> > > 
> > > Suggestions?
> > 
> > I don't know enough about autofs nor about what problem you're
> > attacking here to be able to say, sorry.  I don't even know why
> > close_on_exec is being set?
> 
> OK, sorry.
> 
> What I'm really after is:
> Should I do this at all, given the above?

I don't reliably know, sorry.  <does viro summoning dance>

> If this is sensible, should a parameter be added to fd_insall() to allow
> it to be requested at descriptor install or should a new function, say,
> fd_install_close_on_exec() be added?

If we decide to do it this way, then we can add an extra arg to
fd_install(), I guess.

void fd_install(unsigned int fd, struct file *file,
		void (*callback)(struct file *));

