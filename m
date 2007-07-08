Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbXGHVWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbXGHVWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbXGHVWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:22:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:49568 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121AbXGHVWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:22:39 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.44L0.0707081619090.11049-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0707081619090.11049-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 07:21:48 +1000
Message-Id: <1183929708.3388.306.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-08 at 16:22 -0400, Alan Stern wrote:
> On Sun, 8 Jul 2007, Rafael J. Wysocki wrote:
> 
> > I'm all for changing this infrastructure, but in an organized way (ie. we
> > discuss what to do next, we do that and then we go to the next step) and in
> > the order that everyone will be comfortable with.
> > 
> > So, let's finish this thread and start over from discussing what needs to be
> > done, how (ie. in what order etc.) we are going to do that and who is going to
> > do what.  Shall we?
> 
> IMO we should start by using the new notifier chain and by implementing 
> a central "icebox" routine.  Then we can forbid device registration 
> during suspend.
> 
> It might also be a good idea to add a freezable keventd-like workqueue 
> specifically intended for things that need to block during a suspend.  
> Although maybe this will end up being unnecessary; it's too soon to 
> tell.

I think looking at the kmallo/gfp issue I mentioned earlier should be
done asap. I can try to spare some time for it this week but I can't
promise, I'm actually swamped by something totally unrelated at the
moment.

Another issue that's been a problem forever with suspend is the
synchronous request_firmware interface. Lots of drivers do that in
resume() which will generally not work.

Ben.


