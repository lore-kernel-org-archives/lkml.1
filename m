Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZADWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZADWgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZADWgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:36:00 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58240 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZADWf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:35:59 -0500
Date: Sun, 4 Jan 2009 23:37:56 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, "Alexander E. Patrakov" <patrakov@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: document ext3 requirements
Message-ID: <20090104223756.GD1913@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <4960BB2D.3060000@gmail.com> <20090104183834.GB17558@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104183834.GB17558@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-01-04 13:38:34, Theodore Tso wrote:
> On Sun, Jan 04, 2009 at 06:35:41PM +0500, Alexander E. Patrakov wrote:
> >
> > Ext3 means either hardware that supports barriers (not sure how to  
> > check
> 
> Pretty much all modern disk drives supports barriers.  And note that
> w/o barriers ext3 has worked pretty well.  *If* you have a workload
> pushes your system into a mode which where it is very low on memory,
> so it is constantly paging/thrashing and you have a workload which is
> metadata intensive, and you crash the machine while it is thrashing,
> it is possible to end up in a situation where your filesystem is
> corrupted and you have to use e2fsck to correct the filesystem.  In

Are you sure you need to have thrashing? AFAICT metadata + fsync heavy
workload should be enough... and there were scripts to easily repeat
that.

> > Does this requirement apply to other  
> > journaling filesystems? Do I need journaling at all, given that I have  
> > an UPS on my desktop and a battery in the laptop?
> 
> Which requirement?  Barriers?  Most journaling filesystems simply
> enable barriers by default.  
> 
> And journalling is useful so that if your system crashes, say due to
> suspend and resume not working out, or the battery runs dry without
> your noticing it, you can avoid running fsck at boot time.  It's
> really more about shorting the boot time after a crash more than
> anything else.

Actually, journalling with barriers=0 should still be "safe" in case of
kernel crashes (*), right? Because if just kernel is dead, disk
firmware will still write the cache back, AFAICT.
									Pavel

(*) kernel crashes that do not involve writing random garbage to disk.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
