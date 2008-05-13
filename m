Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbYEMJDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbYEMJDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbYEMJDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:03:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53818 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756056AbYEMJDX (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:03:23 -0400
Date: Tue, 13 May 2008 19:03:11 +1000
From: David Chinner <dgc@sgi.com>
To: Georgi Chorbadzhiyski <gf@unixsol.org>
Cc: Donald Douwsma <donaldd@sgi.com>, xfs@oss.sgi.com,
       jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
Message-ID: <20080513090311.GZ155679365@sgi.com>
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com> <482951C3.60600@unixsol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482951C3.60600@unixsol.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 11:30:59AM +0300, Georgi Chorbadzhiyski wrote:
> >>http://mirrors.unixsol.org/slackware/slackware-12.1/kernels/hugesmp.s/config 
> >
> >Your distro is building all of these modules into the kernel.
> >    CONFIG_XFS_FS=y
> >    CONFIG_JFS_FS=y
> >    CONFIG_GFS2_FS=y
> >
> >This isnt exactly standard practice, normally they'd be set to =m and only
> >used if required to mount a filesystem. You may want to ask the slackware
> >people why they chose to do this for their hugexxx.s kernels.
> 
> I know that they are compiled in the kernel, but since they
> are not used isn't starting their own kthreads kind of
> unnecessary? Surely the threads can be started on demand
> only when xfs/etc volume is mounted.

Sure - XFS will start another three kernel threads per filesystem
that gets mounted. And for good measure, it cleans them up again
on unmount. :)

The other threads are per-cpu workqueue threads that are shared
across all XFS filesystems in the system and hence are started
when XFS is initialised rather than when a mount occurs.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
