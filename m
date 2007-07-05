Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbXGEV17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbXGEV17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760161AbXGEV1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:27:51 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:57131 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967AbXGEV1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:27:50 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, oliver@neukum.org, pavel@ucw.cz, paulus@samba.org,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org>
	(message from Alan Stern on Thu, 5 Jul 2007 17:15:24 -0400 (EDT))
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
References: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org>
Message-Id: <E1I6Yqk-00022q-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 23:26:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I fear, that your efforts to "save" the freezer are in vain.  It is
> > already moderately hackish with that PF_FREEZER_SKIP and the kernel
> > dotted randomly with try_to_freeze() calls, but adding bandaids to try
> > to order freezing userspace processes in the right order would just
> > make it a horrible mess.
> 
> I agree that bandaids won't work.  What's needed is something more 
> radical.  Things like FUSE must be written so that the kernel parts 
> _can_ freeze even while they are waiting for a response from a user 
> thread.

This has already been discussed, with the conclusion, that it can't be
done without hacking VFS internals.

The basic problem is that the freezer tries to get every user process
out of the kernel even when those processes have _nothing_ to do with
drivers and could happily stay in kernel land across a suspend or even
hibernate.

If we could have a good grip on when a request is entering a driver,
it would be easy to take care of this.  I guess network and block
devices are easy.  For others there's no obvious common place where
such barriers could be placed so it's more work, but nothing
conceptually problematic.  Is this about right?

Miklos
