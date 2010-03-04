Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0CDXxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:53:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750Ab0CDXxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:53:49 -0500
Date: Thu, 4 Mar 2010 15:53:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <21d7e9971003041535g9dbfe46k67f64aa4219da0b8@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003041538380.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>  <20100304192524.GA24253@srcf.ucam.org>  <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>  <20100304195302.GA24856@srcf.ucam.org>  <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
  <6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com>  <alpine.LFD.2.00.1003041449380.3751@localhost.localdomain>  <21d7e9971003041503p726ecbebi4b0b97854c5824de@mail.gmail.com>  <alpine.LFD.2.00.1003041507070.3751@localhost.localdomain> 
 <alpine.LFD.2.00.1003041522570.3751@localhost.localdomain> <21d7e9971003041535g9dbfe46k67f64aa4219da0b8@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Dave Airlie wrote:
> 
> I'm not saying it doesn't happen in other drivers from time to time, but 
> when it does its treated as regression, for nouveau and STAGING that 
> isn't what the Nouveau project (which Stephane mostly speaks for) seems 
> to want at this stage.

The problem with "at this stage" is that the stage has apparently been 
on-going for several years. 

Even if Stepane doesn't care, people inside RedHat/Fedora must care. Are 
you guys simply planning on never supporting F12 with 2.6.34?  I'd expect 
it to be a _major_ pain to have that whole hardcoded "X and kernel must 
always change in lockstep".

And the sad part is, it would be so nice if the X server would just dlopen 
the right thing automatically, so that the low-level driver wouldn't even 
need to care. It already does the whole "discover which driver to load" 
part, wouldn't it be nice if that code had automatic versioning too, and 
then a low-level driver really wouldn't have to care, everything would 
automatically do the right thing just when the version changes.

Of course, the distro would still have to make all the different versions 
of libdrm available to users, but now updating one wouldn't screw over the 
others. So if you had a known-good setup with nouveau-0.0.15, you could 
install a nouveau-0.0.16 thing and _know_ that it won't affect that 
previous install at all.

And yeah, I realize that those version numbers are "wrong". Normal library 
versioning rules about patchlevel not changing semantics are obviously 
broken here. But maybe the rules could even try to first start with the 
exact version, ie do a "driver-x.y.z.so" load, then a "driver-x.y.so" 
load, then a "driver-x.so" load and finally a "driver.so" load.

But I guess that nothing even does that drmGetVersion() until the nouveau 
driver has already been loaded. Which kind of forces the low-level drivers 
to do any such versioning on their own. 

But wouldn't it be nice if something like this was done at a higher level, 
so that the drivers really wouldn't even need to care?

			Linus
