Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbZB0UlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbZB0UlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbZB0UlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:41:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56891 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbZB0UlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:41:12 -0500
Date: Fri, 27 Feb 2009 21:40:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve Hj?nnev?g <arve@android.com>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090227204053.GB1387@ucw.cz>
References: <200902192215.18365.rjw@sisk.pl> <200902210057.27781.rjw@sisk.pl> <20090227100941.GE4582@elf.ucw.cz> <200902271522.41915.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902271522.41915.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-02-27 15:22:39, Rafael J. Wysocki wrote:
> On Friday 27 February 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > > > Then, the decision making logic will be able to use /sys/power/sleep whenever
> > > > > it wishes to and the kernel will be able to refuse to suspend if it's not
> > > > > desirable at the moment.
> > > > >
> > > > > It seems to be flexible enough to me.
> > > > 
> > > > This seems flexible enough to avoid race conditions, but it forces the
> > > > user space power manager to poll when the kernel refuse suspend.
> > > 
> > > And if the kernel is supposed to start automatic suspend, it has to monitor
> > > all of the wakelocks.  IMO, it's better to allow the power manager to poll the
> > > kernel if it refuses to suspend.
> > 
> > polling is evil -- it keeps CPU wake up => wastes power.
> > 
> > Wakelocks done right are single atomic_t... and if you set it to 0,
> > you just unblock "sleeper" thread or something. Zero polling and very
> > simple...
> 
> Except that you have to check all of the wakelocks periodically in a loop =>
> polling.  So?

No. I want to have single atomic_t for all the wakelocks... at least
in non-debug version. Debug version will be slower. I believe you
originally suggested that.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
