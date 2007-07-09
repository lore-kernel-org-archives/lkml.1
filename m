Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbXGIJcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbXGIJcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXGIJcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:32:46 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:55754 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbXGIJcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:32:45 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, pavel@ucw.cz, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org, nigel@nigel.suspend2.net
In-reply-to: <200707082307.15616.rjw@sisk.pl>
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
References: <200707050858.03638.oliver@neukum.org> <200707082008.57879.rjw@sisk.pl> <E1I7clo-0000JY-00@dorka.pomaz.szeredi.hu> <200707082307.15616.rjw@sisk.pl>
Message-Id: <E1I7pXr-0001Qn-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 09 Jul 2007 11:28:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Please have a look at the documentation update at the bottom of this patch:
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc7/patches/15-freezer-make-kernel-threads-nonfreezable-by-default.patch
> 
> It says what the freezer is for in the first place. :-)

Thanks, good description.

> > Yes, we need to make sure, that nothing is scheduled during (and
> > possibly after) taking the snapshot.  But AFAICS that could be
> > achieved by unplugging all but one CPU.
> 
> Actually, we want things to get scheduled, because we need some of them to
> save the image (to make things more difficult, we don't know what will be
> needed to save the image in advance ;-)).

Well, kexecing a new kernel (as being pursued in one of the
subthreads) to do the saving should take care of that.

In that case the "we need suspend to be invisible to userspace" as a
reason to use the freezer would also be moot, since if you don't
schedule userspace after offlining the CPUs, it can't notice this.

Miklos
