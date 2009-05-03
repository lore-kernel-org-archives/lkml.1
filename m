Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZECV5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZECV5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZECV5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:57:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34565 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZECV5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:57:13 -0400
Date: Sun, 3 May 2009 23:57:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>
Subject: Re: in_suspend and __nosave
Message-ID: <20090503215709.GE1368@ucw.cz>
References: <20090430203000.GA10999@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430203000.GA10999@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> While unifying vmlinux.lds for x86 I stumbled
> over the .data.nosave section.
> 
> Searching a bit I found only a single user:
> 
> swsusp.c:int in_suspend __nosavedata = 0;
> 
> Do we really needs all this complexity for this single integer?
> We have this section defined in several arch lds files.

Well, original idea was that drivers may need some memory that's not
affected by hibernation/restore....

> It also occur to me that only: x86, powerpc, and sh
> implement pfn_is_nosave() which I think is the only
> place where we decide if we want to save a page or not.
> 
> But we define the .data.nosave section in following
> architectures:
> arm, m32r, mips, mn10300, parisc, s390 in addition
> to the above archs that define pfn_is_nosave().
> Is this something to be cleaned up?

I guess people were just too happy with cut&paste. Ouch and someone
was working on arm hibernation, iIRC. 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
