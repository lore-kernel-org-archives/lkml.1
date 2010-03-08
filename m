Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0CHWpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:45:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab0CHWpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:45:43 -0500
Subject: Re: [GIT PULL] notification: after one week
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100308215748.GO30031@ZenIV.linux.org.uk>
References: <1268081739.3227.5.camel@localhost>
	 <20100308215748.GO30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 17:45:05 -0500
Message-ID: <1268088305.3227.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 21:57 +0000, Al Viro wrote:
> On Mon, Mar 08, 2010 at 03:55:39PM -0500, Eric Paris wrote:
> > Having you tell me to wait a week after rebasing (and probably being the
> > only person who waited a week after rebasing to ask for a pull) I'm
> > back.  I hoped to hear some review but none came.  If it does, rest
> > assured addressing those issues will be my top priority.  Since the last
> > pull request the only change is that I corrected the build flags to not
> > add -Wsigned-pointer and I actually dropped the permissions bits from
> > this branch (those bits are and have been in linux-next for a long time
> > now as well though)
> 
> Sigh...  I *will* dig the full review out (been buried in autofs review
> lately), but for starters grep for fsnotify() and fsnotify_parent(),
> then tell me why on the earth are you doing that kind of insane multiplexors?
> 
> I mean, WTF?
> ; git grep -n -w fsnotify_parent
> include/linux/fsnotify.h:28:static inline void fsnotify_parent(struct path *path, struct dentry
> include/linux/fsnotify.h:115:   fsnotify_parent(NULL, dentry, mask);
> include/linux/fsnotify.h:176:           fsnotify_parent(path, NULL, mask);
> include/linux/fsnotify.h:194:           fsnotify_parent(path, NULL, mask);
> include/linux/fsnotify.h:212:           fsnotify_parent(path, NULL, mask);
> include/linux/fsnotify.h:231:           fsnotify_parent(path, NULL, mask);
> include/linux/fsnotify.h:247:   fsnotify_parent(NULL, dentry, mask);
> include/linux/fsnotify.h:282:           fsnotify_parent(NULL, dentry, mask);
> ;
> 
> and *ALL* callers get one of those NULL and another non-NULL.  With
> different behaviour inside that sucker.  And fsnotify() is no better -
> it's a multiplexor from hell.

I have more out of tree work which makes fsnotify() (which does look
like it came straight from hell) a bit cleaner.  I will clean both of
those interfaces up (mostly by duplicating the code of each into
multiple functions) and will include that in a later pull request.
Thanks for starting to look and I hope you don't find functional
failings.

Al also told me off list another thing he particularly hates style and
usage wise: FMODE_NONOTIFY and how it is overloaded with O_* in my
dentry_open() calls.  It works, but we will think of a more manageable
solution (possibly completely separating FMODE_* and O_* at a higher
level.  Again on the list of things to work on, but I don't believe you
indicated a show stopper today.....

-Eric

-Eric

