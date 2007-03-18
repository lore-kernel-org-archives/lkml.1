Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbXCRDVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbXCRDVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 23:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXCRDVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 23:21:19 -0400
Received: from pfepc.post.tele.dk ([195.41.46.237]:40687 "EHLO
	pfepc.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbXCRDVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 23:21:18 -0400
X-Greylist: delayed 169976 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Mar 2007 23:21:17 EDT
Subject: Re: is RSDL an "unfair" scheduler too?
From: Kasper Sandberg <lkml@metanurb.dk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <45FCA051.2080008@tmr.com>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172302.10819.kernel@kolivas.org>	<20070317122831.GA28429@elte.hu>
	 <200703172343.53480.kernel@kolivas.org>  <45FCA051.2080008@tmr.com>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 04:20:56 +0100
Message-Id: <1174188056.10498.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 21:13 -0500, Bill Davidsen wrote:
> Con Kolivas wrote:
<snip>
> 
> Now for something constructive... by any chance is Mike running KDE 
> instead of GNOME? I only had a short time to play because I had to look 
> at another problem in 2.6.21-rc3 (nbd not working), so the test machine 
> is in use. But it looked as if behavior was not as smooth with KDE. May 
> that thought be useful.

Now i must say here, i use KDE, and have been testing 0.31, and i have
been observing all the effects, in contrast with vanilla and staircase.
this is on 2.6.20

I do not notice kde being slower, in fact i notice various interactivity
"speedups" compared to mainline.

first one i noticed(because i deliberately tested) was kicker. Kickers
hide function was very very smooth during boot, and still is under load.
It is not entirely as smooth under vanilla during boot(i suspect IO
issue), under staircase it is, however under huge loads, it even is not
smooth under staircase.

then i started my konsole, and the one thing i immediately noticed was
that zsh started instantly, usually i can see/(feel) zsh starting, as in
it takes like 0.2 before my prompt comes. This is simply gone now with
rsdl, behavior used to be the same in vanilla/rsdl.

But the most interresting, and dare i say, completely unexpected things
are much more important.

I have for a long time had issues with tvtime, if i did stuff like move
windows, tvtime would drop frames, or simply hovering javascript stuff
on sites in konqueror, (this seemed to be introduced in 2.6.~5+), cause
in EARLY 2.6 i did not have this problem, but it was the same in
staircase and vanilla. But this is gone completely, tvtime no longer
drops any frames when doing this.

Another thing i noticed, which almost blew my mind as badly as with
tvtime, was with wine, and world of warcraft(and nvidia blob driver, but
this IS what many "desktop" users runs). While loading a level, the
sound no longer skipped. This problem afaik, EVERYBODY which runs wine
+wow has(unless they change the buffer size to ridicoulesly high which
annoys gameplay).

And more playing wow has shown me that rsdl seems to be doing an
extremely good job of not letting other tasks interfere. For example i
have spamasassin going quite very often (every minute, for lots of
accounts), and this usually kills all sorts of high performance opengl
stuff, causing severe stuttering, but with RSDL i only noticed my
framerate dropping, but no strange stuttering as i usually experience,
only lowered fps, which to me is quite natural, as spamasassin now has
to use cpu.

the last of my immediate observations are ktorrent. my ktorrent has LOTS
of open fd's (in fact like ~5-6k), and the application tends to be very
sluggish, but that is not so anymore.


And now for the side effects i have observed.

The only down right "regression" (which i wouldnt even call it, cause
its a NATURAL thing when other stuff uses cpu) is that when i play a
movie in kaffeine, and move the kaffeine window insanely fast all over
the desktop, the audio skipped once, the strange thing is, even if i
keep moving it, it does not skip any more, only the one time when you
start to move it. But 720p h264 does take SOME cpu to decode, so i dont
feel that this is unfair.

i have however with X observed that under high load(720p h264 video
playback, while doing video encoding, ktorrent running, and make
running) that windows take longer time to redraw in X, if i move windows
over each other, but not really a problem.

another effect i have observed is that stuff does not stutter as much
when under load, it simply gets slower.(but i suppose thats what i said
when describing the good effects i have noticed)

it should be noted that i have not reniced a single thing, and this is a
singlecore amd64 2ghz with 1.5gb ram.



> 

