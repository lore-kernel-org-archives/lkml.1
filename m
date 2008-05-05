Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYEEPxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYEEPxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYEEPxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:53:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbYEEPxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:53:23 -0400
Date: Mon, 5 May 2008 08:52:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Cc: "Andrew Morgan" <morgan@kernel.org>, "Chris Wright" <chrisw@sous-sol.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] capabilities: add bounding set to /proc/self/status
Message-Id: <20080505085228.b223f7c5.akpm@linux-foundation.org>
In-Reply-To: <cfd18e0f0805050122p19721635h209b952396cfe52a@mail.gmail.com>
References: <20080501183559.GA21279@sergelap.austin.ibm.com>
	<20080502003730.GA4018@sequoia.sous-sol.org>
	<cfd18e0f0805050122p19721635h209b952396cfe52a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 10:22:06 +0200 "Michael Kerrisk" <mtk.manpages@googlemail.com> wrote:

> On Fri, May 2, 2008 at 2:38 AM, Chris Wright <chrisw@sous-sol.org> wrote:
> > * Serge E. Hallyn (serue@us.ibm.com) wrote:
> > > There is currently no way to query the bounding set of another
> > > task.  As there appears to be no security reason not to, and
> > > as Michael Kerrisk points out the following valid reasons to do
> > > so exist:
> > >
> > > * consistency (I can see all of the other per-thread/process sets in
> > > /proc/.../status)
> > > * debugging -- I could imagine that it would make the job of debugging
> > > an application that uses capabilities a little simpler.
> > >
> > > this patch adds the bounding set to /proc/self/status right after
> > > the effective set.
> > >
> > > If at all possible (and if acked by Andrew Morgan) it would be nice to
> > > get this into the 2.6.26 cycle.  But I realize it probably is too late
> > > for that.
> >
> > I've no issue with this.
> >
> > > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > > Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
> >
> > Acked-by: Chris Wright <chrisw@sous-sol.org>
> >
> >
> > > ---
> > >  fs/proc/array.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/fs/proc/array.c b/fs/proc/array.c
> > > index c135cbd..160dd4a 100644
> > > --- a/fs/proc/array.c
> > > +++ b/fs/proc/array.c
> > > @@ -297,6 +297,7 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
> > >       render_cap_t(m, "CapInh:\t", &p->cap_inheritable);
> > >       render_cap_t(m, "CapPrm:\t", &p->cap_permitted);
> > >       render_cap_t(m, "CapEff:\t", &p->cap_effective);
> > > +     render_cap_t(m, "CapBnd:\t", &p->cap_bset);
> > >  }
> > >
> > >  static inline void task_context_switch_counts(struct seq_file *m,
> >
>

[top-posting repaired]

> Andrew (Morgan),
> 
> It looks like this didn't make it into rc1, even though it was sent
> within the merge window -- perhaps Linus or Andrew (Morton) needed to
> be explicitly CCed?
> 

Sorry, I'm horridly backlogged.  I seem to be able to process them at about
105% of the arrival rate lately, so we'll get there.  It isn't lost.

