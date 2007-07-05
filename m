Return-Path: <linux-kernel-owner+w=401wt.eu-S1762333AbXGEUMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333AbXGEUMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbXGEUMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:12:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55096 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758951AbXGEUMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:12:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 22:19:59 +0200
User-Agent: KMail/1.9.5
Cc: oliver@neukum.org, pavel@ucw.cz, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707052138.56920.oliver@neukum.org> <E1I6XFM-0001ek-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6XFM-0001ek-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707052220.00555.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 21:44, Miklos Szeredi wrote:
> > Am Donnerstag, 5. Juli 2007 schrieb Miklos Szeredi:
> > > > > Actually fuse allows SIGKILL, because it's always fatal, and the
> > > > > syscall may not be restarted.
> > > > 
> > > > I think you want to stick try_to_freeze() at the same places where you
> > > > do SIGKILL handling. That should solve the 'syslogd is unfreezeable'
> > > > problem.
> > > 
> > > I could, but it would not solve the general problem.  Namely, that the
> > > presence of fuse imposes a certain ordering in which userspace tasks
> > > have to be frozen.  And it is not possible to know this ordering.
> > 
> > Actually, why do you need this? There is no absolute need that you
> > finish the request. You must either finish the request or let yourself
> > be frozen.
> > 
> > A quick look through fuse reveals principally request_wait_answer()
> > And maybe a few other places. Is there some hidden reason you cannot
> > handle being frozen here?
> 
> Yes, fuse could handle being frozen there.  However that would only
> solve part of the problem: an operation waiting for a reply could be
> holding a VFS mutex and some other task may be blocked on that mutex.
> 
> How would you solve freezing those tasks?

How probable is this situation?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
