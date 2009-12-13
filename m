Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZLMV4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZLMV4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZLMV4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:56:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25653 "HELO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754332AbZLMV4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:56:12 -0500
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
From: Dave Airlie <airlied@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel@ffwll.ch>, Adam Jackson <ajax@redhat.com>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       keithp@keithp.com, eric@anholt.net, jbarnes@virtuousgeek.org,
       Daniel Vetter <daniel.vetter@ffwll.ch>
In-Reply-To: <200912132131.07100.arnd@arndb.de>
References: <200912071830.14697.arnd@arndb.de>
	 <200912131230.25781.arnd@arndb.de> <20091213200017.GA3522@viiv.ffwll.ch>
	 <200912132131.07100.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 07:54:05 +1000
Message-Id: <1260741245.3123.0.camel@t60prh>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-13 at 21:31 +0000, Arnd Bergmann wrote:
> On Sunday 13 December 2009 20:00:18 Daniel Vetter wrote:
> > On Sun, Dec 13, 2009 at 12:30:25PM +0000, Arnd Bergmann wrote:
> > > And now it's obvious that my computer hates me. 12 hours of uptime, one reboot
> > > to check the old other version is broken, it crashes. I reboot into the
> > > good version, send out the above email and the next minute it crashes again.
> > > c05422d52ee6b is not the culprit. Sorry Daniel for blaming your patch.
> > 
> > No problem. Looks like your hunting a pretty ugly Heisenbug. There's quite
> > a interesting blog post by Paul McKenney, esp. the solution to "Quick Quiz 1"
> > might be usefull in your case:
> > 
> > http://paulmck.livejournal.com/14639.html
> 
> Thanks! In fact I've actually read that post on the kernel planet and decided
> to do basically a linear search through the i915 patches merged into 2.6.32.
> 
> The current result is 67cf781bea5 "drm/i915: Make the downclocking debug code
> be under DRM_DEBUG not DRM_ERROR." is known bad, while 043029655 "drm/i915:
> Support IGD EOS" is probably good, pointing to Jesses 652c393a33 "drm/i915:
> add dynamic clock frequency control" as the next best guess. Unfortunately,
> that is a rather large change that is not easy to revert on current kernels.

That seems the most likely, perhaps jbarnes can comment.

Dave.


