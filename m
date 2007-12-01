Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbXLBMem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbXLBMem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 07:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXLBMed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 07:34:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3197 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751576AbXLBMec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 07:34:32 -0500
Date: Sat, 1 Dec 2007 08:43:32 +0000
From: Pavel Machek <pavel@ucw.cz>
To: tvrtko.ursulin@sophos.com
Cc: Andi Kleen <andi@firstfloor.org>, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071201084332.GB4446@ucw.cz>
References: <p738x4i9nyd.fsf@crumb.suse.de> <OFFB86F10D.D565B603-ON802573A2.005A558C-802573A2.005B85B0@sophos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFFB86F10D.D565B603-ON802573A2.005A558C-802573A2.005B85B0@sophos.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Personally I admit I never quite saw the point of intercepting all
> > file accesses for everything. That will just always be slow as often
> > demonstrated on other operating systems and racey and unreliable too.
> > And at least the internal daemons should be already reasonably well
> > protected by standard (or beyond standard, like AA/SELinux etc.)
> > security measures, so e.g. it does not really make sense to intercept
> > all of your /etc file accesses and similar.
> 
> Personally I don't know. I am often surprised when I hear what techniques 
> the bad guys use and what is possible.
> 
> Solution that we currently have is not so slow (btw you are free to try it 
> out). And by working on a proper interface race and reliability issues 
> should be solvable.

Really?

So what you are trying to do is 'application may never read bad
sequence of bits from disk', right?

Now, how do you propose to solve mmap(MAP_SHARED)? The app on the other cpu may
see the bad bits before kernel has chance to see them.

> > It might be better to identify the services (gateway, samba, file
> > server whatever) that are actually dealing with possible infected
> > "external" files and then define some generic interface that would
> > allow you to check those as the data appears.
> > 
> > I would expect such an approach to perform better in the end and be more
> > reliable too.
> > 
> > Note such a interface might well be user space only.
> 
> That is fine for some classes of servers. But for some other and desktop 
> more could be needed. 

Andi's solution seems the only one that has chance to work _reliably_.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
