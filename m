Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbXGEITS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbXGEITS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbXGEITK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:19:10 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:37042 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886AbXGEITJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:19:09 -0400
To: oliver@neukum.org
CC: paulus@samba.org, stern@rowland.harvard.edu, johannes@sipsolutions.net,
       rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, mjg59@srcf.ucam.org,
       benh@kernel.crashing.org
In-reply-to: <200707050858.03638.oliver@neukum.org> (message from Oliver
	Neukum on Thu, 5 Jul 2007 08:58:03 +0200)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 10:17:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I have discussed the benefits elsewhere.  As for the deadlocks -- do 
> > > you still observe them if you use the version of the freezer which 
> > > doesn't freeze kernel threads?
> > 
> > In general the only way to guarantee there are no deadlocks is to
> > construct the graph of dependencies between tasks.  Those dependencies
> > are not in practice observable from outside the tasks, so it is
> > virtually impossible to construct the graph.
> 
> In which way can user space tasks depend on each other in a way that
> allows a them members of that cycle to be in uninterruptible sleep?

 - process A calls rename() on a fuse fs
 - process B, the fuse server, starts to process the rename request
 - process B is frozen before it can reply

Now process A is unfreezable.  We cannot make rename() restartable,
hence it cannot be interruptible.

Miklos
