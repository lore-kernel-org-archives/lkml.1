Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbXGCL2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbXGCL2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbXGCL2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:28:00 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:51385 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbXGCL17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:27:59 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 13:27:55 +0200
User-Agent: KMail/1.9.7
Cc: linux-pm@lists.linux-foundation.org, benh@kernel.crashing.org,
       nigel@nigel.suspend2.net, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707031307.41366.oliver@neukum.org> <E1I5gSu-0003f4-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I5gSu-0003f4-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707031327.56577.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Miklos Szeredi:
> > > > > So to summarize, the plan that makes things work with fuse is:
> > > > > 
> > > > >  - For STR, don't do the freezer thing.
> > > > > 
> > > > >  - For STD, don't sys_sync() after you froze
> > > > > 
> > > > > There might be -other- issues, but that should get you through some of
> > > > 
> > > > At the risk of repeating myself. Character device drivers are written
> > > > with the assumption that normal io and suspend/resume do not race
> > > > with each other due to the freezer.
> > > > What do you intend to do about that?
> > > 
> > > Oliver, can you please explain your worries in a bit more detail?
> > > 
> > > I don't claim to know anything about how STR or hibernate works, but
> > > neither seem to have any problem with I/O on the fuse device "racing"
> > > with them.
> > 
> > The problem is not with fuse. The problem is generic in nature.
> > 
> > If you remove the freezer, user space remains active until the last CPU
> > goes into suspend. It can do syscalls. Or do you know a clean way to exempt
> > only the tasks fuse might use?
> 
> You are talking about hibernate, right?  Suspending (to ram) is
> instantaneous, in that _after_ suspend no CPU is active obviously.

If that is so, why do you care? If it is really atomic, fuse has no chance
to call out to its component in user space either. Removing the freezer
cannot make a difference.

Something is fishy here.

	Regards
		Oliver

