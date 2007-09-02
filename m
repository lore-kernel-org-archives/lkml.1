Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbXIBUot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbXIBUot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbXIBUol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:44:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37311 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXIBUok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:44:40 -0400
Date: Mon, 3 Sep 2007 02:27:48 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] drivers/md/: Shut up uninitialized variable
 warnings
In-Reply-To: <46DB1E5C.2080107@garzik.org>
Message-ID: <alpine.LFD.0.999.0709030220210.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n> <alpine.LFD.0.999.0709030151320.29617@enigma.security.iitk.ac.in>
 <46DB1E5C.2080107@garzik.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-514402326-1188766671=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-514402326-1188766671=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp



On Sun, 2 Sep 2007, Jeff Garzik wrote:

> Satyam Sharma wrote:
> > drivers/md/dm-exception-store.c: In function ‘persistent_read_metadata’:
> > drivers/md/dm-exception-store.c:452: warning: ‘new_snapshot’ may be used
> > uninitialized in this function
> > 
> > drivers/md/dm-ioctl.c: In function ‘ctl_ioctl’:
> > drivers/md/dm-ioctl.c:1407: warning: ‘param’ may be used uninitialized in
> > this function
> > 
> > [ For these, I'd like to especially add -- shame on you, gcc! ]
> > 
> > drivers/md/dm-table.c: In function ‘dm_get_device’:
> > drivers/md/dm-table.c:472: warning: ‘dev’ may be used uninitialized in this
> > function
> > 
> > are all verified to be bogus warnings. Let's shut them up.
> > 
> > ---
> > 
> >  drivers/md/dm-exception-store.c |    3 ++-
> >  drivers/md/dm-ioctl.c |    2 +-
> >  drivers/md/dm-table.c |    2 +-
> >  3 file changed, 4 insertions(+), 3 deletion(-)
> 
> same comment as with the last uninit'd var patch:  these markers should be
> used sparingly.  Try it on multiple compiler versions, see if it's a new
> behavior.
> 
> Quite realistically, you might actually be finding gcc bugs,

Definitely -- a lot of these patches are purely a result of gcc's shoddy
inadequacies. I do intend filing reports with gcc, however ...

> implying the
> proper path is to file a gcc bug report (and they are _very_ diligent about
> handling these, its impressive) rather than to patch the Linux kernel.

My experience (regarding gcc's diligence in dealing with bug reports) has
been otherwise :-)

Anyway, I once had a _very_ similar discussion with Andrew (regarding some
other gcc bug) previously, and the (completely correct) point he made was
that: firstly, there's no guarantee they'll get this sorted out asap, and
even if they did, we'll still not be dropping support for older gcc
versions anyway ...
--464262402-514402326-1188766671=:29617--
