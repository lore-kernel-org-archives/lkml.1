Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYLPBh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYLPBh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYLPBhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:37:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36969 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYLPBhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:37:45 -0500
Subject: Re: [PATCH 1/3] filesystem notification: create fs/notify to
 contain all fs notification
From: Eric Paris <eparis@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, akpm@linux-foundation.org
In-Reply-To: <20081216095546.06C7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com>
	 <20081215164409.2018.26639.stgit@paris.rdu.redhat.com>
	 <20081216095546.06C7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 20:37:36 -0500
Message-Id: <1229391456.23523.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 10:02 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > Creating a generic filesystem notification interface, fsnotify, which will be
> > used by inotify, dnotify, and eventually fanotify is really starting to
> > clutter the fs directory.  This patch simply moves inotify and dnotify into
> > fs/notify/inotify and fs/notify/dnotify respectively.
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> > 
> >  fs/Kconfig                       |   39 --
> >  fs/Makefile                      |    5 
> >  fs/dnotify.c                     |  194 --------
> >  fs/inotify.c                     |  913 --------------------------------------
> >  fs/inotify_user.c                |  778 --------------------------------
> >  fs/notify/Kconfig                |    2 
> >  fs/notify/Makefile               |    2 
> >  fs/notify/dnotify/Kconfig        |   10 
> >  fs/notify/dnotify/Makefile       |    1 
> >  fs/notify/dnotify/dnotify.c      |  194 ++++++++
> >  fs/notify/inotify/Kconfig        |   27 +
> >  fs/notify/inotify/Makefile       |    2 
> >  fs/notify/inotify/inotify.c      |  913 ++++++++++++++++++++++++++++++++++++++
> >  fs/notify/inotify/inotify_user.c |  778 ++++++++++++++++++++++++++++++++
> >  14 files changed, 1931 insertions(+), 1927 deletions(-)
> >  delete mode 100644 fs/dnotify.c
> >  delete mode 100644 fs/inotify.c
> >  delete mode 100644 fs/inotify_user.c
> >  create mode 100644 fs/notify/Kconfig
> >  create mode 100644 fs/notify/Makefile
> >  create mode 100644 fs/notify/dnotify/Kconfig
> >  create mode 100644 fs/notify/dnotify/Makefile
> >  create mode 100644 fs/notify/dnotify/dnotify.c
> >  create mode 100644 fs/notify/inotify/Kconfig
> >  create mode 100644 fs/notify/inotify/Makefile
> >  create mode 100644 fs/notify/inotify/inotify.c
> >  create mode 100644 fs/notify/inotify/inotify_user.c
> 
> 1) this mail only contain Kconfig and Makefile changing patch.
>    iow, this patch doesn't contain file moving information.
>    iow, patch statics and actual patch are different.
> 2) your latter patch doesn't depend on this patch.
>    this patch doesn't have justification.
>    I recommend to separate this patch.

It is there, it is just in the git -M rename diff output rather than
"normal" diff.  See the sections like:

diff --git a/fs/dnotify.c b/fs/notify/dnotify/dnotify.c
similarity index 100%
rename from fs/dnotify.c
rename to fs/notify/dnotify/dnotify.c

This type of patch can be applied directly to your git tree and makes
review trivial.....

If people who will put this into a subsystem would prefer the long diff
I'll gladly resend.

I'll agree it isn't required but the other 2 aren't going to apply
without it, and it does clean up fs.  I'd much rather get this early
than in the middle somewhere since others are also looking at changing
this subsystem at the same time....     It can be dropped it others
agree....

