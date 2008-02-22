Return-Path: <linux-kernel-owner+w=401wt.eu-S932144AbYBVBti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbYBVBti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYBVBtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:49:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:42858 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbYBVBtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:49:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,388,1199692800"; 
   d="scan'208";a="382128671"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 17:35:38 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802211702.02306.jesse.barnes@intel.com> <alpine.LFD.1.00.0802211723510.19896@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802211723510.19896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211735.38769.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 21, 2008 5:28 pm Linus Torvalds wrote:
> On Thu, 21 Feb 2008, Jesse Barnes wrote:
> > So the advantage of the kernel suspend/resume hooks for the DRM layer is
> > that the kernel video drivers can do full state save/restore (which X
> > usually doesn't do, and isn't really designed to do), so that if your
> > platform *doesn't* do it all, you'll still end up with a usable machine
> > in the end.
>
> Well, I'm also hoping that eventually we could even just not do the VT
> switch at all, and the kernel can treat X as "just another user process"
> that it freezes.

Hell yes.

> At least from a mode setting standpoint.
>
> We'd still want to make sure that X repaints the screen if the contents
> were lost, of course. And this is going to depend very intimately on the
> type of graphics card and whether the video RAM is saved by STR or not -
> for the Intel integrated graphics kind of situation, the video RAM will be
> refreshed along with all the other memory, but for other cards we may end
> up having to do the VT switch not so much for modesetting reasons as just
> a way to get X to save and restore all the *other* state.

Drivers supporting kernel modesetting will have to stuff their VRAM somewhere, 
yeah.  Hopefully X won't have much to do with it though...

> How close is the i915 driver from not having to even signal X? Or is that
> just a pipedream of mine?

It's there in the modesetting tree (though the requisite changes to avoid VT 
notification aren't done, it should all work fine).

Jesse
