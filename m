Return-Path: <linux-kernel-owner+w=401wt.eu-S933497AbXGLMka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbXGLMka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765149AbXGLMkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:40:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55031 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764833AbXGLMj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:39:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Thu, 12 Jul 2007 14:47:15 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <4695C096.5080400@goop.org> <1184260174.9346.85.camel@caritas-dev.intel.com>
In-Reply-To: <1184260174.9346.85.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121447.16616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 July 2007 19:09, Huang, Ying wrote:
> On Wed, 2007-07-11 at 22:48 -0700, Jeremy Fitzhardinge wrote:
> > >> The kexec jump is implemented in the framework of software suspend. In
> > >> fact, the kexec based hibernation can be seen as just implementing the
> > >> image writing and reading method of software suspend with a kexeced
> > >> Linux kernel.
> > >>     
> > 
> > I guess I'm (still) confused by the terminology here.  Do you mean that 
> > it fits into suspend-to-disk as a disk-writing mechanism, or in 
> > suspend-to-ram as a way of going to sleep?
> 
> It fits into suspend-to-disk as a disk-writing mechanism. But most
> tricks of suspend-to-disk will be no longer necessary in kexec based
> hibernation.
> 
> > > I didn't understand the ACPI problem.  Does this mean that CONFIG_ACPI must
> > > be disabled in the to-be-hibernated kernel, or in the little transient
> > > kexec kernel?
> > >   
> > 
> > I think the point is that if kernel A says "I'm suspending" and calls 
> > the suspend method on all its devices, then kernel B finds that it has 
> > no powered on devices to work with.  But then couldn't it turn on the 
> > ones it wants anyway?  And don't you want to suspend them, to make sure 
> > they're not still DMAing memory while B is trying to shuffle everything 
> > off to disk?
> 
> The devices should be put quiescent state to stop DMA like things. But
> they do not need to be put in low power state.

Exactly.  Morover, I don't think it would be correct to put them into low power
states.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
