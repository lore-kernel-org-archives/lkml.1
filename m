Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbXGCTOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbXGCTOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbXGCTNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:13:51 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:43538 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbXGCTNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:13:51 -0400
To: oliver@neukum.org
CC: rjw@sisk.pl, benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, nigel@nigel.suspend2.net
In-reply-to: <200707032026.34649.oliver@neukum.org> (message from Oliver
	Neukum on Tue, 3 Jul 2007 20:26:34 +0200)
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <20070703042916.GA17240@srcf.ucam.org> <200707031508.45595.rjw@sisk.pl> <200707031709.29968.rjw@sisk.pl> <200707032026.34649.oliver@neukum.org>
Message-Id: <E1I5no4-0004fU-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jul 2007 21:13:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> And a further question. The freezer is not atomic. What do you do
> if a task not yet frozen calls sys_sync(), but fuse is already frozen?

What do you do if a task not yet frozen writes to a pipe, on the other
end of which is a task already frozen?

It doesn't matter.  The only thing that should matter during suspend
(not hibernate) is saving the state of devices to ram, and putting the
devices to sleep.

I'm not sure why this can't be made atomic, but assuming, that it
can't, fuse should still not need to be implicated.  If it is, that's
an indication about something wrong in the suspend procedure.

Miklos
