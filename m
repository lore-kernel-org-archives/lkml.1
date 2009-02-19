Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbZBSM5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbZBSM5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZBSM5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:57:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47847 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbZBSM5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:57:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFD] Automatic suspend
Date: Thu, 19 Feb 2009 13:56:51 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
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
References: <Pine.LNX.4.44L0.0902181826500.23001-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902181826500.23001-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191356.53584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009, Alan Stern wrote:
> On Thu, 19 Feb 2009, Rafael J. Wysocki wrote:
> 
> > > If some devices are autosuspended after a local inactivity timeout, I
> > > don't want to wait for those devices to autosuspend if I know the code
> > > that needed to run is done. This could cause delays in the normal
> > > case,
> > 
> > Isn't it a matter of adjusting the inactivity timeouts in a suitable way?
> 
> It's not that simple.  A single device driver has a very local view, 
> not suitable for deciding whether the entire system should go to sleep.
> 
> So for example, a disk driver might think it's appropriate to spin down 
> the disk after 10 seconds of inactivity.  But an overall system monitor 
> might realize that nothing is going on right now and want to put the 
> system to sleep immediately, without waiting the 10 seconds for the 
> disk to autosuspend.

Now, the question is what criteria would the overall system monitor use to make
such a decision.

> > > and it could prevent suspend if a background process (not using
> > > wakelocks) is accessing a disk more frequently than its idle timeout.
> > 
> > Well, actually, shouldn't it prevent suspend from happening?  Arguably, it just
> > means that the disk is continuously being accessed with respect to the inactive
> > timeout granularity.
> 
> That's true, but it shows the problem of making the autosleep decision
> based on disk activity.  An auto-sleep should not have to wait for
> every device (or some suitable subset) to become idle for some minimum
> time; it should be able to kick in at short notice.

Again, the decision to trigger automatic suspend has to be based on some
well defined criteria and the (in)activity of devices seems to be one of them.

Thanks,
Rafael
