Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135Ab0ANVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0ANVVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998Ab0ANVVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:21:39 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:43182 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754894Ab0ANVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:21:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HRE+TJlLWoWbn3z9Jhn/xdzZdd6LCZq4B5ZOTihH2a00YmesXVRKjQJnejVdwnMR2f1uq/qjzrWZNq1OVNNuBniU/+G3u4eqCG45ED2A2wU9Mvfc8mX3P7obBnaREa32;
Date: Thu, 14 Jan 2010 13:21:38 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Clifton <pcjc2@cam.ac.uk>, Nick Bowler <nbowler@elliptictech.com>,
       airlied@linux.ie, intel-gfx@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable LVDS downclock by default
Message-ID: <20100114132138.4991054d@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1001141302360.13231@localhost.localdomain>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	<84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
	<20100113133357.67f9df6d@jbarnes-piketon>
	<4B4E403C.1050509@cs.helsinki.fi>
	<20100113165530.2a7e7645@jbarnes-piketon>
	<4B4F6D5F.10008@cs.helsinki.fi>
	<20100114193118.GA1203@emergent.ellipticsemi.com>
	<84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
	<20100114202803.GA1749@emergent.ellipticsemi.com>
	<20100114124802.025bbcae@jbarnes-piketon>
	<1263502711.16937.5.camel@pcjc2lap>
	<alpine.LFD.2.00.1001141302360.13231@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 13:05:17 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 14 Jan 2010, Peter Clifton wrote:
> > 
> > Would it not be a better idea to turn this feature on by default,
> > then use quirks to disable it on the afflicted borken machines?
> 
> No.
> 
> "Working" is good. "Broken" is bad.
> 
> We don't default to clearly unsafe models.
> 
> Maybe a few years from now, when people have learnt to do power
> management correctly and BIOSes fill in the fields right, we can
> reconsider. But right now, it's _way_ more important that things work
> reliably.
> 
> That said, I think a module parameter is the wrong thing. If this can
> be done dynamically with a sysfs value, do it that way instead (yes,
> I realize that module parameters end up being also visible in /sys,
> but I think Jesse's patch doesn't allow a person to set the value -
> and make it change the behavior - _while_ the display is all up and
> running).

Having a runtime option would be good, but we'd have to do some extra
code for that since the feature is either enabled or disabled at LVDS
and VBIOS parse time only.

With a sysfs interface we could allow the user to select the timing for
their reduced mode though, which would give them more power saving
potentially (if their panel worked with a very low refresh).

I can do that, but it seems more appropriate for 2.6.34?  I'd just
remove the module param at that time I guess.

-- 
Jesse Barnes, Intel Open Source Technology Center
