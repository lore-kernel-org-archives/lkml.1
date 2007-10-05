Return-Path: <linux-kernel-owner+w=401wt.eu-S1764309AbXJEUuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764309AbXJEUuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762541AbXJEUuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:50:00 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:18588 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761487AbXJEUt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:49:59 -0400
Date: Fri, 5 Oct 2007 21:49:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Guennadi Liakhovetski <lg@denx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: tmpfs disabled in .config but in /proc/filesystems
In-Reply-To: <Pine.LNX.4.60.0710052134180.10392@poirot.grange>
Message-ID: <Pine.LNX.4.64.0710052136460.17084@blonde.wat.veritas.com>
References: <Pine.LNX.4.60.0710051637200.10392@poirot.grange>
 <Pine.LNX.4.64.0710051637380.16909@blonde.wat.veritas.com>
 <Pine.LNX.4.60.0710052134180.10392@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Guennadi Liakhovetski wrote:
> On Fri, 5 Oct 2007, Hugh Dickins wrote:
> > On Fri, 5 Oct 2007, Guennadi Liakhovetski wrote:
> > > Am I running crazy here (some 2.6.23-rc6-ish)?
> > > 
> > > $ zcat /proc/config.gz | grep TMPFS
> > > # CONFIG_TMPFS is not set
> > > $ grep tmpfs /proc/filesystems
> > > nodev   tmpfs
> > 
> > tmpfs (mm/shmem.c) is used by the kernel to support shared memory
> > of various kinds even when CONFIG_TMPFS is not set.  But only when
> > CONFIG_TMPFS=y can users mount a tmpfs as a fully capable filesystem.
> > Confusing, yes: sorry for putting the fear of craziness upon you.
> 
> Oops, sorry, now I remember reading about this... As a matter of fact, the 
> presence in /proc/filesystem - was it a deliberate decision, or 
> technically preferrable or a mistake?

d) None of the above!

I've never really thought about it, but I think it's simply a natural
side-effect of the register_filesystem and vfs_kern_mount it has to
do in order to get the services it needs from the VFS.

If I were to look back in history, I expect I'd find that it used
to display as "shmfs" or "shmemfs" rather than "tmpfs", and that
we adjusted the naming later on.   You might prefer that we hadn't,
or that we registered under both names if CONFIG_TMPFS (maybe we did
do it like that at one stage, I vaguely remember but haven't checked).

> Wouldn't it be more logical to 
> completely hide it from the user then?

Sorry, I find it hard to get excited about!
I'm inclined not to mess around with it now.
With apologies to your sanity ;)

Hugh
