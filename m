Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYGaTY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYGaTY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYGaTYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:24:15 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:35094 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbYGaTYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gtVpHbz9KyvrnhfPp/NFSLm9YZTJN69NSUEwe9PJ8Qxm6atMWUn3AbnrEZR7ij4Sct
         OzlXh2VcJ8F216swU8x8Xjdo0sPQUZxtkUpmM9iTuISwN1oP6t/FkMSxoI6HFGe7P730
         GpGxWfXG2I4QwmNo+zna2w2h60LJZVkUwUV44=
Date: Thu, 31 Jul 2008 15:24:02 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-ID: <20080731151625.ZZRA012@mailhub.coreip.homeip.net>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 12:10:40PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 31 Jul 2008, Dmitry Torokhov wrote:
> > > 
> > > Well, we're not supposed to break user space that we used to work with, even
> > > if it is known to be buggy.
> > 
> > No, I am sorry. We are not supposed to break userspace ABI, but that
> > is it. Can you vouch that 2.6.25 did not break a single userspace
> > program out there?
> 
> Dmitry - irrelevant. If we know of breakage, then that is a FACT, and it's 
> a regression, and it needs to be fixed.

Does it have to be papered over in the kernel though?

> 
> Trying to say "there might be _other_ breakage that we don't even know of" 
> does not change the situation ONE LITTLE BIT!
> 
> Don't you see how stupid that approach is? You're basically trying to make 
> excuses for known breakage by saying that there might be _other_ breakage 
> that we don't know about? Why the _hell_ do you think that is an excuse at 
> all?

We can only guarantee one thing - ABI. And that is kept intact. But I
literally have no idea if a kernel breaks a random program out there
that happens to have a bug.

> 
> > >  Many people use the older user space on their
> > > test systems which are not practical to upgrade.
> > 
> > I don't understand this - it is expected that everyone jumps and
> > upgrades their kernels with ease but updating broken userspace
> > bits is super-hard...
> 
> You're missing the point.
> 
> People are supposed to be able to upgrade things _independently_. It's not 
> about "you're supposed to be able to upgrade the kernel, but not upgrade 
> user space". It's about "you shouldn't evemn have to _worry_ about it.
> 
> > > IOW, if the change responsible for this makes it to the mainline kernel, it
> > > will be considered as a regression.
> > 
> > Like I said, I don't agree.
> 
> Sorry, but you're simply wrong.
> 
> If somebody has the commit that broke user space, that commit will be 
> _reverted_ unless it's fixed. It's that simple. The rules are: we don't 
> knowingly break user space. 
>

We have 3 options now:

1. Never change KEY_MAX and dont add any new key definitions.
2. Introduce a new ioctl and have all wel-behaving programs rewritten
   to support it.
3. Fix userspace driver (patch is available).

Gioventhe fact that I wanted that change to go when .28 opens and it
will really hit users in 6+ months I'd still like to have 3.
 
-- 
Dmitry
