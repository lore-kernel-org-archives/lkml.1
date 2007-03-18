Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbXCRGKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbXCRGKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 02:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXCRGKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 02:10:20 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:51673
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbXCRGKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 02:10:18 -0400
Date: Sat, 17 Mar 2007 23:09:49 -0700
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>, Avi Kivity <avi@argo.co.il>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: is RSDL an "unfair" scheduler too?
Message-ID: <20070318060949.GA13583@gnuppy.monkey.org>
References: <200703042335.26785.a1426z@gawab.com> <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu> <45FC525D.5000708@argo.co.il> <20070318012533.GB2986@holomorphy.com> <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org> <20070318052439.GT943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318052439.GT943@1wt.eu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 06:24:40AM +0100, Willy Tarreau wrote:
> > Dunno. I guess a lot of people would like to then manage the classes, 
> > which would be painful as hell. 
> 
> Sure ! I wouldn't like people to point the finger on Linux saying "hey
> look, they can't write a good scheduler so you have to adjust the knobs
> yourself!". I keep in mind that Solaris' scheduler is very good, both
> fair and interactive. FreeBSD was good (I haven't tested for a long time).
> We should manage to get something good for most usages, and optimize
> later for specific uses.

Like I've said in a previous email, SGI schedulers have an interactive
term in addition to the normal "nice" values. If RSDL ends up being too
rigid for desktop use, then this might be a good idea to explore in
addition to priority manipulation.

However, it hasn't been completely proven that RSDL can't handle desktop
loads and that needs to be completely explored first. It certain seems
like, from the .jpgs that were posted earlier in the thread regarding mysql
performance, that RSDL seems to have improved performance for those set
ups so it's not universally the case that it sucks for server loads. The
cause of this performance difference has yet to be pinpointed.

Also, bandwidth scheduler like this are a new critical development for
things like the -rt patch. It would benefit greatly if the RSDL basic
mechanisms (RR and deadlines) were to somehow slip into that patch and
be used for a more strict -rt based scheduling class. It would be the basis
for first-class control over process resource usage and would be a first
in Linux or any mainstream kernel.

This would be a powerful addition to Linux as a whole and RSDL should
not be dismissed without these considerations. If it can somehow be
integrated into the kernel with interactivity concerns addressed, then
it would be an all out win for the kernel in both these areas.

bill

