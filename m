Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYLKMcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYLKMcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 07:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYLKMcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 07:32:07 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57954 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYLKMcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 07:32:06 -0500
Date: Thu, 11 Dec 2008 13:31:53 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rakib Mullick <rakib.mullick@gmail.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/freezer.c : Removing extra checking.
Message-ID: <20081211123152.GA1842@ucw.cz>
References: <b9df5fa10812060020i40373ed3rdc97812ed46ba959@mail.gmail.com> <200812061441.15772.rjw@sisk.pl> <b9df5fa10812060704t1685710aw65f7c1e00e5f98@mail.gmail.com> <200812061752.58008.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812061752.58008.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-12-06 17:52:57, Rafael J. Wysocki wrote:
> On Saturday, 6 of December 2008, Rakib Mullick wrote:
> > On 12/6/08, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Saturday, 6 of December 2008, Rakib Mullick wrote:
> > >  > Impact: Reduces an extra checking.
> > >  >
> > >  > Following patch removes an extra checking. We can remove it since, the
> > >  > current task is frozen. If the current task is not frozen, then it
> > >  > will return from __else__ condition of freezing(current) check. So,
> > >  > the check becames unnecessary. It also reduces 32 bytes of text space
> > >  > on my x86  (32 bit) system.
> > >
> > >
> > > What will happen with this patch applied when a task is woken up for some
> > >  reason other than thawing?
> > thawing is usually used for woken up a frozzen process. Would you
> > please tell me what are the other ways to woken up a frozzen process?
> > Am I missing anything ?
> 
> Well, in theory the process can be woken up for another reason.

...like pending signal...

> I don't have any particular examples in mind, but in this case the burden is
> yours to show that it won't happen and to say why exactly you think so in the
> changelog, because this is the very reason why the code has been written this
> way in the first place.
> 
> Thanks,
> Rafael
> 
> 
> > >  > Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> > >  >
> > >  > --- linux-2.6-orig/kernel/freezer.c   2008-12-05 19:53:45.000000000 +0600
> > >  > +++ linux-2.6/kernel/freezer.c        2008-12-05 19:55:40.000000000 +0600
> > >  > @@ -46,8 +46,6 @@ void refrigerator(void)
> > >  >
> > >  >       for (;;) {
> > >  >               set_current_state(TASK_UNINTERRUPTIBLE);
> > >  > -             if (!frozen(current))
> > >  > -                     break;
> > >  >               schedule();
> > >  >       }
> > >  >       pr_debug("%s left refrigerator\n", current->comm);
> > >

Plus this looks like infinite loop after your change. Have you tested
it?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
