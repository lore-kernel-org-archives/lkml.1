Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbYAQUzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbYAQUzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757768AbYAQUyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:54:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52993 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758067AbYAQUyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:54:43 -0500
Date: Thu, 17 Jan 2008 21:54:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: Daniel Phillips <phillips@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Theodore Tso <tytso@mit.edu>,
       Al Boldi <a1426z@gawab.com>, Valerie Henson <val.henson@gmail.com>,
       Rik van Riel <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
	fsck)
Message-ID: <20080117205451.GB2065@elf.ucw.cz>
References: <20080112145140.GB6751@mit.edu> <20080113171916.GB4132@ucw.cz> <20080113174125.5f39ac64@lxorguk.ukuu.org.uk> <20080115201653.GA5639@elf.ucw.cz> <20080115214325.GN155407@sgi.com> <20080115230714.GC3573@elf.ucw.cz> <4d47a5d10801151544k3bc50223ob69c25d8732e3f12@mail.gmail.com> <20080116001503.3c0c97cf@lxorguk.ukuu.org.uk> <4d47a5d10801151724m418e18efp9a0dd936e9a3584c@mail.gmail.com> <20080115203616.081f073d@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115203616.081f073d@think.oraclecorp.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-01-15 20:36:16, Chris Mason wrote:
> On Tue, 15 Jan 2008 20:24:27 -0500
> "Daniel Phillips" <phillips@google.com> wrote:
> 
> > On Jan 15, 2008 7:15 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > > Writeback cache on disk in iteself is not bad, it only gets bad
> > > > if the disk is not engineered to save all its dirty cache on
> > > > power loss, using the disk motor as a generator or alternatively
> > > > a small battery. It would be awfully nice to know which brands
> > > > fail here, if any, because writeback cache is a big performance
> > > > booster.
> > >
> > > AFAIK no drive saves the cache. The worst case cache flush for
> > > drives is several seconds with no retries and a couple of minutes
> > > if something really bad happens.
> > >
> > > This is why the kernel has some knowledge of barriers and uses them
> > > to issue flushes when needed.
> > 
> > Indeed, you are right, which is supported by actual measurements:
> > 
> >     http://sr5tech.com/write_back_cache_experiments.htm
> > 
> > Sorry for implying that anybody has engineered a drive that can do
> > such a nice thing with writeback cache.
> > 
> > The "disk motor as a generator" tale may not be purely folklore.  When
> > an IDE drive is not in writeback mode, something special needs to done
> > to ensure the last write to media is not a scribble.
> > 
> > A small UPS can make writeback mode actually reliable, provided the
> > system is smart enough to take the drives out of writeback mode when
> > the line power is off.
> 
> We've had mount -o barrier=1 for ext3 for a while now, it makes
> writeback caching safe.  XFS has this on by default, as does reiserfs.

Maybe ext3 should do barriers by default? Having ext3 in "lets corrupt
data by default"... seems like bad idea.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
