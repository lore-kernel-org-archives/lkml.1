Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbYDXRXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbYDXRXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYDXRXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:23:45 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52491 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYDXRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:23:44 -0400
To: ezk@cs.sunysb.edu
CC: miklos@szeredi.hu, ezk@cs.sunysb.edu, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <200804241714.m3OHE0Ua014682@agora.fsl.cs.sunysb.edu> (message
	from Erez Zadok on Thu, 24 Apr 2008 13:14:00 -0400)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <200804241714.m3OHE0Ua014682@agora.fsl.cs.sunysb.edu>
Message-Id: <E1Jp5AP-0004Zd-ID@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 19:23:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Sure, unionfs already does some of it now (and some of it can be recoded
> > > more cleanly), but I'd like to get rid of much of it if I could -- these new
> > > path_* helpers make me have to maintain vfsmounts even moreso than before.
> > 
> > With the words of Al: "that is hogwash".  Stacks either maintain
> > vfsmounts or they don't.  There's no middle ground.
> 
> So, if I wanted to not maintain vfsmounts at all in unionfs, how can I use
> the proposed new path_* helpers which require vfsmounts?  Will there be some
> other helpers available to perform lower-filesystem operations (e.g., mkdir,
> create, unlink, etc.) which won't require passing vfsmounts?
> 
> The "or they don't" is not much of an option when I'm forced to use an API
> that requires a vfsmount...

Yes.  The vfsmount is already needed for open() and that pretty much
determines the fate of all stacking filesystems, except the ones which
don't want to do file I/O, but that is rather hard to imagine.

And anyway, I don't see the issue here.  If the stack wants to work on
a single filesystem directly, just do a bind mount of the original to
a kernel private mount and use that.  I'm not sure this can be done
with the current API, but it doesn't sound difficult to implement at
all.

Miklos
