Return-Path: <linux-kernel-owner+w=401wt.eu-S1762340AbXGEUjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762340AbXGEUjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759507AbXGEUj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:39:26 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:52495 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967AbXGEUj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:39:26 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, oliver@neukum.org, pavel@ucw.cz, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <200707052220.00555.rjw@sisk.pl>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707052138.56920.oliver@neukum.org> <E1I6XFM-0001ek-00@dorka.pomaz.szeredi.hu> <200707052220.00555.rjw@sisk.pl>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1I6Y5o-0001qm-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 22:38:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > > Actually fuse allows SIGKILL, because it's always fatal, and the
> > > > > > syscall may not be restarted.
> > > > > 
> > > > > I think you want to stick try_to_freeze() at the same places where you
> > > > > do SIGKILL handling. That should solve the 'syslogd is unfreezeable'
> > > > > problem.
> > > > 
> > > > I could, but it would not solve the general problem.  Namely, that the
> > > > presence of fuse imposes a certain ordering in which userspace tasks
> > > > have to be frozen.  And it is not possible to know this ordering.
> > > 
> > > Actually, why do you need this? There is no absolute need that you
> > > finish the request. You must either finish the request or let yourself
> > > be frozen.
> > > 
> > > A quick look through fuse reveals principally request_wait_answer()
> > > And maybe a few other places. Is there some hidden reason you cannot
> > > handle being frozen here?
> > 
> > Yes, fuse could handle being frozen there.  However that would only
> > solve part of the problem: an operation waiting for a reply could be
> > holding a VFS mutex and some other task may be blocked on that mutex.
> > 
> > How would you solve freezing those tasks?
> 
> How probable is this situation?

I guess it depends on usage patterns.

I don't remember seeing any such cases, even though I have a permanent
fuse mount, and I suspend regularly.  But the fs is probably totally
idle during suspend in my case.

But some people use fuse as a home or root filesystem and in those
cases it can become quite likely to cause problems.

Miklos
