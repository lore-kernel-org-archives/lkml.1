Return-Path: <linux-kernel-owner+w=401wt.eu-S1761773AbYA1UBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773AbYA1UBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745AbYA1UBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:01:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1968 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755959AbYA1UBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:01:19 -0500
Date: Mon, 28 Jan 2008 20:01:06 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
       David Chinner <dgc@sgi.com>, Valerie Henson <val@vahconsulting.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>,
       Ric Wheeler <ric@emc.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Message-ID: <20080128200105.GA4719@ucw.cz>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com> <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com> <20080121230041.GL3180@webber.adilger.int> <20080122033830.GR155259@sgi.com> <3673.1200975438@turing-police.cc.vt.edu> <20080122070050.GM3180@webber.adilger.int> <20080122144052.GC17804@mit.edu> <20080128193005.GC4032@ucw.cz> <20080128195633.GB20528@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128195633.GB20528@mit.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-01-28 14:56:33, Theodore Tso wrote:
> On Mon, Jan 28, 2008 at 07:30:05PM +0000, Pavel Machek wrote:
> > 
> > As user pages are always in highmem, this should be easy to decide:
> > only send SIGDANGER when highmem is full. (Yes, there are
> > inodes/dentries/file descriptors in lowmem, but I doubt apps will
> > respond to SIGDANGER by closing files).
> 
> Good point; for a system with at least (say) 2GB of memory, that
> definitely makes sense.  For a system with less than 768 megs of
> memory (how quaint, but it wasn't that long ago this was a lot of
> memory :-), there wouldn't *be* any memory in highmem at all....

Ok, so it is 'send SIGDANGER when all zones are low', because user
allocations can go from all zones (unless you have something really
exotic, I'm not sure if that is true on huge NUMA  machines & similar).

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
