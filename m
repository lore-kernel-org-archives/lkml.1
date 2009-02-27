Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZB0J6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZB0J6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZB0J6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:58:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41554 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbZB0J6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:58:06 -0500
Date: Fri, 27 Feb 2009 11:00:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090227100037.GB4582@elf.ucw.cz>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org> <20090217142001.GB12378@bulgaria.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217142001.GB12378@bulgaria.corp.google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Arve said that the power state was equivalent in idle and suspend, but 
> > that they preferred suspend because it stopped any periodic timers. I'd 
> > be more interested in making sure that unnecessary timers aren't running 
> > than focusing on automatically entering system-wide suspend - Nokia have 
> > been managing this since 2005 with good results.
> 
> We'd totally agree that doing something about periodic timers would be a
> big win.  There's also the situation that the longest ARM linux can sit
> in idle right now is ~2s at a time (Arve can expand on the exact issue
> relating to a 32bit signed nanosecond value somewhere iirc), which we'd
> want to sort out as well.
> 
> Of course that still doesn't address userspace.  Aggressively going to
> suspend lets us compensate for userspace programs that do somewhat silly
> things (I agree that it would be best if they didn't but they do and
> getting *everyone* to write their userspace code to avoid spinning or
> avoid waking up on short-duration timers to poll is a losing battle).

Well, really? AFAICS, we can either

1) Android solution: let the polling code live, and modify everyone
that _really_ wants to run to use wakelocks.

2) Solution proposed here: fix the polling code.

IMNSHO 1) means modifying many applications, too... See android
marked, 50%+ apps request "keep system woke up" capability. Plus it
means modifying _good_ code, and leaving _bad_ code unfixed. So I'd
prefer 2). I believe ammount of work is pretty similar.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
