Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbZLNSVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbZLNSVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbZLNSVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:21:45 -0500
Received: from outbound-mail-147.bluehost.com ([67.222.38.37]:47415 "HELO
	outbound-mail-147.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932355AbZLNSVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:21:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GEl4BywCCC12vXJT5VZ4RJ+eSLB9xZlFkfoBs3kDoGcsdv2CuWge0KkfU5ym60ZEkyaza2wDBZtxc/lciL2CZtnq9T8DyC3obRA1JWVvE4+wrIU1k8AUxxxQpIUlZksu;
Date: Mon, 14 Dec 2009 10:20:15 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Vetter <daniel@ffwll.ch>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
Message-ID: <20091214102015.2f43f5b4@jbarnes-piketon>
In-Reply-To: <1260741245.3123.0.camel@t60prh>
References: <200912071830.14697.arnd@arndb.de>
	<200912131230.25781.arnd@arndb.de>
	<20091213200017.GA3522@viiv.ffwll.ch>
	<200912132131.07100.arnd@arndb.de>
	<1260741245.3123.0.camel@t60prh>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 07:54:05 +1000
Dave Airlie <airlied@redhat.com> wrote:

> On Sun, 2009-12-13 at 21:31 +0000, Arnd Bergmann wrote:
> > On Sunday 13 December 2009 20:00:18 Daniel Vetter wrote:
> > > On Sun, Dec 13, 2009 at 12:30:25PM +0000, Arnd Bergmann wrote:
> > > > And now it's obvious that my computer hates me. 12 hours of
> > > > uptime, one reboot to check the old other version is broken, it
> > > > crashes. I reboot into the good version, send out the above
> > > > email and the next minute it crashes again. c05422d52ee6b is
> > > > not the culprit. Sorry Daniel for blaming your patch.
> > > 
> > > No problem. Looks like your hunting a pretty ugly Heisenbug.
> > > There's quite a interesting blog post by Paul McKenney, esp. the
> > > solution to "Quick Quiz 1" might be usefull in your case:
> > > 
> > > http://paulmck.livejournal.com/14639.html
> > 
> > Thanks! In fact I've actually read that post on the kernel planet
> > and decided to do basically a linear search through the i915
> > patches merged into 2.6.32.
> > 
> > The current result is 67cf781bea5 "drm/i915: Make the downclocking
> > debug code be under DRM_DEBUG not DRM_ERROR." is known bad, while
> > 043029655 "drm/i915: Support IGD EOS" is probably good, pointing to
> > Jesses 652c393a33 "drm/i915: add dynamic clock frequency control"
> > as the next best guess. Unfortunately, that is a rather large
> > change that is not easy to revert on current kernels.
> 
> That seems the most likely, perhaps jbarnes can comment.

You can disable most of that code by loading i915 with 'powersave=0'.
If that patch really is at fault the powersave=0 should work around the
issue as well.

It's been implicated in another issue (some display flicker and
underruns) so I'm pretty sure there's something wrong with it in some
configurations at least...

-- 
Jesse Barnes, Intel Open Source Technology Center
