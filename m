Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZBRXb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZBRXb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZBRXbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:31:18 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58384 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751685AbZBRXbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:31:17 -0500
Date: Wed, 18 Feb 2009 18:31:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <200902190004.18878.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0902181826500.23001-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009, Rafael J. Wysocki wrote:

> > If some devices are autosuspended after a local inactivity timeout, I
> > don't want to wait for those devices to autosuspend if I know the code
> > that needed to run is done. This could cause delays in the normal
> > case,
> 
> Isn't it a matter of adjusting the inactivity timeouts in a suitable way?

It's not that simple.  A single device driver has a very local view, 
not suitable for deciding whether the entire system should go to sleep.

So for example, a disk driver might think it's appropriate to spin down 
the disk after 10 seconds of inactivity.  But an overall system monitor 
might realize that nothing is going on right now and want to put the 
system to sleep immediately, without waiting the 10 seconds for the 
disk to autosuspend.

> > and it could prevent suspend if a background process (not using
> > wakelocks) is accessing a disk more frequently than its idle timeout.
> 
> Well, actually, shouldn't it prevent suspend from happening?  Arguably, it just
> means that the disk is continuously being accessed with respect to the inactive
> timeout granularity.

That's true, but it shows the problem of making the autosleep decision
based on disk activity.  An auto-sleep should not have to wait for
every device (or some suitable subset) to become idle for some minimum
time; it should be able to kick in at short notice.

Alan Stern

