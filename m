Return-Path: <linux-kernel-owner+w=401wt.eu-S1761789AbZEGMyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761789AbZEGMyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759671AbZEGMyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:54:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47004 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbZEGMyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:54:23 -0400
Date: Thu, 7 May 2009 14:09:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Subject: Re: [RFC] TuxOnIce
Message-ID: <20090507120948.GA1531@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'd like to submit TuxOnIce for review, with a view to seeking to get it
> merged, perhaps in 2.6.31 or .32 (depending upon what needs work before
> it can be merged) and the willingness of those who matter.
> 
> To briefly summarise the advantages to merging TuxOnIce:
> 
> - Support for multiple swap devices
> - Support for non-swap (an ordinary file can be used)
> - Uses cryptoapi (LZO support, more than 2x speed of uncompressed data!)
> - Asynchronous I/O, readahead, multithreaded. Get the maximum throughput
>   possible with your hardware.
> - Userspace user interface that lets you abort hibernating and abort
>   resuming, get nice progress display etc.

All these are either done by uswsusp already, or could be done w/o
modifying kernel code.

> - 8 years of testing and improvement.

Yeah, 8 years of out of tree testing; while current code is used by
basically every distro out there.

> - Full image of memory (LRU pages that don't need to be atomically
>   copied are saved prior to the atomic copy, then used as the
>   destination of the atomic copy).

Yeah, that was the patch that did not go in

> - Support for resuming a different image after writing an image - makes
>   powering down a UPS after writing an image doable.


This can  be done w/o kernel code. Someone had a patch...

> - Simple to set up (works without any userspace binaries, uses existing
>   resume= and noresume commandline parameters).

Given that distros ship uswsusp already... is that really an advantage.

To summarise disadvantages:

- only core has 8000 LoC
- it does stuff that can be easily done in userspace
     (and that todays distros _do_ in userspace).
- it duplicates uswsusp functionality.
- compared to [u]swsusp, it received little testing

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
