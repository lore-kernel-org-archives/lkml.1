Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZLMVc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZLMVc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZLMVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:32:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49222 "HELO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753352AbZLMVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:32:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Sun, 13 Dec 2009 21:31:07 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00047-g0430296; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, Adam Jackson <ajax@redhat.com>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       keithp@keithp.com, eric@anholt.net, jbarnes@virtuousgeek.org,
       Daniel Vetter <daniel.vetter@ffwll.ch>
References: <200912071830.14697.arnd@arndb.de> <200912131230.25781.arnd@arndb.de> <20091213200017.GA3522@viiv.ffwll.ch>
In-Reply-To: <20091213200017.GA3522@viiv.ffwll.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912132131.07100.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19B5A0YqSZCTUnbFutUd3S0pzHsoZOoj7E8Hli
 mxk0BcCG//I0zqCOdMPCDblumABolUQpzenPCgLo4sOfTFPp/b
 2vL0UmtqgNqbheJzFbWgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 December 2009 20:00:18 Daniel Vetter wrote:
> On Sun, Dec 13, 2009 at 12:30:25PM +0000, Arnd Bergmann wrote:
> > And now it's obvious that my computer hates me. 12 hours of uptime, one reboot
> > to check the old other version is broken, it crashes. I reboot into the
> > good version, send out the above email and the next minute it crashes again.
> > c05422d52ee6b is not the culprit. Sorry Daniel for blaming your patch.
> 
> No problem. Looks like your hunting a pretty ugly Heisenbug. There's quite
> a interesting blog post by Paul McKenney, esp. the solution to "Quick Quiz 1"
> might be usefull in your case:
> 
> http://paulmck.livejournal.com/14639.html

Thanks! In fact I've actually read that post on the kernel planet and decided
to do basically a linear search through the i915 patches merged into 2.6.32.

The current result is 67cf781bea5 "drm/i915: Make the downclocking debug code
be under DRM_DEBUG not DRM_ERROR." is known bad, while 043029655 "drm/i915:
Support IGD EOS" is probably good, pointing to Jesses 652c393a33 "drm/i915:
add dynamic clock frequency control" as the next best guess. Unfortunately,
that is a rather large change that is not easy to revert on current kernels.

I'll keep running my machine on the 043029655 level and tell you if it keeps
working a few more days.

	Arnd
