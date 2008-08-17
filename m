Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYHQW6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYHQW6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYHQW6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:58:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51683 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYHQW6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:58:45 -0400
Date: Mon, 18 Aug 2008 00:58:44 +0200
From: Pavel Machek <pavel@suse.cz>
To: david@lang.hm
Cc: Eric Paris <eparis@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Rik van Riel <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Message-ID: <20080817225844.GE21112@atrey.karlin.mff.cuni.cz>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu> <1218769209.16613.31.camel@localhost.localdomain> <20080817221258.GC21112@atrey.karlin.mff.cuni.cz> <alpine.DEB.1.10.0808171542160.12859@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808171542160.12859@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>And I still don't get this 'mmap problem' that I don't solve that
> >>libmalware magically solves.  What?  don't use mmap?  I certainly hope
> >>not.
> >
> >Don't use mmap, it is as simple as that. AFAICS mmap(MAP_SHARED) --
> >which is basically shared memory -- is fundamentally incompatible with
> >reliable virus scanning.
> >
> >...or do you have a reasonable solution for mmap?
> 
> 
> mmap has a few different problems
> 
> 1. intercepting reads and writes to take action at that time
> 
> 2. the fact that two programs can use it as an inter-process communication 
> mechanism.

...can and will use it as an IPC. So we need to modify some
applications.

Rather than modify all the applications using mmap (you can't tell if
the other side is going to use it for shared memory... right?), we
could simply modify all the Windows-facing applications using mmap.

> if you are worried about the IPC aspects, all you can do is forbid it, 

Can you automatically tell if applications are using mmap for IPC?

BTW in another mail you wanted to include /var/log/syslog from
scanning. You should not be doing that if syslog is exported to
Windows systems. Of course, you can get away with scanning syslog when
Windows client tries to read it, which should be acceptable...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
