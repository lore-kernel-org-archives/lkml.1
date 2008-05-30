Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYE3JIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYE3JIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYE3JIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:08:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56572 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYE3JID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:08:03 -0400
To: hch@infradead.org
CC: bfields@fieldses.org, miklos@szeredi.hu, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, neilb@suse.de
In-reply-to: <20080530073607.GB7758@infradead.org> (message from Christoph
	Hellwig on Fri, 30 May 2008 03:36:07 -0400)
Subject: Re: [patch 4/8] nfsd: rename MAY_ flags
References: <20080529113245.450308367@szeredi.hu> <20080529113312.288347247@szeredi.hu> <20080529124701.GA13147@infradead.org> <E1K1iiF-00086t-Ve@pomaz-ex.szeredi.hu> <20080529204002.GC24018@fieldses.org> <20080530073607.GB7758@infradead.org>
Message-Id: <E1K20aX-0001NV-Vu@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 May 2008 11:07:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > don't think it does, but I'm interested in the nfsd maintainers'
> > > opinions.
> > 
> > This isn't something I've ever had a reason to care about.  What are you
> > trying to fix exactly?
> 
> The NFS MAY_ flags operate in the same name and number space and we'd
> easily get collisions when someone adds new MAY_ flags which miklos
> as well as at least two other independent efforts want to do.  To sort
> this out we'd either defined the nfsd MAY_ flags in fs.h to make it
> obvious we should not double-allocates bits or names, or use a different
> name and number space for the nfsd flags.  The first would be rather
> trivial but also ugly, the seconds sound much better but is a little
> more effort.  Just defined NFSD_MAY_ and use it everywhere and do a
> little translation inside nfsd_permission before passing it on to
> permission().

Yeah, I wouldn't mind that.  Although I'd still define NFSD_MAY_EXEC,
NFSD_MAY_READ and NFSD_MAY_WRITE to be exactly the same as MAY_EXEC,
etc..., and have the translation actually just mask off the rest of
the bits (as it does currently).

These three constants are very much ingrained in the UNIX tradition,
and it's no accident that the MAY_ flags correspond exactly to the
i_mode bits, which is something often exploited by permission checking
code.

Miklos
