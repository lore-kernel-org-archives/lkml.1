Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbXGHVz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbXGHVz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbXGHVzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:55:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:50970 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202AbXGHVzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:55:48 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <200707082345.27859.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org>
	 <200707082115.27363.rjw@sisk.pl>
	 <1183928612.3388.289.camel@localhost.localdomain>
	 <200707082345.27859.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 07:54:48 +1000
Message-Id: <1183931688.3388.316.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-08 at 23:45 +0200, Rafael J. Wysocki wrote:
> 
> Workqueues are kernel threads and the creator decides if they are going to
> freeze.  There are only two freezable worqueues in the entire tree right now.

That and keventd workqueues... my point is you may well end up with
something in a workqueue doing things that should have been blocked
after the freeze.

> Actaully, I'm perfectly fine with that, as long as each task blocked by the
> driver due to suspend has PF_FROZEN (or something similar) set.  Then, at
> least theoretically, we'll be able to drop the freezer from the suspend code
> path and move it after device_suspend() (or the hibernation-specific
> equivalent) for hibernation (in that case there shouldn't be a problem with
> any task waiting on I/O while the freezer is running ;-)).

I don't see the need for a freezer for snapshot but that's a different
issue. (stop_machine looks good enough to me).

Ben

