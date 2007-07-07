Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbXGGUPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbXGGUPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbXGGUPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:15:47 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:32802 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbXGGUPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:15:46 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, rjw@sisk.pl, mjg59@srcf.ucam.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <20070707115047.GE2789@elf.ucw.cz> (message from Pavel Machek on
	Sat, 7 Jul 2007 13:50:47 +0200)
Subject: Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <200707051704.48137.rjw@sisk.pl> <20070705150301.GB23647@srcf.ucam.org> <200707051727.36715.rjw@sisk.pl> <E1I6TJq-000164-00@dorka.pomaz.szeredi.hu> <20070707115047.GE2789@elf.ucw.cz>
Message-Id: <E1I7Gfq-0006n0-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 07 Jul 2007 22:14:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > One task doing ptrace() can basically do whatever it wants with the
> > task being traced.  This is not an exact analogy to what fuse does,
> > but close.
> 
> Well, IMO userland tasks should not have power to grab VFS mutexes for
> indefinite ammount of time. ("fused is allowed to deadlock kernel, in
> a way only write to special file helps" is ugly). Unfortunately, I
> don't think there's a way to work around that deadlock within fuse
> design limits... (coda was able to get around it by working on whole
> files granularity, AFAICT), so we'll have to live with that.

That's just file I/O.  You can easily deadlock coda with any other
file operation.  In fact coda is _less_ robust wrt a misbehaving
userspace server than fuse by a big margin.

Miklos
