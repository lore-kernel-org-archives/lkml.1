Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXDPGbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXDPGbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbXDPGbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:31:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbXDPGbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:31:35 -0400
Date: Mon, 16 Apr 2007 02:29:21 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Message-ID: <20070416062921.GB7528@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Richard Purdie <rpurdie@rpsys.net>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <20070416005446.GB21217@redhat.com> <20070416011636.GO3691@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416011636.GO3691@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 03:16:37AM +0200, Adrian Bunk wrote:
 > On Sun, Apr 15, 2007 at 08:54:46PM -0400, Dave Jones wrote:
 > > On Mon, Apr 16, 2007 at 02:37:23AM +0200, Adrian Bunk wrote:
 > > 
 > >  > Subject    : ThinkPad X60: resume no longer works  (PCI related?)
 > >  >              workaround: booting with "hpet=disable"
 > >  > References : http://lkml.org/lkml/2007/3/13/3
 > >  > Submitter  : Dave Jones <davej@redhat.com>
 > >  >              Jeremy Fitzhardinge <jeremy@goop.org>
 > >  > Caused-By  : PCI merge
 > >  >              commit 78149df6d565c36675463352d0bfe0000b02b7a7
 > >  > Handled-By : Eric W. Biederman <ebiederm@xmission.com>
 > >  >              Rafael J. Wysocki <rjw@sisk.pl>
 > >  > Status     : unknown
 > > 
 > > note that this workaround doesn't seem to work in all cases.
 > > Mine may a slightly different model (I have the tablet version)
 > > but disabling hpet shows the same regression.
 > > I've been fighting Eric's USB debug cable code in the hope
 > > of getting _something_ useful out of it other than a black screen,
 > > but I've been getting nowhere with it.
 > 
 > I'm not sure why I thought you two ran into the same regression.

I'm not sure why I never hit the same bug that Jeremy did
(again, maybe subtle hardware differences between our models),
but I finally got somewhere.   -rc7 with the same config I've
been testing exhibited exactly the same bug.   Disabling
the FB_BACKLIGHT option (and all the FB drivers that 'select' it),
I get a working display on resume again.

This makes a lot of sense. As before, when I resumed, the backlight
wasn't coming back on, but I knew the machine was alive, as
capslock was working.  (Amusingly, I never noticed the backlight
wasn't coming back on until tonight, when I started debugging this
with the lights off.  Late-night debugging ftw).

I'll try and narrow down exactly where it's failing in the
backlight code next, but it's getting late here, so I may
leave this until tomorrow for further investigation.
Some other clues for anyone playing along at home:
This X60 has Intel graphics.  ie, I'm not using any of
the drivers that 'select FB_BACKLIGHT', so somewhere in
the common fb code is code that I'm guessing is dependant
upon the framebuffer driver doing something or other
if FB_BACKLIGHT is set.

(Adding Richard to Cc: as he seems to be responsible for
 the FB backlight code from what I can tell.)

	Dave

-- 
http://www.codemonkey.org.uk
