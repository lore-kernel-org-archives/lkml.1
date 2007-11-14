Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbXKNV40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbXKNV40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763239AbXKNV4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:56:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46435 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759906AbXKNV4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:56:03 -0500
Subject: Re: [PATCH] Hibernation: Fix lockdep report (v2)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20071114224200.GB7367@ucw.cz>
References: <200711142225.58033.rjw@sisk.pl>  <20071114224200.GB7367@ucw.cz>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 22:54:33 +0100
Message-Id: <1195077273.22457.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-14 at 22:42 +0000, Pavel Machek wrote:
> On Wed 2007-11-14 22:25:57, Rafael J. Wysocki wrote:
> > [Andrew, please consider this as 2.6.24 material, thanks.]
> > ---
> > From: Johannes Berg <johannes@sipsolutions.net>
> > 
> > Lockdep reports a circular locking dependency in the hibernate code
> > because
> >  - during system boot hibernate code (from an initcall) locks pm_mutex
> >    and then a sysfs buffer mutex via name_to_dev_t
> >  - during regular operation hibernate code locks pm_mutex under a
> >    sysfs buffer mutex because it's called from sysfs methods.
> > 
> > The deadlock can never happen because during initcall invocation nothing
> > can write to sysfs yet. This removes the lockdep report by marking the
> > initcall locking as being in a different class.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

I guess mine got lost too :-)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> > Cc: Pavel Machek <pavel@ucw.cz>
> 
> ACK...
> 

