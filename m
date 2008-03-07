Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYCGP7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYCGP7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbYCGP7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:59:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40336 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbYCGP7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:59:36 -0500
Date: Fri, 7 Mar 2008 07:59:21 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com, serue@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080307155921.GB28439@kroah.com>
References: <47CED717.60406@openvz.org> <47CEDA64.1070506@openvz.org> <20080305171304.f686f6de.akpm@linux-foundation.org> <47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D11068.9010704@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 12:52:40PM +0300, Pavel Emelyanov wrote:
> Andrew Morton wrote:
> > On Fri, 07 Mar 2008 12:22:01 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:
> > 
> >>> This doesn't include sufficient headers to be compileable.
> >>>
> >>> I'm sure there are lots of headers like this.  But we regularly need
> >>> to fix them.
> >>>
> >> Not sure, whether this is still relevant after Greg's comments, but that's
> >> the -fix patch for this one. (It will cause a conflict with the 9th patch.)
> > 
> > Well.  Where do we stand with this?  afaict the state of play is:
> > 
> > Greg: do it in udev
> > Pavel: but people want to run old distros in containers
> 
> Actually no.
> 
> Greg: Use LSM for this

Yes, that is my recommendation.

> Pavel: My approach just makes maps per-group, while LSM will
>        bring a new level of filtering/lookup on device open path

Huh?  You are still doing that same "filtering/lookup" by modifying the
maps code.  The result should be exactly the same.

Why do you not want to use the LSM interface?  That is exactly what it
is there for, don't go creating new hooks into the kernel for the exact
same functionality.

Opening a dev node is not on any "fast path" that you need to be
concerned about a few extra calls within the kernel.

And, I think in the end your patch would be much smaller and easier to
understand and review and maintain overall.

> > Realistically, when is the mainline kernel likely to have sufficient
> > container functionality which is sufficiently well-tested for people to
> > actually be able to do that?  And how much longer will it take for that
> > kernel.org functionality to propagate out into non-bleeding-edge distros?
> 
> The fact is that we have users of OpenVZ and even Virtuozzo, that still use 
> redhat-9 as in containers. So even if this is ready in 5 years, there will 
> always be someone who sets the outdated (by that time) fedora-core-8 and find
> out, that his udev refuses to work.

That's fine, use the LSM interface, no need to change userspace at all.

Although I think your requirement of using new kernels on very old
distros is going to cause you more problems than you realize in the
end...

thanks,

greg k-h
