Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbXGLJKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbXGLJKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXGLJK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:10:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:14296 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbXGLJK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:10:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,531,1175497200"; 
   d="scan'208";a="267362261"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <4695C096.5080400@goop.org>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <20070711172243.ab44c4d4.akpm@linux-foundation.org>
	 <4695C096.5080400@goop.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Jul 2007 17:09:34 +0000
Message-Id: <1184260174.9346.85.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 12 Jul 2007 09:10:20.0487 (UTC) FILETIME=[78BE7570:01C7C464]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 22:48 -0700, Jeremy Fitzhardinge wrote:
> >> The kexec jump is implemented in the framework of software suspend. In
> >> fact, the kexec based hibernation can be seen as just implementing the
> >> image writing and reading method of software suspend with a kexeced
> >> Linux kernel.
> >>     
> 
> I guess I'm (still) confused by the terminology here.  Do you mean that 
> it fits into suspend-to-disk as a disk-writing mechanism, or in 
> suspend-to-ram as a way of going to sleep?

It fits into suspend-to-disk as a disk-writing mechanism. But most
tricks of suspend-to-disk will be no longer necessary in kexec based
hibernation.

> > I didn't understand the ACPI problem.  Does this mean that CONFIG_ACPI must
> > be disabled in the to-be-hibernated kernel, or in the little transient
> > kexec kernel?
> >   
> 
> I think the point is that if kernel A says "I'm suspending" and calls 
> the suspend method on all its devices, then kernel B finds that it has 
> no powered on devices to work with.  But then couldn't it turn on the 
> ones it wants anyway?  And don't you want to suspend them, to make sure 
> they're not still DMAing memory while B is trying to shuffle everything 
> off to disk?

The devices should be put quiescent state to stop DMA like things. But
they do not need to be put in low power state.

"Do not put devices into low power state" vs. "power on devices during
boot-up"

Which one is easier?

Best Regards,
Huang Ying
