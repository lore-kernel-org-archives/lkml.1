Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbXGENvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbXGENvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbXGENvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:51:07 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:42632 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113AbXGENvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:51:06 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, pavel@ucw.cz, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <200707051531.37532.rjw@sisk.pl>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051358.26963.rjw@sisk.pl> <E1I6QOA-0000bq-00@dorka.pomaz.szeredi.hu> <200707051531.37532.rjw@sisk.pl>
Message-Id: <E1I6RjE-0000pP-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 15:50:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Don't you think, however, that it can be modified a little to play well,
> > > for example, with the freezer?
> > 
> > I could stick a couple of try_to_freeze()s into fuse, and that would
> > make suspend failure less likely.  But making problems less easy to
> > reproduce is not a good thing.
> 
> So, how about eliminating them?

That can't be done just within fuse, a process might be sleeping on a
VFS mutex.  Do we want to hack VFS as well?

I guess I know your answer.  But it ain't gonna work.  Suspend code
really doesn't belong in VFS, and I'm pretty sure the maintainers of
that little piece of code would agree with me on this.

Miklos
