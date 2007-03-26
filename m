Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbXCZKop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbXCZKop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbXCZKop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:44:45 -0400
Received: from smtp.osdl.org ([65.172.181.24]:53035 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbXCZKoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:44:44 -0400
Date: Mon, 26 Mar 2007 02:44:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Rannaud <eric.rannaud@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Larry Finger <larry.finger@lwfinger.net>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070326024400.1ce3c6e4.akpm@linux-foundation.org>
In-Reply-To: <20070326103432.GB18799@zenigma>
References: <20070321202225.GN10459@waste.org>
	<20070321233917.0393dfd1.akpm@linux-foundation.org>
	<20070322123508.3785fd30@gondolin.boeblingen.de.ibm.com>
	<4602752A.5050109@lwfinger.net>
	<20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com>
	<4602D137.4060402@lwfinger.net>
	<20070323111029.4089ccfb@gondolin.boeblingen.de.ibm.com>
	<20070323210618.6a41f5da.akpm@linux-foundation.org>
	<20070326110949.5301a571@gondolin.boeblingen.de.ibm.com>
	<20070326012232.0f0b9e09.akpm@linux-foundation.org>
	<20070326103432.GB18799@zenigma>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 12:34:33 +0200 Eric Rannaud <eric.rannaud@gmail.com> wrote:

> On Mon, Mar 26, 2007 at 01:22:32AM -0800, Andrew Morton wrote:
> > On Mon, 26 Mar 2007 11:09:49 +0200 Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > > > If so, do you think I should labour on with
> > > > uevent-improve-error-checking-and-handling.patch plus your fix, or should I
> > > > drop the lot?  (I'm inclined toward the latter, but I'm still not
> > > > sure which patch(es) need to be dropped).
> > > 
> > > This depends on what semantics uevent returning an error code should
> > > have. The firmware code was using it to suppress uevents, but
> > > uevent_suppress is a better idea now. So if we want uevent returning !=
> > > 0 to imply "something really bad happened", all uevent functions have
> > > to be audited and those that work like firmware_uevent have to be
> > > converted to uevent_suppress. This would be cleaner, but I'm not sure
> > > it's worth the work.
> > 
> > We're generally struggling to stay alive amongst all the bugs at present -
> > I'll drop all those patches.
> 
> My mistake, I wrote the guilty patch
> uevent-improve-error-checking-and-handling.patch assuming it was safe to
> treat the return value as an error code, since several uevent functions
> returns things like -ENOMEM.
> 
> Should I rework the patch as Cornelia suggests and resubmit later, when
> things have settled down a little?

Sure, when we've fixed all the bugs ;)

I think we now know what to test for - firmware loading simply collapsed
all over the place with these changes.

