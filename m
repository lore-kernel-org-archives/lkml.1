Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbXGCTcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbXGCTcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbXGCTcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:32:24 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:45112 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351AbXGCTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:32:23 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 21:32:20 +0200
User-Agent: KMail/1.9.7
Cc: rjw@sisk.pl, benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, nigel@nigel.suspend2.net
References: <20070703042916.GA17240@srcf.ucam.org> <200707032026.34649.oliver@neukum.org> <E1I5no4-0004fU-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I5no4-0004fU-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032132.20731.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Miklos Szeredi:
> > And a further question. The freezer is not atomic. What do you do
> > if a task not yet frozen calls sys_sync(), but fuse is already frozen?
> 
> What do you do if a task not yet frozen writes to a pipe, on the other
> end of which is a task already frozen?

The same as you do with a pipe when the reader is not ready.

> It doesn't matter.  The only thing that should matter during suspend
> (not hibernate) is saving the state of devices to ram, and putting the
> devices to sleep.

Well, but you did remove sys_sync() from the freezer, which is
and must be called in the hibernate path.
 
> I'm not sure why this can't be made atomic, but assuming, that it
> can't, fuse should still not need to be implicated.  If it is, that's
> an indication about something wrong in the suspend procedure.

Nope, something's wrong in fuse. You must be able to deal with sync
until every task is frozen.

	Regards
		Oliver

