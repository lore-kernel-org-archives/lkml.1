Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbXGEVak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbXGEVak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758906AbXGEVaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:30:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909AbXGEVa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:30:29 -0400
Date: Thu, 5 Jul 2007 23:30:20 +0200
From: Karel Zak <kzak@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Message-ID: <20070705213020.GB14825@petra.dvoda.cz>
References: <20070703221156.GY14825@petra.dvoda.cz> <20070704084211.GA19128@infradead.org> <200707051242.00625.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707051242.00625.vapier@gentoo.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 12:41:59PM -0400, Mike Frysinger wrote:
> On Wednesday 04 July 2007, Christoph Hellwig wrote:
> > On Wed, Jul 04, 2007 at 12:11:56AM +0200, Karel Zak wrote:
> > >  mount(8) doesn't include filesystem detection code anymore. You
> > >  have to compile --with-fsprobe={blkid,volume_id}, and libblkid
> > >  (e2fsprogs) or libvolume_id (udev >= v110) is required.
> >
> > Sorry, but it's really annoying to pull in a filesystem-specific devel
> > package for that.  Having a library is fine, but please move the library
> > into util-linux so it's always available without another dependency.
> 
> ugh, moving libraries which are already actively maintained by other core 
> projects into util-linux is so not a good idea (ignoring the fact that it'd 
> easily be a pita/waste for distro maintainers)

 Yes. We have good experience with libblkid and libvolume_id. This
 concept is nothing new (see current RHEL, FC, Suse, ...). The change
 is that we've removed old, useless and unmaintained FS detection code
 from util-linux.

 I think move the library to util-linux is really bad idea. A better
 idea is detach libblkid or libvolume_id (or both) from e2fsprogs/udev
 and create an independent libfsprobe library and use everywhere
 (e2fsprogs, udev, util-linux) this library only.

> > >  The package build system is now based on autotools. The build system
> > >  supports  separate CFLAGS and LDFLAGS for suid programs (SUID_CFLAGS,
> > >  SUID_LDFLAGS). For more details see the README file
> >
> > And this is really dumb.  autotools is a completely pain in the ass and

 Well, Adrian Bunk added autotools stuff to util-linux during his work
 on v2.13. This stuff has been fixed and stabilized in util-linux-ng
 v2.13.

 I'm not fanatical autotools protagonist, but it seems useful in
 util-linux. We will see...

 I'm ready to change or fix arbitrary thing in util-linux-ng, but I
 always need a real reason -- bug report, new feature, or so. This
 discussion is about impressions and feelings only.

> > not useful at all for linux-only tools.
> 
> incorrect.  linux changes over time as does the kernel/libc/architecture 
> api's.  look at the old util-linux build system -- it had a crappy hand 
> written configure script to try and detect all these different issues.

 Right. The autotools provides more features that portability only.

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
