Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbXGIOqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbXGIOqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXGIOp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:45:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46615 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752873AbXGIOp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:45:58 -0400
Date: Mon, 9 Jul 2007 10:45:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
In-Reply-To: <87odimw6k3.fsf@jbms.ath.cx>
Message-ID: <Pine.LNX.4.44L0.0707091043480.3851-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Jeremy Maitin-Shepard wrote:

> Pavel Machek <pavel@ucw.cz> writes:
> 
> [snip]
> 
> > I don't know how to do that mechanism... but if we knew where to trap
> > filesystem writes, we could simply freeze at that point, and at that
> > point only, no?
> 
> Any operation at all that has an external effect must not occur after
> the snapshot is made; otherwise, there will be random hard-to-find
> corruptions and other problems occurring as a result.  Thus, for
> example, any writes (either directly or indirectly through e.g. a
> filesystem) to non-volatile storage, any network traffic, any
> communication with hardware like a printer must be prevented after the
> snapshot.

You have forgotten one critical point: The writes to save the snapshot 
image must be allowed.  That's what makes it really hard.

Alan Stern

