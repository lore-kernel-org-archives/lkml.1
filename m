Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbXLGWeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbXLGWeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXLGWe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:34:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282AbXLGWe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:34:27 -0500
Date: Fri, 7 Dec 2007 14:33:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: gnome42@gmail.com, linux-kernel@vger.kernel.org, bfields@fieldses.org,
       rjw@sisk.pl
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Message-Id: <20071207143319.ee048955.akpm@linux-foundation.org>
In-Reply-To: <1197053179.7532.23.camel@heimdal.trondhjem.org>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	<20071207040219.e231cbc7.akpm@linux-foundation.org>
	<fa4052ef0712071014l524951e2we4705d84c5005cf3@mail.gmail.com>
	<1197053179.7532.23.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2007 13:46:19 -0500
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> 
> On Fri, 2007-12-07 at 13:14 -0500, Shane wrote:
> > On Dec 7, 2007 7:02 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > ...
> > > > 2.6.24-rc3-git1 is last known good kernel. The problem also exists
> > > > with the latest snap 2.6.24-rc4-git4. NFS server is 2.6.23-rc9 and
> > > > is unchanged.
> > >
> > > hm, there have been no nfs changes since 2.6.24-rc4.
> > 
> > Ok, but the problem seems to have appeared before 2.6.24-rc4.
> > 
> > > > It is easily reproducible here, hopefully for the person who
> > > > knows how to debug it too :)
> > > >
> > >
> > > I guess a full set of the commands which you typed to reproduce this would
> > > help.
> > 
> > Server is 2.6.23-rc9 and is exporting:
> > 
> > /dirA/dirB
> > 10.10.20.0/255.255.255.0(rw,async,no_root_squash,no_subtree_check,insecure,crossmnt)
> > /dirA/dirB/dirC
> > 10.10.20.0/255.255.255.0(rw,async,no_root_squash,no_subtree_check,insecure)
> > /dirA/dirB/dirD
> > 10.10.20.0/255.255.255.0(rw,async,no_root_squash,no_subtree_check,insecure)
> > 
> > The NFS client (Core2 SMP) 2.6.24-rc3-git4:
> > 
> > NFS-server:/dirA/dirB     /dirA/dirB    nfs
> > auto,rsize=16384,wsize=16384,hard,intr,users,exec,nfsvers=3,tcp,nolock,actimeo=0
> > 
> > Then on the client when the new kernel has booted:
> > 
> > ls /dirA/dirB      --> normal listing
> > ls /dirA/dirB/dirC   -->  Stale NFS file handle
> > ls /dirA/dirB/dirD   -->  Stale NFS file handle
> > 
> > I will do a few more builds/boots and check -rc3-git2 and -rc3-git3.
> 
> This problem has already been reported. The fix (which I'm planning on
> sending to Linus soon) is appended.
> 

That patch isn't in git://git.linux-nfs.org/pub/linux/nfs-2.6.git.  In fact
that tree is empty.

Has something gone wrong here?
