Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXGHEkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXGHEkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 00:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXGHEkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 00:40:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:41377 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbXGHEka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 00:40:30 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.44L0.0707072218030.10912-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0707072218030.10912-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 14:39:36 +1000
Message-Id: <1183869576.3388.250.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> In my defense, you should realize that until Rafael's notifier chain
> was added (just a few weeks ago, still not in mainline I believe) there
> was no other way to do it.  Plug activity needs to be stopped before
> the child devices are suspended, and the PM core does not send any
> notification to drivers at that time.  All it does is activate the 
> freezer.

That's true. That was one of the reason I've always wanted the
pre-suspend and post-resume hooks. (I prefer keeping the ordering there
too, rather than a notifier, but a notifier is fine I suppose).

Among the clients we want here the firmware stuff, the allocators,
etc... to get themselves in conditions that won't deadlock during
suspend cycle.

I think that's a much bigger issue overall than freezer vs. no
freezer :-)

Ben.


