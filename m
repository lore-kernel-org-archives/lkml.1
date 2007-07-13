Return-Path: <linux-kernel-owner+w=401wt.eu-S934290AbXGMPY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290AbXGMPY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761292AbXGMPYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:24:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759787AbXGMPYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:24:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 17:31:35 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.44L0.0707131035150.4865-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707131035150.4865-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131731.36113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 July 2007 16:37, Alan Stern wrote:
> On Fri, 13 Jul 2007, Rafael J. Wysocki wrote:
> 
> > > I missed this discussion. is this idea to suspend, write to disk, but 
> > > leave things in ram so that if you wakeup soon enough you have everything 
> > > for ram, but if you don't and the battery dies you can restore from disk?
> > > 
> > > if so I think it's a mistake to mix the two. it would be better to just 
> > > suspend to ram, and wake up once in a while to check the battery state and 
> > > when the battery gets low enough do the suspend to disk.
> > > 
> > > otherwise you end up mixing the requirements of the two types of suspend, 
> > > which is how things got so ugly in the first place.
> > 
> > Not necessarily.  If we don't put devices into low power states before creating
> > the image, that should work just fine (quiesce devices, create the image or
> > kexec the new kernel, reprobe devices, save the image, suspend to RAM,
> > resume from RAM, continue - or restore from the image if power failed in the
> > meantime).  Still, for this purpose, both kernels need to be able to handle the
> > same set of devices.
> 
> Why?
> 
> Suppose the kexec kernel can't handle some device.  The normal kernel 
> has already quiesced the device, so it will remain quiescent while the 
> kexec kernel runs and throughout the suspend.  When the regular kernel 
> regains control the device will be ready for use.  I don't see any 
> problem.

On an ACPI system the device may be in a power state that doesn't allow us to
enter S3 (in theory, that is).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
