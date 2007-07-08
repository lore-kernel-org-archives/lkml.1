Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbXGHVEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbXGHVEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbXGHVEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:04:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:51669 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbXGHVED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:04:03 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <200707082115.27363.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org>
	 <1183871661.3388.282.camel@localhost.localdomain>
	 <200707082115.27363.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 07:03:32 +1000
Message-Id: <1183928612.3388.289.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-08 at 21:15 +0200, Rafael J. Wysocki wrote:
> On Sunday, 8 July 2007 07:14, Benjamin Herrenschmidt wrote:
> [--snip--]
> > 
> > I just think that the freezer approach, as it is, is backward. We can't
> > have a 3rd party try to discriminate what to freeze and what not, it
> > will always get something wrong, and in some cases with the wrong timing
> > or ordering.
> 
> Nice discussion, except for one thing: the freezer doesn't decide what to
> freeze.  For example, even right now kernel threads decide if they want to be
> frozen.

Somewhat... userspace doesn't and workqueues are a gray area.

Also, I've been thinking this "icebox" idea a bit more and it seems in
fact a bit racy in some areas, at least for use by things like drivers,
unless we end up doing something aking to an RCU on suspend, waiting for
all tasks to reach userland once, but that has the same annoyances as
the current freezer.

Thus I'm tempted to go back to saying that driver can handle things
locally :-)

Ben.

