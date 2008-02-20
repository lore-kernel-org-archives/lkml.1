Return-Path: <linux-kernel-owner+w=401wt.eu-S1764913AbYBTXvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764913AbYBTXvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbYBTXvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:51:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33153 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbYBTXvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:51:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 00:49:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201503.44656.jbarnes@virtuousgeek.org> <200802201534.36174.jbarnes@virtuousgeek.org>
In-Reply-To: <200802201534.36174.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210049.42820.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Jesse Barnes wrote:
> On Wednesday, February 20, 2008 3:03 pm Jesse Barnes wrote:
> > On Wednesday, February 20, 2008 2:32 pm Jesse Barnes wrote:
> > > On Wednesday, February 20, 2008 11:10 am Jeff Chua wrote:
> > > > On Feb 21, 2008 2:53 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:
> > > > > > So, next I'll try "shutdown" to see if it work. I was using
> > > > > > "platform".
> > > > >
> > > > > Ok, that would be good to try.
> > > >
> > > > "shutdown" does power down properly. But still green on resume.
> > > >
> > > > > Looks like the AR registers are hosed, which is what I thought I
> > > > > fixed... Can you attach your i915_drv.c file just so I can sanity
> > > > > check it?
> > > >
> > > > Attached.
> > >
> > > Jeff, for the hang on suspend problem, I know suspect something else in
> > > 2.6.25-rc2 caused that.
> >
> > Looks like 2.6.25-rc1 also had broken suspend (my test was broken).  IIRC,
> > Dave and I had it working at LCA using the out of tree DRM modules on
> > 2.6.23.14 or 15...  Maybe you could give that a try?
> 
> And just to confirm that, I just tested the current DRM modules against a 
> 2.6.23.15 kernel.

In 2.6.23.x there's no second ->suspend() during hibernation, so no wonder.

I'll figure out how to work around this issue in the current mainline, but a
real fix will only be possible when we have separate callbacks for
hibernation.

Thanks,
Rafael
