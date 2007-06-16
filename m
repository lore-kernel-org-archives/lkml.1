Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbXFPAWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbXFPAWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbXFPAWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:22:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57079 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756910AbXFPAV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:21:59 -0400
Date: Sat, 16 Jun 2007 02:20:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070616002012.GH2616@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070615234925.GB15056@kroah.com> <Pine.LNX.4.64.0706151656170.12349@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706151656170.12349@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>Under the restorecon proposal, the web site would be horribly broken
> >>until restorecon finishes, as various random pages are or are not
> >>accessible to Apache.
> >
> >Usually you don't do that by doing a 'mv' otherwise you are almost
> >guaranteed stale and mixed up content for some period of time, not to
> >mention the issues surrounding paths that might be messed up.
> 
> on the contrary, useing 'mv' is by far the cleanest way to do this.
> 
> mv htdocs htdocs.old;mv htdocs.new htdocs
> 
> this makes two atomic changes to the filesystem, but can generate 
> thousands to millions of permission changes as a result.

Ok, so mv gets slower for big trees... and open() gets faster for deep
trees. Previously, open in current directory was one atomic read of
directory entry, now it has to read directory, and its parent, and its
parent parent, and its...

(Or am I wrong and getting full path does not need to bring anything
in, not even in cache-cold case?)

So, proposed solution has different performance tradeoffs, but should
still be a win -- opens are more common than moves.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
