Return-Path: <linux-kernel-owner+w=401wt.eu-S965917AbXCFPMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965917AbXCFPMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965924AbXCFPMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:12:53 -0500
Received: from [212.12.190.221] ([212.12.190.221]:32912 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965917AbXCFPMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:12:52 -0500
From: Al Boldi <a1426z@gawab.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Tue, 6 Mar 2007 18:15:16 +0300
User-Agent: KMail/1.5
Cc: Markus =?iso-8859-1?q?T=F6rnqvist?= <mjt@nysv.org>,
       ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>
References: <200703042335.26785.a1426z@gawab.com> <200703060910.06343.kernel@kolivas.org> <1173170554.5835.385.camel@frg-rhel40-em64t-03>
In-Reply-To: <1173170554.5835.385.camel@frg-rhel40-em64t-03>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703061815.16702.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel wrote:
> On Tue, 2007-03-06 at 09:10 +1100, Con Kolivas wrote:
> > Hah I just wish gears would go away. If I get hardware where it runs at
> > just the right speed it looks like it doesn't move at all. On other
> > hardware the wheels go backwards and forwards where the screen refresh
> > rate is just perfectly a factor of the frames per second (or something
> > like that).
> >
> > This is not a cpu scheduler test and you're inferring that there are cpu
> > scheduling artefacts based on an application that has bottlenecks at
> > different places depending on the hardware combination.
>
> I'd add that Xorg has its own scheduler (for X11 operations, of course),
> that has its own quirks, and chances are that it is the one you're
> testing with glxgears. And as Con said, as long as glxgears does more
> FPS than your screen refresh rate, its flickering its completely
> meaningless: it doesn't even attempt to sync with vblank. Al, you'd
> better try with Quake3 or Nexuiz, or even Blender if you want to test 3D
> interactivity under load.

Actually, games aren't really usefull to evaluate scheduler performance, due 
to their bursty nature.

OTOH, gears runs full throttle, including any of its bottlenecks. In fact, 
it's the bottlenecks that add to its realism.  It exposes underlying 
scheduler hickups visually, unless buffered by the display-driver, in which 
case you just use the vesa-driver to be sure.

If gears starts to flicker on you, just slow it down with a cpu hog like:

	# while :; do :; done &

Add as many hogs as you need to make the hickups visible.

Again, these hickups are only visible when using uneven nice+ levels.

BTW, another way to show these hickups would be through some kind of a 
cpu/proc timing-tracer.  Do we have something like that?


Thanks!

--
Al

