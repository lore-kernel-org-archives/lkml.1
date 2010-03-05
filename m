Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0CEAYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 19:24:19 -0500
Received: from mail001.aei.ca ([206.123.6.130]:34916 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab0CEAYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 19:24:17 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] drm request 3
Date: Thu, 4 Mar 2010 19:24:01 -0500
User-Agent: KMail/1.13.1 (Linux/2.6.33-crc; KDE/4.4.1; x86_64; ; )
Cc: Dave Airlie <airlied@gmail.com>,
       Stephane Marchesin <stephane.marchesin@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <21d7e9971003041535g9dbfe46k67f64aa4219da0b8@mail.gmail.com> <alpine.LFD.2.00.1003041538380.3751@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003041538380.3751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003041924.02082.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 March 2010 18:53:32 Linus Torvalds wrote:
> 
> On Fri, 5 Mar 2010, Dave Airlie wrote:
> > 
> > I'm not saying it doesn't happen in other drivers from time to time, but 
> > when it does its treated as regression, for nouveau and STAGING that 
> > isn't what the Nouveau project (which Stephane mostly speaks for) seems 
> > to want at this stage.
> 
> The problem with "at this stage" is that the stage has apparently been 
> on-going for several years. 
> 
> Even if Stepane doesn't care, people inside RedHat/Fedora must care. Are 
> you guys simply planning on never supporting F12 with 2.6.34?  I'd expect 
> it to be a _major_ pain to have that whole hardcoded "X and kernel must 
> always change in lockstep".
> 
> And the sad part is, it would be so nice if the X server would just dlopen 
> the right thing automatically, so that the low-level driver wouldn't even 
> need to care. It already does the whole "discover which driver to load" 
> part, wouldn't it be nice if that code had automatic versioning too, and 
> then a low-level driver really wouldn't have to care, everything would 
> automatically do the right thing just when the version changes.
> 
> Of course, the distro would still have to make all the different versions 
> of libdrm available to users, but now updating one wouldn't screw over the 
> others. So if you had a known-good setup with nouveau-0.0.15, you could 
> install a nouveau-0.0.16 thing and _know_ that it won't affect that 
> previous install at all.
> 
> And yeah, I realize that those version numbers are "wrong". Normal library 
> versioning rules about patchlevel not changing semantics are obviously 
> broken here. But maybe the rules could even try to first start with the 
> exact version, ie do a "driver-x.y.z.so" load, then a "driver-x.y.so" 
> load, then a "driver-x.so" load and finally a "driver.so" load.
> 
> But I guess that nothing even does that drmGetVersion() until the nouveau 
> driver has already been loaded. Which kind of forces the low-level drivers 
> to do any such versioning on their own. 
> 
> But wouldn't it be nice if something like this was done at a higher level, 
> so that the drivers really wouldn't even need to care?

Why not support a _minimal_ ABI that will always let X start with nouveau?
Having X working does not mean that all forms of acceleration have to 
work too.  If X starts, even if is slow, users can easily check logs which
should have a message saying 'ABI change - upgrade your ...'.

Thoughts?
Ed Tomlinson
