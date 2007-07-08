Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbXGHFTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbXGHFTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 01:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXGHFT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 01:19:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:45193 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbXGHFTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 01:19:25 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <1183871661.3388.282.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org>
	 <1183871661.3388.282.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 15:19:01 +1000
Message-Id: <1183871941.3388.286.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I think it's a fairly significant change from the current freezer and I
> also think it's a very good idea. The more I think about it, the more I
> like it, in the sense that it's a simple drop-in that you could put in a
> lot of the ioctl path of drivers to just block tasks that are trying to
> call in while suspending, and could be used selectively by things like
> the USB hub threads.

Note that we could have also a per-device "icebox" (just a waitqueue).
Might be nice for a device to resume whatever it froze just after it
resumed itself, might even be necessary in case whatever thread got
frozen is necessary for handling child devices.

Cheers,
Ben.


