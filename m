Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbXGWK2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbXGWK2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760748AbXGWK2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:28:39 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:47334 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbXGWK2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:28:38 -0400
To: nigel@nigel.suspend2.net
CC: stern@rowland.harvard.edu, nigel@suspend2.net, jbms@cmu.edu,
       miklos@szeredi.hu, rjw@sisk.pl, miltonm@bga.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
In-reply-to: <200707230842.22121.nigel@nigel.suspend2.net> (message from Nigel
	Cunningham on Mon, 23 Jul 2007 08:42:17 +1000)
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org> <200707230842.22121.nigel@nigel.suspend2.net>
Message-Id: <E1ICv5g-0003oN-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Jul 2007 12:24:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The only thing to do is what Rafael has been working on: unfreeze
> > things, hope the tasks sort themselves out, and try again.
> 
> That's what I'm questioning. Is there a more reliable way and we've
> just given up too quickly?

There obviously _are_ more reliable ways.  A trivial one seems to be
to just not require user tasks to finish syscalls.

Yeah, stopping user processes outside the kernel is convenient, but
there's no fundamental reason why it is the only place where those
tasks can be stopped.

And there are very fundamental reasons to _not_ require this.  Not
just in the fuse case, but in any case where a syscall requires
another user task to run before it can be finished (e.g. NFS over
OpenVPN).

Miklos
