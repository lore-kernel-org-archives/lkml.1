Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbZLJSBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbZLJSBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761284AbZLJSBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:01:22 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:50930 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761275AbZLJSBW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:01:22 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2009 13:01:22 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cS7T0xQoNsPgvjkvuFGIlYJ4erh3ioc6RQdsx8l+6xxp5ofIoQBUCBDfMeWGk3ZPpp/d/OvhzwSNyqZb1k5cBvEgyxWnoDfo0izUeYPePr/v6s2q9LDPfGSjcdq54PFW;
Date: Thu, 10 Dec 2009 09:54:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Darren Salt <linux@youmustbejoking.demon.co.uk>,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       luto@myrealbox.com, eric@anholt.net
Subject: Re: 2.6.31 -> 2.6.32 Sound and video regressions
Message-ID: <20091210095422.3c5a75d1@jbarnes-piketon>
In-Reply-To: <c1f41c620912080520o7e0a69bdg7b885b4a17c6dbc@mail.gmail.com>
References: <4B1A6F78.8010408@myrealbox.com>
	<50CA8D92EC%linux@youmustbejoking.demon.co.uk>
	<20091206173222.4c2d5aaa@jbarnes-piketon>
	<c1f41c620912061952k4945a7c8j4567ab17424e4d91@mail.gmail.com>
	<c1f41c620912070538y4f865cechf21d2802ab237510@mail.gmail.com>
	<c1f41c620912080520o7e0a69bdg7b885b4a17c6dbc@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009 20:20:07 +0700
Emmanuel Benisty <benisty.e@gmail.com> wrote:

> On Mon, Dec 7, 2009 at 8:38 PM, Emmanuel Benisty
> <benisty.e@gmail.com> wrote:
> > On Mon, Dec 7, 2009 at 10:52 AM, Emmanuel Benisty
> > <benisty.e@gmail.com> wrote:
> >> On Mon, Dec 7, 2009 at 8:32 AM, Jesse Barnes
> >> <jbarnes@virtuousgeek.org> wrote:
> >>> On Sat, 05 Dec 2009 23:44:55 +0000
> >>> Darren Salt <linux@youmustbejoking.demon.co.uk> wrote:
> >>>
> >>>> I demand that Andy Lutomirski may or may not have written...
> >>>>
> >>>> > Emmanuel Benisty wrote:
> >>>> [snip]
> >>>> >> I just wanted to report 2 regressions I am having now with
> >>>> >> 2.6.32. Video
> >>>> >> Screen is flickering/glitching like crazy in X. It happens
> >>>> >> whether randomly or when conky is refreshed, when the mouse
> >>>> >> cursor moves and like hell when a page is loading in the
> >>>> >> browser. Not so easy to describe this issue.
> >>>> [snip]
> >>>>
> >>>> > That sounds like FIFO underruns, which (I think) were
> >>>> > introduced when self-refresh was enabled but should have been
> >>>> > fixed. I personally have no clue how to fix them, but if you
> >>>> > told the Intel people what kind of chip you have (lspci
> >>>> > output), they can probably fix it.
> >>>>
> >>>> It also sounds like what I'm seeing on my EeePC 901. It only
> >>>> happens after resume, which makes STR a little less than useful;
> >>>> the display will, sooner or later, show a single colour (which
> >>>> is, presumably, the result of a display engine hang, as
> >>>> described in the comment immediately before intel_calculate_wm)
> >>>> and, seemingly, be stuck like that until power-off or reboot.
> >>>>
> >>>> Whether it *is* the same problem, I couldn't say.
> >>>>
> >>>> Needless to say, this problem goes away if I disable KMS.
> >>>
> >>> Arg, there are a few reports of this now, but I haven't been able
> >>> to reproduce it.  I'll try harder...  (FYI the upstream
> >>> bugs.freedesktop.org # for it is 24314).
> >>
> >> It *seems* that we are facing two different issues here (I don't
> >> even use S2R and the problem is there since the very first second
> >> I start X). Anyway, I have bisected the problem on my box, it
> >> turns out to be this one:
> >>
> >> drm/i915: Fix render reclock availability detection
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=181a5336d6cc836f05507410d66988c483ad0154
> >>
> > So, I have reverted this commit and rebuilt 2.6.32. It completely
> > solved the issue described in my first post.
> >
> 
> just FTR, it looks like I'm not alone:
> http://forums.gentoo.org/viewtopic-p-6087556.html#6087556

Great, thanks for narrowing it down.  I'll see if I can come up with a
fix.

-- 
Jesse Barnes, Intel Open Source Technology Center
