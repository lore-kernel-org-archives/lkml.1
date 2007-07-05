Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbXGEPdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbXGEPdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbXGEPdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:33:14 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:40966 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbXGEPdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:33:13 -0400
To: rjw@sisk.pl
CC: mjg59@srcf.ucam.org, pavel@ucw.cz, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <200707051727.36715.rjw@sisk.pl>
Subject: Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <200707051704.48137.rjw@sisk.pl> <20070705150301.GB23647@srcf.ucam.org> <200707051727.36715.rjw@sisk.pl>
Message-Id: <E1I6TJq-000164-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 17:32:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > You have processes that don't react to signals, because some
> > > other user land task is misbehaving.  I'd call that ugly at the
> > > very least.
> > 
> > It already happens with, say, NFS. Don't think about it in terms of a 
> > userland task misbehaving - think of it in terms of a resource becoming 
> > unavailable.
> 
> I think there's a difference between a userland task playing the role of a
> resource and a "real" external resource the kernel doesn't control.
> 
> IMO, userland tasks should not have the power to affect each other as though
> they were parts of the kernel.

One task doing ptrace() can basically do whatever it wants with the
task being traced.  This is not an exact analogy to what fuse does,
but close.

And for this reason the security model for allowing access to a fuse
filesystem is similar to that for allowing tracing.

The gory details can be found in Documentation/filesystems/fuse.txt.

Miklos
