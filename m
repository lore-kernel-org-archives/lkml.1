Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbYKLKua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbYKLKua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYKLKuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:50:21 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57884 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbYKLKuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:50:20 -0500
Date: Wed, 12 Nov 2008 11:49:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-ID: <20081112104951.GB11945@ucw.cz>
References: <20081109140726.GB1786@ucw.cz> <200811111520.22386.rjw@sisk.pl> <20081111150342.GB1648@ucw.cz> <200811111747.28347.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811111747.28347.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > Well, interesting point would be just before this commit:
> > > > 
> > > > 
> > > > commit 8357376d3df21b7d6f857931a57ac50da9c66e26 
> > > > tree daf2c369e9b79d24c1666323b3ae75189e482a4a 
> > > > parent bf73bae6ba0dc4bd4f1e570feb34a06b72725af6 
> > > > author Rafael J. Wysocki <rjw@sisk.pl> Wed, 06 Dec 2006 20:34:18 -0800 
> > > > committer Linus Torvalds <torvalds@woody.osdl.org> Thu, 07 Dec 2006
> > > > 08:39:27 -0800 
> > > > 
> > > >     [PATCH] swsusp: Improve handling of highmem
...
> > And it does not work with single highmem page when NUMA is set... I
> > went through the highmem saving code, and it depends on highmem not
> > changing from  under it (right?) and is generally quite tricky ('if
> > they are both in highmem do this, else if one of them is do that, else
> > do something else')
> 
> It actually is quite simple, if you know the idea.
> 
> > and it changes page protections on the fly, etc. 
> 
> No, it doesn't do that, at least for pages it hasn't allocated itself.  I don't
> think it changes anything like page protections at all, though.

safe_copy_page() seems to call kernel_map_pages() on s_page... which
is page from the system AFAICT...

> > I'm not saying the bug is in that code, but before that commit we had
> > very stupid --- but very robust -- code. I'll try if that one works
> > with config_numa, perhaps we can get some debug info that way.
> 
> if you can do that, it actually may be valuable information.

So far I know that software suspend depends on !PAE in that old
version. If I only recalled why...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
