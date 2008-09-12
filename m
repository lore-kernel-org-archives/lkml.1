Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbYILTJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbYILTJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbYILTIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:08:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbYILTIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:08:50 -0400
Date: Fri, 12 Sep 2008 08:58:04 -0700
From: Greg KH <greg@kroah.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit]
	and find_css_set
Message-ID: <20080912155804.GB3610@kroah.com>
References: <48AA684B.7000704@cn.fujitsu.com> <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com> <48C72E7C.8080302@cn.fujitsu.com> <20080910050112.GA2897@kroah.com> <6599ad830809092231h90712a6mc95b81229d64d6bc@mail.gmail.com> <20080910061717.GA6301@kroah.com> <48C76875.50007@cn.fujitsu.com> <20080910062951.GA6779@kroah.com> <6599ad830809100803w1bbbb331qa6741b9f42204dcf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830809100803w1bbbb331qa6741b9f42204dcf@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 08:03:18AM -0700, Paul Menage wrote:
> On Tue, Sep 9, 2008 at 11:29 PM, Greg KH <greg@kroah.com> wrote:
> >
> > But you can't put such logic in the release() function as you are
> > finding out, that's not going to work either.
> 
> Right - that's why a kref_put_and_write_lock() function would be handy
> - it would take the lock only when necessary. It would delegate most
> of its work to the (as-yet nonexistant) atomic_dec_and_write_lock()
> function, which would be an rwlock equivalent of atomic_dec_and_lock()
> 
> >
> > Maybe you need to just "open-code" an atomic counter here and not use
> > kref as it sounds like you are needing to do something very "special"
> > here.
> >
> 
> It's basically the same situation as the dentry cache - ref-counted
> objects that are also referenced from a hash table protected by a
> global lock.
> 
> If you're opposed to the addition of kref_put_and_write_lock() then
> yes, I'll replace kref with a custom refcount.

It just seems messy, but if you want to try it, I'll be glad to look at
the code.  Oh wait, was that the patch that you sent out last time?

thanks,

greg k-h
