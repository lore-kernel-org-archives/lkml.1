Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbXGDKTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbXGDKTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbXGDKTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:19:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48441 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbXGDKS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:18:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 12:26:33 +0200
User-Agent: KMail/1.9.5
Cc: paulus@samba.org, oliver@neukum.org, benh@kernel.crashing.org,
       mjg59@srcf.ucam.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070703042916.GA17240@srcf.ucam.org> <18059.21555.317415.928416@cargo.ozlabs.ibm.com> <E1I60CR-00066n-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I60CR-00066n-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041226.34799.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 10:26, Miklos Szeredi wrote:
> > > That's weird, I never had a suspend problem due to a fuse mount,
> > > though I have them all the time.  And I suspect, that even the sync()
> > 
> > Well, I don't either, because we don't freeze processes on
> > powerbooks.  But I have heard that other people have problems with
> > suspending with a fuse filesystem mounted.  Maybe the difference is
> > whether or not the filesystem is writable?
> > 
> > > thing that suspend does is not the real cause, because sync() actually
> > > does nothing in fuse filesystems.
> > 
> > It's not the filesystem sync method, as I understand it, it's that if
> > there are dirty pages in the page cache for files on the fuse
> > filesystem,
> 
> Currently fuse doesn't produce dirty pages.  Normal writes are done
> synchronously, and writable mmap is not supported.  So sync() should
> really be a no-op for fuse.
> 
> > the system will initiate a write-out on them and wait for it to
> > finish.  But if the fuse userspace is frozen, the write-out will
> > never complete.
> 
> Maybe there is some other fs operation being done, possibly not
> directly, but by waiting for a kernel thread, that does that.

We're going to limit the freezing of kernel threads to the ones that explicitly
want to be frozen, so if that's the case, then I think it'll be fixed soon.

> It would be nice, if someone who can reproduce the deadlock could
> debug it.

Agreed.

> Does sysrq still work during suspend? 

Yes, it should work.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
