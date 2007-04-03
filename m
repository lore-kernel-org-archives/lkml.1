Return-Path: <linux-kernel-owner+w=401wt.eu-S933247AbXDCIur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247AbXDCIur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 04:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933307AbXDCIur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 04:50:47 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:62673 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247AbXDCIuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 04:50:46 -0400
Date: Tue, 3 Apr 2007 10:52:53 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <gregkh@suse.de>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andres Salomon <dilinger@debian.org>
Subject: Re: [patch 2.6.21-rc5-git 1/2] fix hotplug for legacy platform
 drivers
Message-ID: <20070403105253.743ef814@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200704020959.28875.david-b@pacbell.net>
References: <200703311455.38490.david-b@pacbell.net>
	<20070402124944.0ad74092@gondolin.boeblingen.de.ibm.com>
	<200704020959.28875.david-b@pacbell.net>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007 09:59:28 -0700,
David Brownell <david-b@pacbell.net> wrote:

> But long term, I wonder.  Isn't "no kevents issued" an extremely
> blunt tool, which could cause lots of damage?  It might be better
> to have selective filters, one per event family:  core (add/remove),
> online/offline, mount/unmount, etc.

It all depends on your use case :) But yes, we could introduce some
flags that selectively filter out some groups of uevents.

> But in general it's worth thinking about.  The comments on that
> "suppress all kevents" patch didn't include any motivation at all.
> Why do you want to prevent all kevents, rather than just a subset?

Currently, some drivers (like firmware_class) return an error code in
their uevent function in order to suppress uevents until they did some
setup. It seemed cleaner to use uevent_suppress and filter until they
were ready. For s390, we have the problem that we get a storm of
uevents for devices which aren't useable after all; we can use
uevent_suppress to make sure that userspace doesn't know anything about
those devices until we're really sure we want to keep them.
