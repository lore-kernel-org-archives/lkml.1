Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbYAEVSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbYAEVSb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbYAEVSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:18:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42916 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756959AbYAEVSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:18:18 -0500
Date: Sat, 5 Jan 2008 22:18:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: freeze vs freezer
Message-ID: <20080105211826.GB25341@elf.ucw.cz>
References: <4744FD87.7010301@goop.org> <200801031215.07145.oliver@neukum.org> <477D5C4F.8050800@nigel.suspend2.net> <200801042154.08758.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801042154.08758.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-01-04 21:54:06, Oliver Neukum wrote:
> Am Donnerstag, 3. Januar 2008 23:06:07 schrieb Nigel Cunningham:
> > Hi.
> > 
> > Oliver Neukum wrote:
> > > Am Donnerstag, 3. Januar 2008 10:52:53 schrieb Nigel Cunningham:
> > >> Hi.
> > >>
> > >> Oliver Neukum wrote:
> > >>> Am Donnerstag 03 Januar 2008 schrieb Nigel Cunningham:
> > >>>> On top of this, I made a (too simple at the moment) freeze_filesystems
> > >>>> function which iterates through &super_blocks in reverse order, freezing
> > >>>> fuse filesystems or ordinary ones. I say 'too simple' because it doesn't
> > >>>> currently allow for the possibility of someone mounting (say) ext3 on
> > >>>> fuse, but that would just be an extension of what's already done.
> > >>> How do you deal with fuse server tasks using other fuse filesystems?
> > >> Since they're frozen in reverse order, the dependant one would be frozen
> > >> first.
> > > 
> > > Say I do:
> > > 
> > > a) mount fuse on /tmp/first
> > > b) mount fuse on /tmp/second
> > > 
> > > Then the server task for (a) does "ls /tmp/second". So it will be frozen,
> > > right? How do you then freeze (a)? And keep in mind that the server task
> > > may have forked.
> > 
> > I guess I should first ask, is this a real life problem or a
> > hypothetical twisted web? I don't see why you would want to make two
> > filesystems interdependent - it sounds like the way to create livelock
> > and deadlocks in normal use, before we even begin to think about
> > hibernating.
> 
> Good questions. I personally don't use fuse, but I do care about power
> management. The problem I see is that an unprivileged user could make
> that dependency, even inadvertedly.

Other problem is that unprivileged user can do it with evil intent. So
called "denial-of-service" attack.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
