Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0BLTYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:24:01 -0500
Received: from bamako.nerim.net ([62.4.17.28]:54951 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab0BLTYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:24:00 -0500
Date: Fri, 12 Feb 2010 20:23:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "J.H." <warthog9@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100212202357.6363d5af@hyperion.delvare>
In-Reply-To: <4B75A5DC.3060803@kernel.org>
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
	<4B75A5DC.3060803@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 11:02:52 -0800, J.H. wrote:
> On 02/12/2010 07:21 AM, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 12 Feb 2010, Jean Delvare wrote:
> >>
> >> Maybe that's just me, but my main concern is neither download times nor
> >> decompression times. My main concern is the access time to directory
> >> indexes when browsing the kernel archive, because there are 5 entries
> >> for every patch or tarball: .bz2, .bz2.sign, .gz, .gz.sign and .sign.
> >> This is horribly slow.
> > 
> > This was actually the main reason for me personally to ask about just 
> > dropping support for .gz files - not because I care deeply about how much 
> > disk space kernel.org wastes, but because the long directory listings make 
> > it slower for me to mentally index the directory.
> 
> It's probably worth keeping things like the .gz files around, if nothing
> else for older distros, systems, etc that don't have xz yet (since it's
> still relatively new)

Hardly a good reason IMHO. xz can be installed on these systems. When
we switched to git, nobody had it and it did not stop us.

> 
> Breaking things out into directories or such might be the easiest way
> with that
> 
> v2.6/
> v2.6/2.6.23

Yes.

> v2.6/2.6.32.6

I'd rather group all 2.6.32.* files together, so that the main index is
as small as possible. We're adding one indirection step, so it should
be fast.

> 
> etc
> 
> Would clean up the v2.6 directory a lot.

> >> (...)
> >> 4* Get rid of the LATEST-IS-* files. This is a small count, won't save
> >> much, but these files seem totally useless to me these days.
> > 
> > Yeah, they also end up continually being stale.
> 
> Only thoughts there are that there seem to be a lot of automated
> processes that rely on LATEST-IS-*.

Care to give details? Given how often the old files get stuck, I am
surprised any process can really rely on them. And I also can't really
think of any automated process that would care.

>  Personally I'd rather see them snag
> the RSS feed and figure out what they want from there, but that may not
> be completely feasible.

There's RSS, there's a mailing list and there's a web page. Certainly
one of these 3 methods would work.

>  It also gives a quick indication as to what's
> latest in the directory

Sorting by time works just as well.

> and a quick search on the page usually gets me
> what I'm looking for when I do it.

What's your workflow? I normally go to the download directory after
either reading the kernel.org main page or some post on the announce
mailing list. So I already know which version I am looking for. Having
to search for "LATEST-IS" and then again for the version doesn't look
terribly efficient.

If we really want a helper to locate the latest version, I'd rather
have a "latest" symbolic link pointing to the most recent v2.6.x
subdirectory. Or maybe two, "latest-stable" and "latest-devel". Can be
discussed...

-- 
Jean Delvare
