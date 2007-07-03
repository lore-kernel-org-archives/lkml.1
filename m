Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXGCUpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXGCUpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbXGCUpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:45:46 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:47147 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbXGCUpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:45:45 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 22:45:43 +0200
User-Agent: KMail/1.9.7
Cc: Miklos Szeredi <miklos@szeredi.hu>, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707031556160.7671-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707031556160.7671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032245.44087.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieben Sie:
> On Tue, 3 Jul 2007, Oliver Neukum wrote:
> 
> > Well, but you did remove sys_sync() from the freezer, which is
> > and must be called in the hibernate path.
> 
> That's not really true.  We _want_ to call sys_sync() in both the 
> hibernate and suspend paths (in case the batteries run down), to help 
> avoid filesystem problems if something goes wrong with the resume.  But 
> it isn't a hard requirement.

But the ability to launder pages is needed. During hibernation we need
to shrink memory. I don't see how this would be fundamentally different
from calling sync.

> > > I'm not sure why this can't be made atomic, but assuming, that it
> > > can't, fuse should still not need to be implicated.  If it is, that's
> > > an indication about something wrong in the suspend procedure.
> > 
> > Nope, something's wrong in fuse. You must be able to deal with sync
> > until every task is frozen.
> 
> That's ridiculous.  FUSE itself runs partially as a user task.  How can
> you expect it to carry out a sync or anything else when it is frozen?

I don't and it might point to a fundamental problem.
But I cannot help but notice that syscalls may happen while the system
is partially frozen. It must be dealt with.

> I suppose you could "deal" with it by having the kernel portion return
> an error if the userspace part is frozen.  If the hibernate/suspend 
> code bothered to check the return value, it would immediately abort 
> the suspend.

Where exactly would that code notice the errors?

	Regards
		Oliver

