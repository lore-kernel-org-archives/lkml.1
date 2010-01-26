Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818Ab0AZSrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0AZSrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831Ab0AZSrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:47:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab0AZSrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:47:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume if KMS is used
Date: Tue, 26 Jan 2010 19:47:45 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>,
       airlied@linux.ie
References: <201001240055.59479.rjw@sisk.pl> <201001252254.37635.rjw@sisk.pl> <20100126141726.GA1437@ucw.cz>
In-Reply-To: <20100126141726.GA1437@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001261947.46015.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Pavel Machek wrote:
> On Mon 2010-01-25 22:54:37, Rafael J. Wysocki wrote:
> > On Monday 25 January 2010, Alan Cox wrote:
> > > > > But in that case we should be able to disable the VT switch disable
> > > > > path; we just have to check each driver as it's loaded.
> > > > 
> > > > OK, what the right sequence of checks would be in that case and where to place
> > > > them?
> > > 
> > > Why are we even driving a vt switch direct from the suspend/resume
> > > logic ? The problem starts there. If it was being handled off the device
> > > suspend/resume method then there wouldn't be a mess to start with ?
> > > 
> > > Start at the beginning
> > > 
> > > - Why do we switch to arbitarily chosen 'last vt'
> > > - Why isn't vt related suspend/resume handled by the device
> > 
> > Well, that was added long ago as a workaround for some problems people
> > reported (presumably).  I've never looked at that before, so I can't really
> > tell why someone did it this particular way.
> 
> As X drives hardware, it is/was neccessary to get control out of X and
> console switch was convenient.
> 
> Note that it needs to happen with userland still active -- before
> freezer.

Well, that's a bit cumbersome.

> And yes, it should be per-driver these days.

That would have to be done using suspend notifiers and should depend on what
driver actually controls the screen at the moment.  And I guess the only case
in which we actually _need_ to do the kernel VT switch is when the hardware
is controlled by X and without KMS.

Is there a simple way to determine if that's the case?

Rafael
