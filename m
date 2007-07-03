Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbXGCTso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbXGCTso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbXGCTsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:48:37 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:47568 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494AbXGCTsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:48:36 -0400
To: oliver@neukum.org
CC: rjw@sisk.pl, benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, nigel@nigel.suspend2.net
In-reply-to: <200707032132.20731.oliver@neukum.org> (message from Oliver
	Neukum on Tue, 3 Jul 2007 21:32:20 +0200)
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <20070703042916.GA17240@srcf.ucam.org> <200707032026.34649.oliver@neukum.org> <E1I5no4-0004fU-00@dorka.pomaz.szeredi.hu> <200707032132.20731.oliver@neukum.org>
Message-Id: <E1I5oLf-0004lk-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jul 2007 21:47:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Am Dienstag, 3. Juli 2007 schrieb Miklos Szeredi:
> > > And a further question. The freezer is not atomic. What do you do
> > > if a task not yet frozen calls sys_sync(), but fuse is already frozen?
> > 
> > What do you do if a task not yet frozen writes to a pipe, on the other
> > end of which is a task already frozen?
> 
> The same as you do with a pipe when the reader is not ready.

Yes.  And if the fuse process is not ready, what will sys_sync() do?

(As a side note, sys_sync() actually does nothing in fuse, so these
examples are slightly silly, but the concept applies to any filesystem
operation).

> > It doesn't matter.  The only thing that should matter during suspend
> > (not hibernate) is saving the state of devices to ram, and putting the
> > devices to sleep.
> 
> Well, but you did remove sys_sync() from the freezer, which is
> and must be called in the hibernate path.

Since I don't know why sync() needs to be called from hibernate, I
can't argue about this.  But for _suspend_ it definitely should not be
needed.

> > I'm not sure why this can't be made atomic, but assuming, that it
> > can't, fuse should still not need to be implicated.  If it is, that's
> > an indication about something wrong in the suspend procedure.
> 
> Nope, something's wrong in fuse. You must be able to deal with sync
> until every task is frozen.

Why exactly?  That's like saying the pipe must be able to deal with
writes until every task is frozen.

As I've said, fuse is just special kind of IPC.  The task calling into
fuse can assume nothing about when it's request will be served.  Just
like a task writing into a pipe can assume nothing about when that
write will return.

Miklos
