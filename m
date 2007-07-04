Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbXGDI1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbXGDI1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbXGDI1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:27:25 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:40037 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbXGDI1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:27:24 -0400
To: paulus@samba.org
CC: miklos@szeredi.hu, oliver@neukum.org, benh@kernel.crashing.org,
       mjg59@srcf.ucam.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <18059.21555.317415.928416@cargo.ozlabs.ibm.com> (message from
	Paul Mackerras on Wed, 4 Jul 2007 18:02:59 +1000)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM
	pathway
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707031307.41366.oliver@neukum.org>
	<1183463053.10386.112.camel@localhost.localdomain>
	<200707031355.51028.oliver@neukum.org>
	<18058.56956.595143.15424@cargo.ozlabs.ibm.com>
	<E1I5ysv-0005xf-00@dorka.pomaz.szeredi.hu> <18059.21555.317415.928416@cargo.ozlabs.ibm.com>
Message-Id: <E1I60CR-00066n-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jul 2007 10:26:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > That's weird, I never had a suspend problem due to a fuse mount,
> > though I have them all the time.  And I suspect, that even the sync()
> 
> Well, I don't either, because we don't freeze processes on
> powerbooks.  But I have heard that other people have problems with
> suspending with a fuse filesystem mounted.  Maybe the difference is
> whether or not the filesystem is writable?
> 
> > thing that suspend does is not the real cause, because sync() actually
> > does nothing in fuse filesystems.
> 
> It's not the filesystem sync method, as I understand it, it's that if
> there are dirty pages in the page cache for files on the fuse
> filesystem,

Currently fuse doesn't produce dirty pages.  Normal writes are done
synchronously, and writable mmap is not supported.  So sync() should
really be a no-op for fuse.

> the system will initiate a write-out on them and wait for it to
> finish.  But if the fuse userspace is frozen, the write-out will
> never complete.

Maybe there is some other fs operation being done, possibly not
directly, but by waiting for a kernel thread, that does that.

It would be nice, if someone who can reproduce the deadlock could
debug it.  Does sysrq still work during suspend?

Miklos
