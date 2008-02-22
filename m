Return-Path: <linux-kernel-owner+w=401wt.eu-S936051AbYBVB33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936051AbYBVB33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYBVB3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:29:20 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbYBVB3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:29:18 -0500
Date: Thu, 21 Feb 2008 17:28:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off
 aftersuspend-to-disk. Screen becomes green.
In-Reply-To: <200802211702.02306.jesse.barnes@intel.com>
Message-ID: <alpine.LFD.1.00.0802211723510.19896@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802211646.31603.jesse.barnes@intel.com> <b6a2187b0802211652x304daa2ci36a76a76a2fcb82@mail.gmail.com> <200802211702.02306.jesse.barnes@intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Feb 2008, Jesse Barnes wrote:
> 
> So the advantage of the kernel suspend/resume hooks for the DRM layer is that 
> the kernel video drivers can do full state save/restore (which X usually 
> doesn't do, and isn't really designed to do), so that if your platform 
> *doesn't* do it all, you'll still end up with a usable machine in the end.

Well, I'm also hoping that eventually we could even just not do the VT 
switch at all, and the kernel can treat X as "just another user process" 
that it freezes.

At least from a mode setting standpoint.

We'd still want to make sure that X repaints the screen if the contents 
were lost, of course. And this is going to depend very intimately on the 
type of graphics card and whether the video RAM is saved by STR or not - 
for the Intel integrated graphics kind of situation, the video RAM will be 
refreshed along with all the other memory, but for other cards we may end 
up having to do the VT switch not so much for modesetting reasons as just 
a way to get X to save and restore all the *other* state.

How close is the i915 driver from not having to even signal X? Or is that 
just a pipedream of mine?

			Linus
