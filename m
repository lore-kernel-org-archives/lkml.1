Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab0BDVfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:35:01 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:47453 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932359Ab0BDVe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:34:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KAOH0AuP8aBbGKCCkAqkdAa+Nnj/jBqT7U4oUINtscJWDU7v2ckj4ELitrqymfLPwF83hv2Xk9Vs+yvMyIpxyDO7DmWEChFwTr13hFqqKQS03lXYr/CzUEHtUj6kFpQU;
Date: Thu, 4 Feb 2010 13:34:13 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, Alex Deucher <alexdeucher@gmail.com>,
       torvalds@linux-foundation.org
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204133413.3450276d@jbarnes-piketon>
In-Reply-To: <20100204132346.85ea0d9f.akpm@linux-foundation.org>
References: <20100204175445.GB27361@elte.hu>
 <20100204175928.GA20595@srcf.ucam.org>
 <20100204181218.GA6175@elte.hu>
 <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
 <20100204190649.GB6665@elte.hu>
 <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
 <20100204193232.GD6665@elte.hu>
 <20100204115316.69beee75@jbarnes-piketon>
 <20100204202254.GA24716@elte.hu>
 <20100204204829.GA24608@srcf.ucam.org>
 <20100204210559.GC19050@elte.hu>
 <20100204132346.85ea0d9f.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 13:23:46 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 4 Feb 2010 22:05:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > 
> > > On Thu, Feb 04, 2010 at 09:22:54PM +0100, Ingo Molnar wrote:
> > > 
> > > >   " Hey, -rc7 just hung on me after enabling this new .config
> > > > option it offered for the radeon driver i am using, please add
> > > > this to the list of regressions. "
> > > 
> > > If the same configuration options hang on both an old kernel and
> > > a new kernel, how is that in any plausible way a regression?
> > > What's regressed?
> > 
> > Regressions are not limited to 'same config' kernels, last i
> > checked. If that has changed (or if i'm misunderstanding it) then
> > it would be nice to hear a clarification about that from Linus.
> > 
> > The way i understand it is that there are narrow exceptions from
> > the regression rules, such as completely new drivers for which
> > there can be no prior expectation of stability by users. (but for
> > even them we are generally on the safer side to list bugs in them
> > as regressions as well - especially if we expect many users to
> > enable it.)
> > 
> > AFAIK there's no exception for new sub-features of existing
> > facilities or drivers, even if it's default-disabled.
> > 
> > This issue materially affects quite a few bugs i'm handling as a
> > maintainer. Many of them are under default-off config options -
> > most new aspects to existing code are introduced in such a way. It
> > would remove quite a bit of urgent-workload from my workflow if i
> > could strike them from Rafael's list and could deprioritize them as
> > "plain bugs", to be fixed as time permits.
> > 
> > IMHO it would be rather counter-productive to kernel quality if we
> > did that kind of regression-lawyering though.
> > 
> 
> Yes, it's mainly semantics.
> 
> >From the user's point of view
> 
> kernel N: boots, works, plays nethack
> kernel N+1: goes splat
> 
> That kernel regressed for that user.  He'll shrug and will go back to
> kernel N and we lost an N+1 tester.  And the distros who ship N+1 get
> a lot of hack work to do.
> 
> If the feature is this buggy, it was wrong to make it accessible in
> Kconfig.
> 
> 
> Anyway.  The number of DRI regressions which have come in over the
> past few weeks is really quite extraordinary.  We're now showing 31
> open DRI regressions in bugzilla, but a lot of those are presumably
> defunct.
> 
> It's been bad ever since the KMS stuff went in.  That's understandable
> given the magnitude of the change, I guess, but the wheels really seem
> to have falled off in 2.6.32 and 2.6.33.

Yeah the number of regressions we have is out of hand.  I expected a
lot of bugs when moving all this code into the kernel though; after all
we've just shifted many of the problems from one code base to another.
We've eliminated whole classes of bugs with the KMS and memory
management architecture in general, but fundamentally display
management is a complex problem, there are a ton of configs to worry
about so it's really hard to fix things or add features without
breaking anything.

Not that this excuses our big regression list...  I'll make some time
for tracking these things better and getting them assigned.

-- 
Jesse Barnes, Intel Open Source Technology Center
