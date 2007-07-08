Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbXGHUW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbXGHUW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 16:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbXGHUWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 16:22:21 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4396 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756284AbXGHUWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 16:22:20 -0400
Date: Sun, 8 Jul 2007 16:22:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707082046.36864.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0707081619090.11049-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Rafael J. Wysocki wrote:

> I'm all for changing this infrastructure, but in an organized way (ie. we
> discuss what to do next, we do that and then we go to the next step) and in
> the order that everyone will be comfortable with.
> 
> So, let's finish this thread and start over from discussing what needs to be
> done, how (ie. in what order etc.) we are going to do that and who is going to
> do what.  Shall we?

IMO we should start by using the new notifier chain and by implementing 
a central "icebox" routine.  Then we can forbid device registration 
during suspend.

It might also be a good idea to add a freezable keventd-like workqueue 
specifically intended for things that need to block during a suspend.  
Although maybe this will end up being unnecessary; it's too soon to 
tell.

Alan Stern

