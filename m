Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZHJN3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZHJN3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZHJN3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:29:54 -0400
Received: from THUNK.ORG ([69.25.196.29]:32927 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbZHJN3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:29:53 -0400
Date: Mon, 10 Aug 2009 09:29:34 -0400
From: Theodore Tso <tytso@mit.edu>
To: Daniel Phillips <phillips@phunq.net>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@pobox.com>,
       debian developer <debiandev@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, tux3@tux3.org,
       LKML <linux-kernel@vger.kernel.org>, corbet@lwn.net
Subject: Re: [Tux3] Current Activities?
Message-ID: <20090810132934.GC20471@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Daniel Phillips <phillips@phunq.net>, Ingo Molnar <mingo@elte.hu>,
	Jeff Garzik <jgarzik@pobox.com>,
	debian developer <debiandev@gmail.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, tux3@tux3.org,
	LKML <linux-kernel@vger.kernel.org>, corbet@lwn.net
References: <6dcc37b30904291901m7abdd6d7q6f44b2c248ec48c4@mail.gmail.com> <200908010942.52623.phillips@phunq.net> <20090806075246.GA6860@elte.hu> <200908081647.21279.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908081647.21279.phillips@phunq.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 04:47:21PM -0700, Daniel Phillips wrote:
> I will very briefly address Ted's question, which amounts to: "why
> do we want Tux3?"  I think Tux3 fills an empty niche in our filesystem
> ecology where a simple, clean and modern general purpose filesystem
> should exist and there is none.  

You'll need to define "simple", "clean", and "modern" here; but this
isn't something that makes a lot of sense to an end-user.

> In concrete terms, Tux3 implements a
> single-pointer-per-extent model that Btrfs and ZFS do not.  This allows
> a very simple *physical* design, with much complexity pushed to the
> *logical* level where things generally behave better.  

This isn't very compelling, either....

> A simple physical
> design offers many benefits, including making it easier to take a run at
> that holiest of holy grails, online check and repair.

Note that a simple physical design does not necessarily enable online
check/repair.  In fact, without back pointers (which add complexity),
doing online checking can be completely impractical for large
filesystems.  There's been quite a lot of thinking on this subject;
see Val's "Repair-driven Filesystem Design" paper.

> In even more concrete terms, Tux3 already demonstrates a tiny memory
> footprint, unlike Btrfs or ZFS.  Its CPU footprint is also tiny.  As
> such, Tux3 could easily run on a cellphone or smaller device, while
> offering a full range of "big filesystem" capabilities.  (Note that
> Zumastor already proves we know how to do replication properly:
> http://zumastor.org/.)

Well, btrfs currently weighs in at 302k of compiled object code.
While that's certainly not small (ext4+jbd2 weighs in at 256k;
ext3+jbd weighs in at 124k; ext2 at 42k), 300k isn't going to break
the bank on most cell phones that would be running Linux these days.
And on a cell phone, it might very well be that some flash-based
filesystem such as JFFS2 or UBIFS would be a better choice in any
case.

If the goal is to find corporate sponsorship for Tux3, I'd strongly
encourage you to think harder about a compelling story for why Tux3 is
so cool that companies should spend money supporting it.  Let me
gently suggest to you that "it'll have fewer features than btrfs, but
it will use less memory" is not a particularly compelling story to a
company's technical and management leadership who is figure out
spending priorities for next year's budget.  Particularly if the cell
phone is going to have megabytes of memory to run Java on it anyway;
and even if it's not running Java, have you seen how much space
graphical libraries take up these days?  :-)

Again, I'm not saying this to discourage technical people from working
on Tux3.  But just because you're passionate about a technology,
doesn't mean that it automatically translate to there being a business
case to convince companies to invest in that technology.

Best regards,

              	   	    	       	   	- Ted
