Return-Path: <linux-kernel-owner+w=401wt.eu-S1762533AbXGFJEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762533AbXGFJEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXGFJEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:04:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:47854 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196AbXGFJEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:04:00 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <200707060935.11186.rjw@sisk.pl>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <CF60EC03-0171-4052-924D-57555A393168@mac.com>
	 <1183694347.3388.114.camel@localhost.localdomain>
	 <200707060935.11186.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 19:03:11 +1000
Message-Id: <1183712591.3388.131.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On powerbooks you disable the nonboot CPUs before suspending devices, which
> simplifies things _a_ _lot_ in comparison with the general case.

Not that much actually. It avoids having to gather them all in the last
stage at the low level but that isn't really related to what we are
talking about right now.

> If you additionally disable kernel preemption, then you don't need anything
> like the freezer anyway in that case (except for detecting situations in which
> the suspend process can deadlock with a task stuck in the D state holding a
> lock, but that's overkill).

kernel preemption and SMP have nothing to do with it. You can still
schedule because one of the driver suspend() callback is schedul'ing,
maybe waiting for some requests to complete, etc... Happens typically
with the disk suspend callbacks.

I agree that it does lower the likelyness of having a userspace process
pound on the wrong driver at the wrong time though.

Ben.


