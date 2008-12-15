Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbYLOPsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbYLOPsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 10:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYLOPsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 10:48:05 -0500
Received: from kandzendo.ru ([195.178.208.66]:55068 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbYLOPsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 10:48:04 -0500
Date: Mon, 15 Dec 2008 18:48:00 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC PATCH -v4 13/14] inotify: reimplement inotify using fsnotify
Message-ID: <20081215154800.GA20504@ioremap.net>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <20081212215222.27112.33426.stgit@paris.rdu.redhat.com> <20081213032255.GH807@ioremap.net> <1229186641.29167.110.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229186641.29167.110.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 11:44:01AM -0500, Eric Paris (eparis@redhat.com) wrote:
> > While you are at it, please update inode_setattr() so that it dropped
> > inotify watches if new permissions do not allow to read data.
> 
> Now this isn't so easy....   Do you have suggestions how to do this with
> inotify as it stands today?  the vfs needs to know what's hanging on the
> open fd in userspace...    Not a bad idea.  I'll look, but clearly not a
> core patch....

I could put inotify check into notify_change(), which will check if new
permissions do not allow reading for the users stored in
inode->inotify_watches, each one would be dereferenced to inotify
device, which holds a user context, which added watch object, so it can
be checked the same way generic_permission() works.

-- 
	Evgeniy Polyakov
