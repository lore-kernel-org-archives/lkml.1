Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbXGHSjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbXGHSjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXGHSjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:39:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677AbXGHSjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:39:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Sun, 8 Jul 2007 20:46:35 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707072218030.10912-100000@netrider.rowland.org> <1183869576.3388.250.camel@localhost.localdomain>
In-Reply-To: <1183869576.3388.250.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707082046.36864.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 July 2007 06:39, Benjamin Herrenschmidt wrote:
> 
> > In my defense, you should realize that until Rafael's notifier chain
> > was added (just a few weeks ago, still not in mainline I believe) there
> > was no other way to do it.  Plug activity needs to be stopped before
> > the child devices are suspended, and the PM core does not send any
> > notification to drivers at that time.  All it does is activate the 
> > freezer.
> 
> That's true. That was one of the reason I've always wanted the
> pre-suspend and post-resume hooks. (I prefer keeping the ordering there
> too, rather than a notifier, but a notifier is fine I suppose).
> 
> Among the clients we want here the firmware stuff, the allocators,
> etc... to get themselves in conditions that won't deadlock during
> suspend cycle.
> 
> I think that's a much bigger issue overall than freezer vs. no
> freezer :-)

Yes.  The freezer is only one part of the PM infrastructure that we have
currently and that is not very sophisticated, so to speak.

I'm all for changing this infrastructure, but in an organized way (ie. we
discuss what to do next, we do that and then we go to the next step) and in
the order that everyone will be comfortable with.

So, let's finish this thread and start over from discussing what needs to be
done, how (ie. in what order etc.) we are going to do that and who is going to
do what.  Shall we?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
