Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbZFIXJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbZFIXJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZFIXJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:09:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44014 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZFIXJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:09:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Wed, 10 Jun 2009 01:02:21 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906081626120.13888-100000@netrider.rowland.org> <200906082331.58933.rjw@sisk.pl> <200906090931.37626.oliver@neukum.org>
In-Reply-To: <200906090931.37626.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906100102.22307.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, Oliver Neukum wrote:
> Am Montag, 8. Juni 2009 23:31:58 schrieb Rafael J. Wysocki:
> > If ->autosuspend() fails, the device power state may be known, but the core
> > can't be sure if the device is active.  This information is available to
> > the driver and/or the bus type, which should change the status to whatever
> > is appropriate.
> 
> That is quite confusing. You'd better define error returns.

That might work too, but the information need not be available to the driver
immediately.  It may need to schedule a reset of the device to recover from
the error condition, for example.

> One that would mean that the suspension has failed but the device is
> unaffected, and another one that means that the device is in an
> undefined state now.
>
> > > The scheme doesn't include any mechanism for communicating runtime
> > > power information up the device tree.  When a device is autosuspended,
> > > its parent's driver should be told so that the driver can consider
> > > autosuspending the parent.
> >
> > I thought the bus type's ->autosuspend() callback could take care of this.
> 
> That can't work because you have to operate between busses.

OK, point taken.

> > > Likewise, if we want to autoresume a device below an autosuspended
> > > parent, the parent should be autoresumed first.  Did you want to make the
> > > bus subsystem responsible for all of this?
> >
> > Yes, that was the idea.
> 
> That is an important point. Can some subsytems operate with a parent still
> suspended?

OK, I see the value of doing that at the core level.

I tried to address this in the new version of the patch, which has been sent
in my last reply to Alan.

Thanks,
Rafael

