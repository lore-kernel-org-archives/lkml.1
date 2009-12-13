Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbZLMMad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbZLMMad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 07:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZLMMac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 07:30:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61142 "HELO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750733AbZLMMab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 07:30:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Airlie <airlied@redhat.com>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Sun, 13 Dec 2009 12:30:25 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00049-gd6073d7; KDE/4.3.2; x86_64; ; )
Cc: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       jbarnes@virtuousgeek.org, Daniel Vetter <daniel.vetter@ffwll.ch>
References: <200912071830.14697.arnd@arndb.de> <1260337087.3658.1.camel@t60prh> <200912131218.24426.arnd@arndb.de>
In-Reply-To: <200912131218.24426.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912131230.25781.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Mv/B2Qbgq18WJnN9+ssS7pBJVWjvkOE1POME
 SfpHuPGiy1+jgQyYsMY+T8plN0IwfCWHI7kUxS8kcTxy4GsY8v
 eAqdwmS9J7XljSXdcHEYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 December 2009 12:18:24 Arnd Bergmann wrote:
> On Wednesday 09 December 2009 05:38:07 Dave Airlie wrote:
> > On Wed, 2009-12-09 at 00:07 +0100, Arnd Bergmann wrote:
> > > On Tuesday 08 December 2009, Dave Airlie wrote:
> > > > > 
> > > > > Sorry for blaming the wrong patch, especially if it already caused a lot 
> > > > > of work. I'll try blaming ec2a4c3fdc8 "drm/i915: get the bridge device
> > > > > once" now, that is the next-best candidate that my bisection pointed to,
> > > > > but I'll do more rigorous testing.
> > > 
> > > It just crashed again with both 620f378 and ec2a4c3fdc8 reverted as well, 
> > > after about an hour of uptime.
> > > 
> > ...
> > 
> > regression since 2.6.31 by the looks of it, bisection has found two
> > false positives so far.
> 
> I did a more thorough bisection this time, which points to c05422d52ee6b
> "drm/i915: remove open-coded drm_mode_object_find". The system crashed
> within minutes with 2.6.32-git and with c05422d52ee6b, but stayed up
> for 12 hours on identical kernels with this one reverted:
> 
> >  From c05422d52ee6b4cff8b63eab1a7351780518fc5e Mon Sep 17 00:00:00 2001
> >  From: Daniel Vetter <daniel.vetter@ffwll.ch>
> >  Date: Tue, 11 Aug 2009 16:05:30 +0200
> >  Subject: [PATCH] drm/i915: remove open-coded drm_mode_object_find

And now it's obvious that my computer hates me. 12 hours of uptime, one reboot
to check the old other version is broken, it crashes. I reboot into the
good version, send out the above email and the next minute it crashes again.
c05422d52ee6b is not the culprit. Sorry Daniel for blaming your patch.

	Arnd
