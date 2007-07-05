Return-Path: <linux-kernel-owner+w=401wt.eu-S1759001AbXGEIis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001AbXGEIis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbXGEIik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:38:40 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:60231 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbXGEIij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:38:39 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, stern@rowland.harvard.edu, oliver@neukum.org,
       paulus@samba.org, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <200707042336.58466.rjw@sisk.pl>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
References: <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org> <E1I6ATN-0007QS-00@dorka.pomaz.szeredi.hu> <200707042336.58466.rjw@sisk.pl>
Message-Id: <E1I6Mq2-0008WB-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 10:37:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Pro-freezers say:
> > 
> >   - don't remove the freezer, otherwise we'll have to deal with
> >     numerous problems in drivers
> 
> And these problems will generally be difficult to reproduce reliably
> and debug.

I see exactly the opposite.

With the freezer I can have very rarely occuring failures, due to
freeze ordering effects.

And without the freezer I have a 100% reproducable problem, that is
not hard to fix according to Alan Stern.  OK, I don't know what the
next problem would be, but the powermac experience shows, that it's
not nearly as bad as you and Oliver try to make it out.

> > Can this be fixed?
> > 
> > It seems to be a fundamental problem with the freezer: while it does
> > make sure that user processes are not calling into drivers during
> > suspend, it also disallows perfectly harmless non-driver calls as
> > well.
> 
> The problem is that when the freezer was designed (I didn't do that, BTW),
> there was no FUSE and similar things, so it's not prepared to cope with
> such interdependencies between user space tasks.
> 
> We had an analogous problem with vfork() and it was solved by using the
> PF_FREEZER_SKIP flag.  Perhaps we can do similar thing with FUSE.

It cannot be just worked around in fuse, as a task might be sleeping
on a number of VFS mutexes as well (i_mutex, s_vfs_rename_mutex, etc).
It would be a gigantic hack, possible at all.

Miklos
