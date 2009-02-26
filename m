Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZBZA47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZBZA47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZBZA4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:56:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59866 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbZBZA4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:56:47 -0500
Date: Thu, 26 Feb 2009 01:56:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Kyle McMartin <kyle@infradead.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 0/7] Use strict kernel types to fix the world
Message-ID: <20090226005622.GA30255@elte.hu>
References: <20090225235138.062045835@arndb.de> <200902260124.13641.arnd@arndb.de> <49A5E28F.5050209@zytor.com> <200902260152.23410.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200902260152.23410.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 26 February 2009, H. Peter Anvin wrote:
> > I'm really of two minds regarding the patches that replace pure data 
> > types (2/7-5/7).  Part of me thinks it would be better to do this via a 
> > script in make headers_install, but another part of me thinks that that 
> > is a recipe for missing includes.
> > 
> > However, if subsystem maintainers are sharing headers with other 
> > platforms, it's probably the only sane road to go.
> 
> The only file I found that is obviously shared across 
> operating systems is linux/coda.h, and I completely left that 
> one alone on the basis that the hacks in there should still 
> work with the new linux/types.h.
> 
> Doing an automated conversion on coda.h would guarantee 
> trouble, which I see as an argument for doing the manual 
> approach in general.
> 
> The changes outside of mtd, netfilter, drm and pfkeyv2.h are 
> actually pretty minimal. For reference, all other patches 
> touching those files since 2.6.28 have a combined diffstat of
> 
>  include/drm/drm.h                      |   26 +++-
>  include/drm/drm_mode.h                 |  271 ++++++++++++++++++++++++++++++++
>  include/drm/i915_drm.h                 |   43 +++++-
>  include/linux/agpgart.h                |    1 -
>  include/linux/cyclades.h               |    2 -
>  include/linux/dvb/audio.h              |    5 -
>  include/linux/dvb/video.h              |    7 +-
>  include/linux/if_pppol2tp.h            |    2 +-
>  include/linux/matroxfb.h               |    2 +-
>  include/linux/mroute6.h                |   26 +++-
>  include/linux/netfilter/x_tables.h     |    2 +-
>  include/linux/netfilter/xt_conntrack.h |    1 +
>  include/linux/pkt_sched.h              |   18 ++
>  include/linux/ppp_defs.h               |    2 +
>  include/linux/time.h                   |    1 +
>  include/linux/types.h                  |   24 ++--
>  include/linux/xfrm.h                   |   14 ++
>  include/mtd/inftl-user.h               |    2 +
>  include/mtd/ubi-user.h                 |  134 +++++++++++++---
>  include/sound/asound.h                 |    1 +
>  20 files changed, 530 insertions(+), 54 deletions(-)
> 
> As long as the netfilter, mtd and drm maintainers agree, I 
> don't see anything holding up the convert-everything-now 
> approach.

In addition to that we could also keep tip:core/header-fixes 
feature-free and pullable. So should any maintainer run into 
conflicts in that area the branch could be pulled into that 
tree. (the branch is focused on fixing the situation so 
generally pullable.)

	Ingo
