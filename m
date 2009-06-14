Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbZFNMOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbZFNMOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZFNMO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:14:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:3917 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbZFNMO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:14:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,217,1243839600"; 
   d="scan'208";a="154095865"
Date: Sun, 14 Jun 2009 20:14:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
Message-ID: <20090614121421.GA7949@localhost>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> <Pine.LNX.4.64.0906131456090.5069@sister.anvils> <20090614100110.GA19875@localhost> <20090614104212.GA5977@localhost> <8bd0f97a0906140346t6b19f00aq29cfd4c554682f07@mail.gmail.com> <20090614111440.GC6046@localhost> <8bd0f97a0906140426g5c9ad183qa258be91c17c929d@mail.gmail.com> <20090614114935.GA7489@localhost> <8bd0f97a0906140458s25bdaca9jc5ba2db76da913d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906140458s25bdaca9jc5ba2db76da913d7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 07:58:29PM +0800, Mike Frysinger wrote:
> On Sun, Jun 14, 2009 at 07:49, Wu Fengguang wrote:
> > On Sun, Jun 14, 2009 at 07:26:37PM +0800, Mike Frysinger wrote:
> >> On Sun, Jun 14, 2009 at 07:14, Wu Fengguang wrote:
> >> > On Sun, Jun 14, 2009 at 06:46:24PM +0800, Mike Frysinger wrote:
> >> >> On Sun, Jun 14, 2009 at 06:42, Wu Fengguang wrote:
> >> >> > On Sun, Jun 14, 2009 at 06:01:10PM +0800, Wu Fengguang wrote:
> >> >> > Sorry I take back the previous patch. It makes sense to not break
> >> >> > existing user space tools, but a warning message looks OK to remind
> >> >> > people of possibly unexpected behavior.
> >> >> >
> >> >> >                default:
> >> >> >                        printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
> >> >> > -                       return -EINVAL;
> >> >> > +                       break;
> >> >>
> >> >> hmm, if the warning was wrapped in #ifdef CONFIG_SHMEM, i'd be ok with
> >> >> this.  otherwise we end up with warnings that can (should) be ignored
> >> >> when tmpfs is being emulated with ramfs.
> >> >
> >> > We may change the "ramfs:" accordingly. But *silently* ignoring
> >> > options is bad anyway?
> >>
> >> i really hate nitpicking such minor shit, but reality is that output
> >> displayed in the kernel log that is incorrect is going to cause me
> >> grief via customer support, updating documentation, adding FAQs,
> >> etc... and i doubt i'm the only one here.
> >
> > I don't think the message is "incorrect" - it is reminding user the fact.
> 
> when talking about ramfs, the message is correct -- the option is
> wrong.  when talking about tmpfs emulated by ramfs, that may be a
> matter of opinion.  i can understand why you still prefer a warning,
> but there is a significant body of people out there (myself including)
> that views warnings generally as something that should be addressed.

Right. It will upset me, too. It's kind of this situation: "I knew it
(that the option takes no effect), but please shut up!" ;-)

> ignoring that, people who see warnings and dont understand what's
> going on will ask/complain/whatever to someone somewhere.  including
> an explanatory message along side the warning will make that number go
> down, but it wont go away, and it sucks to have to do that.  ive seen

Yes that's truth. People are often ignoring.

> people ask questions where they copy & paste error messages that
> already included explanatory text in it telling them how to
> fix/resolve/research the issue.  i'm sure you have too :).

Too bad this happened to me countless times..

> >> my requirement is simple: valid tmpfs options should be silently
> >> consumed (i.e. ignored) when tmpfs is being emulated by ramfs (i.e.
> >> CONFIG_SHMEM=n).
> >>
> >> so how about:
> >> default:
> >>     if (!strcmp(sb->s_id, "ramfs"))
> >>         printk(KERN_WARNING "%s: ignoring mount option: %s\n", sb->s_id, p);
> >>     break;
> >
> > This is going overly complex, maybe we just revert to Hugh's original
> > patch for *complete* compatibility?
> 
> if my basic requirement is met, i dont care much about the details
> beyond that :).

OK. Let's do it the Hugh way. Thanks for the explanations!

Thanks,
Fengguang
