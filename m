Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbZADXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbZADXFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZADXFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:05:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48054 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZADXFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:05:17 -0500
Date: Mon, 5 Jan 2009 00:07:12 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104230711.GH1913@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <200901041349.49906.rob@landley.net> <20090104220634.GD22958@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104220634.GD22958@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-01-04 17:06:34, Theodore Tso wrote:
> On Sun, Jan 04, 2009 at 01:49:49PM -0600, Rob Landley wrote:
> > 
> > Want to document the granularity issues with flash, while you're at it?
> > 
> > An inherent problem with using flash as a normal block device is that the 
> > flash erase size is bigger than most filesystem sector sizes.  So when you 
> > request a write, it may erase and rewrite the next 64k, 128k, or even a couple 
> > megabytes on the really _big_ ones.
> > 
> > If you lose power in the middle of that, ext3 won't notice that data in the 
> > "sectors" _after_ the one your were trying to write to got trashed.
> 
> True enough, although the newer SSD's will have this problem addressed
> (although at least initially, they are **far** more costly than the
> el-cheapo 32GB SD cards you can find at the checkout counter at Fry's
> alongside battery-powered shavers and trashy ipod speakers).

Hey, I got one of those el-cheapo 32GB SD cards. I fully expected it
to be slow, but eating my data 3 times per month was unexpected even
for me.

I'm not even sure where the blame is. I certainly blame the Linux
documentation: there should be "DON'T USE CRAPPY SD CARDS" warning in
big bold letters somewhere. I guess mkfs.ext3 should just refuse to
make filesystem on them. (Of course, the manufacturer should have told
me that the card is crap; I can bet it can not even work with
VFAT/Windows).

Plus I'd hope some filesystem materializes that can handle 128KB
"block size"... because the el-cheapo card I have here is actually
pretty sane. It seems to store data I put on it, and should be safe to
use with huge block size...  

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
