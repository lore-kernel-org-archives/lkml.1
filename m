Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbXEIWDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbXEIWDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbXEIWDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:03:30 -0400
Received: from mx2.netapp.com ([216.240.18.37]:38113 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbXEIWD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:03:29 -0400
X-IronPort-AV: i="4.14,512,1170662400"; 
   d="scan'208"; a="58573374:sNHT18845904"
Subject: Re: [bisect] NFS regression breaks X
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Lever <chuck.lever@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NeilBrown <neilb@suse.de>, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <46423D62.2070200@garzik.org>
References: <46423D62.2070200@garzik.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: Network Appliance Inc
Date: Wed, 09 May 2007 18:03:26 -0400
Message-Id: <1178748206.6760.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 09 May 2007 22:03:41.0642 (UTC) FILETIME=[E78CD2A0:01C79285]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 17:30 -0400, Jeff Garzik wrote:
> Original bug report, with hardware and software info:
> http://lkml.org/lkml/2007/5/8/667
> 
> I love bisect :)  bisect has identified the following commit as the one 
> that causes my GNOME login to die, within 10 seconds of logging in:
> 
> 	commit 2bea90d43a050bbc4021d44e59beb34f384438db
> 	Author: Chuck Lever <chuck.lever@oracle.com>
> 	Date:   Thu Mar 29 16:47:53 2007 -0400
> 
> 	SUNRPC: RPC buffer size estimates are too large
> 
> 100% reproducible, verified regression.  My home directory is an NFSv4 
> mount, and the problem appears on my client workstation, so this makes 
> some sense:
> > sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
> > pretzel:/ on /g type nfs4 (rw,noatime,proto=tcp,addr=10.10.10.1)

Known issue. Could you try applying the commit at

http://linux-nfs.org/cgi-bin/gitweb.cgi?p=nfs-2.6.git;a=commitdiff;h=6ce7dc940701cf3fde3c6e826a696b333092cbb1;hp=aa3d1faebe6e214cd96be0e587571477ff6fd9fc

and see if that suffices to fix the issue?

> 
> As an aside, let me express the hope that the NFS developers develop 
> better patch creation methods.  My bisect compile repeatedly died at
> 
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   CHK     include/linux/compile.h
> > fs/nfs/pagelist.c:239: error: conflicting types for ‘nfs_pageio_init’
> > include/linux/nfs_page.h:80: error: previous declaration of ‘nfs_pageio_init’ was here
> > make[2]: *** [fs/nfs/pagelist.o] Error 1
> > make[1]: *** [fs/nfs] Error 2
> > make: *** [fs] Error 2
> 
> which indicates that someone on the NFS team did not create 
> wholly-contained patches when submitted to the kernel.  Build breakage 
> should not be fixed in a later commit (unless the breakage already went 
> upstream), because -- as we see here -- it breaks bisection.
> 
> 	Jeff, occasionally guilty of same, and trying to reform

The problem is that the above only appears to break on 64-bit compiles.
gcc gave no errors at all on a 386, and so the problem was detected only
after the merge.

Cheers
  Trond
