Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbZC3XBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbZC3XBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZC3XBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:01:10 -0400
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:44905 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752101AbZC3XBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:01:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=R3qhlicUbE8FPhiRM1pEvg4X6nAYEw9V1tDpo8t/Z1nEPzjlN4JKtr2EYHwe1OEGnZ3aezSoAeyeXxEtz1N1+UMcWgufXxGn21XkbRrypk/ex2pU3ei+kR/HsRv8meTY;
Date: Mon, 30 Mar 2009 16:00:58 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org,
       Eric Anholt <eric@anholt.net>, dri-devel@lists.sourceforge.net
Subject: Re: enabling kms for i915 disables brightness control and xrandr
Message-ID: <20090330160058.502ca3f7@hobbes>
In-Reply-To: <1238453870.11937.72.camel@localhost>
References: <1238322841.4185.36.camel@localhost>
	<20090329130702.GA23660@sucs.org>
	<1238332957.4185.74.camel@localhost>
	<1238420239.4575.2.camel@localhost>
	<20090330143447.5653d522@hobbes>
	<1238453870.11937.72.camel@localhost>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 00:57:50 +0200
Soeren Sonnenburg <sonne@debian.org> wrote:

> On Mon, 2009-03-30 at 14:34 -0700, Jesse Barnes wrote:
> > On Mon, 30 Mar 2009 15:37:19 +0200
> > Soeren Sonnenburg <sonne@debian.org> wrote:
> > 
> > > On Sun, 2009-03-29 at 15:22 +0200, Soeren Sonnenburg wrote:
> > > > On Sun, 2009-03-29 at 14:07 +0100, Sitsofe Wheeler wrote:
> > > > > (CC'ing dri-devel, Eric Anholt and Jesse Barnes)
> > > > > 
> > > > > On Sun, Mar 29, 2009 at 12:34:01PM +0200, Soeren Sonnenburg
> > > > > wrote:
> > > > > > Dear all,
> > > > > > 
> > > > > > I am not sure if this is just a user error/ too old
> > > > > > userspace problem,
> > > > > 
> > > > > [User stated that 2.6.3 intel driver is being used in another
> > > > > email]
> > > > 
> > > > Just to not cause any (further?) confusion, I was using 2.6.1
> > > > when I wrote that email and after compiling/upgrading to 2.6.3
> > > > a number of problems vanished (like Xv works, screen resolution
> > > > is correct, things are *a lot* faster with UXA). However,
> > > > brightness still only works via setpci and xrandr only shows
> > > > the 1024x600 modeline.
> > > > 
> > > > > > but I recognized that when I enable kernel based
> > > > > > modesetting on a intel 945 based samsung nc 10 netbook, I
> > > > > > loose brightness control from within X and X resolutions
> > > > > > are wrong (instead of 1024x600 it is 1024x1024) and xrandr
> > > > > > does no longer have the all the modelines ranging from
> > > > > > 1024x600 to 640x350... Trying to change resolutions /
> > > > > > setting the brightness via xrandr results in error messages
> > > > > > being printed. 
> > > > > > 
> > > > > > Furthermore, this same flag disables Xv support..
> > > > > > 
> > > > > > However, screen switches between terminal and X are quite
> > > > > > fast now (without any flicker) and suspend and everything
> > > > > > works stably.
> > > > > > 
> > > > > > I recognized that I can set the brightness via
> > > > > > 
> > > > > > setpci -s 00:02.1 F4.B=XX
> > > > > > 
> > > > > > (XX ranging from 00 to FF) just fine...
> > > 
> > > One more thing: Connecting an external display I could turn it on
> > > via xrandr --auto successfully. However, it was not possible to
> > > turn the internal display off (xrandr --output LVDS1 --off) and
> > > switching to the console with the external display connected I
> > > managed to freeze the machine. Turning the external display off
> > > worked somehow (the display then showed vertical stripes) but I
> > > could switch to console.
> > 
> > Have you filed bugs for these problems?  I think the brightness
> > control issue is due to some missing bits on the 2D side (we don't
> > enable backlight property control when KMS is active, but should),
> > the other issues sound like bugs.
> 
> I did nothing besides asking here on lkml. Where should I report what?

Your xrandr problems should be reported at bugs.freedesktop.org against
the xf86-video-intel driver (in the xorg component).  A separate bug
report should be filed for the missing backlight property.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
