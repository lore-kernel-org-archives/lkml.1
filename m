Return-Path: <linux-kernel-owner+w=401wt.eu-S1762224AbXGEUrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224AbXGEUrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbXGEUrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:47:07 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:54071 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239AbXGEUrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:47:06 -0400
To: oliver@neukum.org
CC: miklos@szeredi.hu, pavel@ucw.cz, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <200707052234.30021.oliver@neukum.org> (message from Oliver
	Neukum on Thu, 5 Jul 2007 22:34:29 +0200)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707052138.56920.oliver@neukum.org> <E1I6XFM-0001ek-00@dorka.pomaz.szeredi.hu> <200707052234.30021.oliver@neukum.org>
Message-Id: <E1I6YDJ-0001sj-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 22:46:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, fuse could handle being frozen there.  However that would only
> > solve part of the problem: an operation waiting for a reply could be
> > holding a VFS mutex and some other task may be blocked on that mutex.
> > 
> > How would you solve freezing those tasks?
> 
> OK, you made me reach for literatur on theoretical computer science.
> 
> IMHO the range of actions a fuse server is inherently limited.
> You must never ever block on a lock one of your clients is holding. In
> this case the limitation is not influenced by the freezer.

Obviously.  But I wasn't about the server trying to acquire a lock
held by a client.  I was talking about a client trying to acquire a
lock held by _another_ client.

If this coincides with the server (or some other task which the server
is depending on) being frozen before the clients, the freezer has a
problem.

> The freezer introduces a further limitation in that the server can freeze
> before the client, which must not be. You can prevent that by freezing
> the servers last.
> 
> In principle you might have dependencies between servers and you won't
> catch that, true. You won't catch servers blocking on IPC, but you are
> balancing on the edge of deadlock with fuse anyway.

Huh?

Miklos
