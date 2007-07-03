Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbXGCKrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbXGCKrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 06:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbXGCKrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 06:47:46 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:38660 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbXGCKrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 06:47:45 -0400
To: oliver@neukum.org
CC: linux-pm@lists.linux-foundation.org, benh@kernel.crashing.org,
       nigel@nigel.suspend2.net, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org
In-reply-to: <200707030944.18702.oliver@neukum.org> (message from Oliver
	Neukum on Tue, 3 Jul 2007 09:44:18 +0200)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <20070703042916.GA17240@srcf.ucam.org> <200707031608.06348.nigel@nigel.suspend2.net> <1183447184.10386.102.camel@localhost.localdomain> <200707030944.18702.oliver@neukum.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1I5fug-0003ZS-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jul 2007 12:47:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > So to summarize, the plan that makes things work with fuse is:
> > 
> >  - For STR, don't do the freezer thing.
> > 
> >  - For STD, don't sys_sync() after you froze
> > 
> > There might be -other- issues, but that should get you through some of
> 
> At the risk of repeating myself. Character device drivers are written
> with the assumption that normal io and suspend/resume do not race
> with each other due to the freezer.
> What do you intend to do about that?

Oliver, can you please explain your worries in a bit more detail?

I don't claim to know anything about how STR or hibernate works, but
neither seem to have any problem with I/O on the fuse device "racing"
with them.

And conceptually I can't see anything that would cause trouble either.
The fuse kernel module just provides a specialized IPC mechanism,
where one userspace process communicates with another using file
operations and a char dev.

Miklos
