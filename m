Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbYDXQw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbYDXQw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYDXQwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:52:46 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34464 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbYDXQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:52:45 -0400
Date: Thu, 24 Apr 2008 12:52:27 -0400
Message-Id: <200804241652.m3OGqRGQ011996@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts 
In-reply-to: Your message of "Thu, 24 Apr 2008 13:39:50 +0200."
             <20080424113950.818688067@szeredi.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080424113950.818688067@szeredi.hu>, Miklos Szeredi writes:
> Patches 1-3 are cleanups/bugfixes preceding the main series.  The
> description is in 4/13.  This is against latest git.
> 
> <rant>
> 
> R/O bind mounts patches have been reviewed numerous times.  Still a
> relatively large number of places remained where checking for R/O
> mounts was missed.
> 
> Then I did this series, which basically guarantees, that that cannot
> happen.  Al rejected it, and rather fixed some of the remaining
> places.  He still missed several, which sort of proves my point.
> 
> I think it's totally pointless to continue trying to fix the symptoms
> instead of getting at the root of the problem.
> 
> I know that VFS interfaces are a sensitive question, but it would be
> nice it we could have some sanity back in this discussion.

And I'll reiterate my desire (see http://lkml.org/lkml/2008/4/8/394) for
stackable file systems to know as little as possible about vfsmounts (or
their derivatives ala struct path).  If I have to call helpers which require
vfsmounts, but similar objects don't get passed to me somehow, then I have
to maintain vfsmounts on my own.

Sure, unionfs already does some of it now (and some of it can be recoded
more cleanly), but I'd like to get rid of much of it if I could -- these new
path_* helpers make me have to maintain vfsmounts even moreso than before.

> </rant>
> 
> Thanks,
> Miklos

Erez.
