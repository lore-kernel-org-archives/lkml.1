Return-Path: <linux-kernel-owner+w=401wt.eu-S1763405AbXGFJc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405AbXGFJc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbXGFJcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:32:22 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:41765 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951AbXGFJcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:32:22 -0400
To: nigel@suspend2.net
CC: miklos@szeredi.hu, benh@kernel.crashing.org, nigel@suspend2.net,
       rjw@sisk.pl, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, oliver@neukum.org,
       paulus@samba.org, mingo@elte.hu
In-reply-to: <200707061914.02972.nigel@nigel.suspend2.net> (message from Nigel
	Cunningham on Fri, 6 Jul 2007 19:13:56 +1000)
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer
References: <200707041658.59588.rjw@sisk.pl> <1183712394.3388.128.camel@localhost.localdomain> <E1I6jlB-0003TC-00@dorka.pomaz.szeredi.hu> <200707061914.02972.nigel@nigel.suspend2.net>
Message-Id: <E1I6kA9-0003Zt-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Jul 2007 11:31:41 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > On Fri, 2007-07-06 at 09:13 +0200, Miklos Szeredi wrote:
> > > > 
> > > > Another myth, that has been debunked already.  The problem is: how do
> > > > you define fuse processes?  There's no theoretical or even practial
> > > > way to do that.
> > > 
> > > It could if they told the kernel via some black magic ...
> > > 
> > > But that still suck. The freezer sucks :-)
> > 
> > Yeah, and it wouldn't work in practice, since the auxilary tasks might
> > be part of a library which is not even aware of being used by a "fuse
> > task".
> 
> This is why I think the whole concept of filesystems in userspace is broken. 
> Trying to shift things that need special privilege and special handling to 
> userspace is just asking for trouble.

I'm not claiming fuse doesn't introduce problems.  I've been tackling
those problems for a number of years now.  Suspend/hibernate is just
the next thing that needs looking at.

Just blaming either suspend or fuse for these problems is unproductive
and stupid.  The problems _are_ solvable if not always simply.

> You can say it's the kernel code's fault, but then you have to
> explain why it's only fuse (yeah ok, and XFS) that have problems.

I'm not faulting anythig.  My opinion, is that the freezer is not
needed for suspend, and removing it will not just solve the problems
with fuse but several others.  It probably needs a lot of work, but
hey, that's why we are here.

The patch posted by Rafael, which lets the freezer skip uninterrupible
tasks is a step in the right direction.

Miklos
