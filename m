Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbZFNLtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbZFNLtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbZFNLtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:49:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:50647 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbZFNLtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:49:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,217,1243839600"; 
   d="scan'208";a="154090555"
Date: Sun, 14 Jun 2009 19:49:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
Message-ID: <20090614114935.GA7489@localhost>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> <Pine.LNX.4.64.0906131456090.5069@sister.anvils> <20090614100110.GA19875@localhost> <20090614104212.GA5977@localhost> <8bd0f97a0906140346t6b19f00aq29cfd4c554682f07@mail.gmail.com> <20090614111440.GC6046@localhost> <8bd0f97a0906140426g5c9ad183qa258be91c17c929d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906140426g5c9ad183qa258be91c17c929d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 07:26:37PM +0800, Mike Frysinger wrote:
> On Sun, Jun 14, 2009 at 07:14, Wu Fengguang wrote:
> > On Sun, Jun 14, 2009 at 06:46:24PM +0800, Mike Frysinger wrote:
> >> On Sun, Jun 14, 2009 at 06:42, Wu Fengguang wrote:
> >> > On Sun, Jun 14, 2009 at 06:01:10PM +0800, Wu Fengguang wrote:
> >> > Sorry I take back the previous patch. It makes sense to not break
> >> > existing user space tools, but a warning message looks OK to remind
> >> > people of possibly unexpected behavior.
> >> >
> >> >                default:
> >> >                        printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
> >> > -                       return -EINVAL;
> >> > +                       break;
> >>
> >> hmm, if the warning was wrapped in #ifdef CONFIG_SHMEM, i'd be ok with
> >> this.  otherwise we end up with warnings that can (should) be ignored
> >> when tmpfs is being emulated with ramfs.
> >
> > We may change the "ramfs:" accordingly. But *silently* ignoring
> > options is bad anyway?
> 
> i really hate nitpicking such minor shit, but reality is that output
> displayed in the kernel log that is incorrect is going to cause me
> grief via customer support, updating documentation, adding FAQs,
> etc... and i doubt i'm the only one here.

I don't think the message is "incorrect" - it is reminding user the fact.

But I didn't know that ignorant users will ask you for customer
support on the "new" warning. Sorry.

> my requirement is simple: valid tmpfs options should be silently
> consumed (i.e. ignored) when tmpfs is being emulated by ramfs (i.e.
> CONFIG_SHMEM=n).
> 
> so how about:
> default:
>     if (!strcmp(sb->s_id, "ramfs"))
>         printk(KERN_WARNING "%s: ignoring mount option: %s\n", sb->s_id, p);
>     break;

This is going overly complex, maybe we just revert to Hugh's original
patch for *complete* compatibility? Sorry for making a fuss.

Thanks,
Fengguang
