Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbZDOUeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbZDOUeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZDOUe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:34:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbZDOUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:34:27 -0400
Date: Wed, 15 Apr 2009 13:31:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: kronos.it@gmail.com, linux-kernel@vger.kernel.org, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH] Fix inconsistent lock state in inotify
Message-Id: <20090415133104.5f248c1b.akpm@linux-foundation.org>
In-Reply-To: <1239823895.2562.1.camel@localhost.localdomain>
References: <20090410192533.GA24345@dreamland.darkstar.lan>
	<20090414161329.094b977c.akpm@linux-foundation.org>
	<68676e00904150459q6cc34f9fjb9475937a4e73c71@mail.gmail.com>
	<20090415122532.0a0c5f24.akpm@linux-foundation.org>
	<1239823895.2562.1.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 15:31:35 -0400
Eric Paris <eparis@redhat.com> wrote:

> On Wed, 2009-04-15 at 12:25 -0700, Andrew Morton wrote:
> > On Wed, 15 Apr 2009 13:59:29 +0200
> > Luca Tettamanti <kronos.it@gmail.com> wrote:
> > 
> > > >> +++ b/fs/notify/inotify/inotify_user.c
> > > >> @@ -220,7 +220,7 @@ static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
> > > >>                               rem = 0;
> > > >>               }
> > > >>
> > > >> -             kevent->name = kmalloc(len + rem, GFP_KERNEL);
> > > >> +             kevent->name = kmalloc(len + rem, GFP_NOFS);
> > > >>               if (unlikely(!kevent->name)) {
> > > >>                       kmem_cache_free(event_cachep, kevent);
> > > >>                       return NULL;
> > > >
> > > > Thanks.
> > > >
> > > > This is in fact a false positive and we plan to fix it via lockdep
> > > > annotation.
> > > 
> > > Well, I trust you on the "false positive", but a few line before there this:
> > > 
> > >   kevent = kmem_cache_alloc(event_cachep, GFP_NOFS);
> > > 
> > > so can kmem_cache_alloc also use GFP_KERNEL?
> > 
> > Yes, it looks that way.
> > 
> > umm, I think I'll merge your original patch as a reminder-to-self.
> > If the problem doesn't get fixed in a better way for 2.6.30 then I
> > might end up going with the GFP_NOFS approach.
> > 
> > But it's bad to weaken the memory allocation mode just to plug a lockdep
> > warning.
> 
> I swear, I'm fighting with my machines trying to get one to work so I
> can test my lockdep fix today (and found a separate oddity/bug in the
> process)
> 

heh, thanks.  No rush, it's a tiny problem.  Some time this week or
next would be OK.

I get all paranoid about things falling through cracks.
