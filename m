Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYKLVp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYKLVp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYKLVpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:45:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41995 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbYKLVpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:45:17 -0500
Subject: Re: [PATCH =-v3 11/21] fanotify: give a special access permission
 check
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
In-Reply-To: <20081112165325.GC19669@infradead.org>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
	 <20081112161124.25434.86250.stgit@paris.rdu.redhat.com>
	 <20081112165325.GC19669@infradead.org>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 16:23:05 -0500
Message-Id: <1226524985.3353.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-12 at 11:53 -0500, Christoph Hellwig wrote:
> On Wed, Nov 12, 2008 at 11:11:24AM -0500, Eric Paris wrote:
> >  	fsnotify_open_exec(file);
> > +	error = fanotify(file, FAN_ACCESS_EXEC_PERM);
> > +	if (error) {
> > +		fput(file);
> > +		goto out;
> > +	}
> 
> Adding your own fanotify calls next to the fsnotify calls completely
> defeats th purpose of these.  Please make sure we have one set of hooks.

Absolutely in this case.  Would you prefer I funneled ALL fanotify
blocking calls through fsnotify?  I did back in patch #10 add fanotify
calls next to some security calls (it also might be possible for me to
pull the fsnotify calls of these paths up rather than introduce new
fsnotify hooks, I'm not yet certain.)

> And given that we now have three notification schemes I think it's
> getting time that you also unifify the actuall backends (buffering, etc)
> instead of faning out at the fsnotify layer and just leave dnotify and
> inotify as tiny userspace interface layers.

doing something like this would obviously require in kernel fastpaths
(as i'm sure you are aware.)   I guess then I get to use the space in
inode of both dnotify and inotify.  Like I said I'll try to see what I
can do down this path.

No matter what I think this is going to have to be merged first as
fanotify is quite broad in comparison to either d or i notify.

-Eric

