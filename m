Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZGHKev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZGHKev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZGHKen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:34:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51907 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbZGHKem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:34:42 -0400
Date: Sat, 4 Jul 2009 04:44:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Jeremy Maitin-Shepard <jeremy@jeremyms.com>,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Rafael Wysocki <rjw@sisk.pl>
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by
	encrypting page cache
Message-ID: <20090704024432.GB1345@ucw.cz>
References: <87hbxx0wcp.fsf@jeremyms.com> <4A4B0125.2090502@crca.org.au> <87d48k2992.fsf@jeremyms.com> <4A4B27D0.8020906@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4B27D0.8020906@crca.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Specifically, suppose right at the stage in tuxonice hibernation when
> > the kernel as about to write the page cache pages to disk, it instead
> > just encrypts in place those pages, clears the encryption key, then
> > waits for the userspace helper to pass it back the key again to use to
> > decrypt the pages.
> > 
> > In fact it would seems that actually entering S3 is mostly irrelevant in
> > terms of the implementation.
> > 
> > Tuoxnice already has code to deal with interfacing with a userspace
> > helper that is kept unfrozen (and its pages handled specially) while
> > everything else is frozen and the page cache is overwritten, which is
> > precisely what is needed for this idea.  In particular, it seems that an
> > implementation of the idea I proposed would look a lot like tuxonice
> > with a powerdown mode of entering S3, just that instead of writing the
> > page cache to disk, it is encrypted in place.  I suppose it could well be that
> > all of the facilities used by tuxonice to do this are actually already
> > in the kernel, in which case it is indeed not relevant to tuxonice, but
> > it is not clear that the uswsusp infrastructure has everything that is
> > needed.
> 
> You're absolutely right - TuxOnIce could be modified to do that, quite
> easily.
> 
> As far as the possibility of using uswsusp goes, I'd like to get
> Rafael's input there - he knows it much better than I do (explicitly
> adding him to the ccs).

I believe uswsusp could be used rather easily. Just modify s2disk to
encrypt image in ram without writing it out, then decrypt it from ram
and resume... it should be interesting hack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
