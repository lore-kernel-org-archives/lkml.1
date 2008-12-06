Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbYLFQyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbYLFQyF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 11:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYLFQxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 11:53:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60035 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYLFQxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 11:53:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Subject: Re: [PATCH] kernel/freezer.c : Removing extra checking.
Date: Sat, 6 Dec 2008 17:52:57 +0100
User-Agent: KMail/1.9.9
Cc: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <b9df5fa10812060020i40373ed3rdc97812ed46ba959@mail.gmail.com> <200812061441.15772.rjw@sisk.pl> <b9df5fa10812060704t1685710aw65f7c1e00e5f98@mail.gmail.com>
In-Reply-To: <b9df5fa10812060704t1685710aw65f7c1e00e5f98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061752.58008.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of December 2008, Rakib Mullick wrote:
> On 12/6/08, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, 6 of December 2008, Rakib Mullick wrote:
> >  > Impact: Reduces an extra checking.
> >  >
> >  > Following patch removes an extra checking. We can remove it since, the
> >  > current task is frozen. If the current task is not frozen, then it
> >  > will return from __else__ condition of freezing(current) check. So,
> >  > the check becames unnecessary. It also reduces 32 bytes of text space
> >  > on my x86  (32 bit) system.
> >
> >
> > What will happen with this patch applied when a task is woken up for some
> >  reason other than thawing?
> thawing is usually used for woken up a frozzen process. Would you
> please tell me what are the other ways to woken up a frozzen process?
> Am I missing anything ?

Well, in theory the process can be woken up for another reason.

I don't have any particular examples in mind, but in this case the burden is
yours to show that it won't happen and to say why exactly you think so in the
changelog, because this is the very reason why the code has been written this
way in the first place.

Thanks,
Rafael


> >  > Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> >  >
> >  > --- linux-2.6-orig/kernel/freezer.c   2008-12-05 19:53:45.000000000 +0600
> >  > +++ linux-2.6/kernel/freezer.c        2008-12-05 19:55:40.000000000 +0600
> >  > @@ -46,8 +46,6 @@ void refrigerator(void)
> >  >
> >  >       for (;;) {
> >  >               set_current_state(TASK_UNINTERRUPTIBLE);
> >  > -             if (!frozen(current))
> >  > -                     break;
> >  >               schedule();
> >  >       }
> >  >       pr_debug("%s left refrigerator\n", current->comm);
> >
> > > --
