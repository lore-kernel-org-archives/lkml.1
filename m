Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbYG2TD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbYG2TD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYG2TDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:03:47 -0400
Received: from waste.org ([66.93.16.53]:51451 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbYG2TDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:03:46 -0400
Subject: Re: [patch 2/4] Configure out file locking features
From: Matt Mackall <mpm@selenic.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080729181751.GA24924@parisc-linux.org>
References: <20080729154520.728594017@free-electrons.com> >
	 <20080729154747.872888047@free-electrons.com>
	 <20080729181751.GA24924@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 13:57:55 -0500
Message-Id: <1217357875.15724.167.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-29 at 12:17 -0600, Matthew Wilcox wrote:
> On Tue, Jul 29, 2008 at 05:45:22PM +0200, Thomas Petazzoni wrote:
> > This patch adds the CONFIG_FILE_LOCKING option which allows to remove
> > support for advisory locks. With this patch enabled, the flock()
> > system call, the F_GETLK, F_SETLK and F_SETLKW operations of fcntl()
> > and NFS support are disabled. These features are not necessarly needed
> > on embedded systems. It allows to save ~11 Kb of kernel code and data:
> > 
> >    text	   data	    bss	    dec	    hex	filename
> > 1125436	 118764	 212992	1457192	 163c28	vmlinux.old
> > 1114299	 118564	 212992	1445855	 160fdf	vmlinux
> >  -11137    -200       0  -11337   -2C49 +/-
> > 
> > This patch has originally been written by Matt Mackall
> > <mpm@selenic.com>, and is part of the Linux Tiny project.
> > 
> > Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
> In principle, I think this is a great idea.
> 
> >  config NFS_FS
> >  	tristate "NFS client support"
> > -	depends on INET
> > +	depends on INET && FILE_LOCKING
> >  	select LOCKD
> >  	select SUNRPC
> >  	select NFS_ACL_SUPPORT if NFS_V3_ACL
> 
> I think this part is a little lazy.  It should be possible to support
> NFS without file locking.  I suspect that's really not in-scope for the
> linux-tiny tree as currently envisaged with the focus on embedded
> devices that probably don't use NFS anyway.  Do we want to care about
> the situation of a machine with fixed workload, that doesn't need file
> locking, but does use NFS?

I would lean towards no, but if someone comes along who cares, they're
welcome to try it. This stuff all has to strike a balance between
savings and effort/complexity/maintainability, so any time the submitter
is too lazy to cover a less common use case, it's probably a good sign
they're approaching that tipping point. 

On the other hand, if you think it's trivial to do a locking-ectomy on
NFS, I'd be happy to see it.

The typical embedded NFS-based devices are NAS servers and media players
and are going to be more concerned about things like page cache
balancing.

-- 
Mathematics is the supreme nostalgia of our time.

