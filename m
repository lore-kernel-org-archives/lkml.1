Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYEERcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYEERcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYEERcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:32:45 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:39463 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057AbYEERco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:32:44 -0400
From: Frans Pop <elendil@planet.nl>
To: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: [git head] Should X86_PAT really default to yes?
Date: Mon, 5 May 2008 19:32:40 +0200
User-Agent: KMail/1.9.9
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl> <200805050857.57661.jesse.barnes@intel.com>
In-Reply-To: <200805050857.57661.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200805051932.41827.elendil@planet.nl>
X-OriginalArrivalTime: 05 May 2008 17:32:42.0550 (UTC) FILETIME=[05E9C560:01C8AED6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sigh. This is going to get complex...

On Monday 05 May 2008, Jesse Barnes wrote:
> > > If so, it might not be a PAT issue but just a different memory layout
> > > or something (and therefore it would really just be a cosmetic bug in
> > > the X driver).
> >
> > The artifacts may not be a PAT issue directly, but it is a clear
> > regression for me as I currently have a nice clean screen when X shuts
> > down. I'm also 100% sure that it is caused by enabling PAT. A kernel
> > with same config and only PAT disabled does not show the artifacts.
> >
> > Would you like me to file a bug against X for these artifacts?
> > If so, against what component? The i810 driver or the server?
>
> I suspect an i810 driver bug is being uncovered here, since we do have
> transient VT switch corruption on some other platforms (we're just
> exposing our chip reprogramming on the screen, rather than keeping it off
> the whole time).  But there could also be something PAT specific going
> on, I'll have to walk through those code paths...

I suspect it could be vesafb/fbcon related instead. Normally I boot my 
system with 'quiet vga=791', i.e. with vesafb. I then see the artifacts.

When I boot without 'vga=791', I hit another, unrelated regression (which 
I'll report separately) [1].

When I boot with 'video=vfb:off', I do _not_ get the artifacts when X exits.

Note that the "expected mapping type" errors remain the same both with and 
without framebuffer console.


> Oh the messages should be removed or somehow minimized, I agree.  I'm
> just not sure if the other bug is serious enough to block PAT by default
> yet, but either way we should fix the bugs!

OK. Thanks. Guess you've also seen "Xorg crash with xf86MapVidMem error" 
that turned out to be due to PAT: 
http://www.gossamer-threads.com/lists/linux/kernel/915300 ?

Cheers,
FJP

[1] Short version of this unrelated issue.
If I boot without vga=791 the console stops being updated after PCI probes.
At first I thought this was #9310, but this time it's unrelated to the 
config option mentioned there. Symptoms are awfully similar though.
