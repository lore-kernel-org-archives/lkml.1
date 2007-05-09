Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbXEIWxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbXEIWxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbXEIWxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:53:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755800AbXEIWxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:53:00 -0400
Date: Wed, 9 May 2007 15:52:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jeff Garzik <jeff@garzik.org>, Chuck Lever <chuck.lever@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NeilBrown <neilb@suse.de>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [bisect] NFS regression breaks X
Message-Id: <20070509155228.d1b9d644.akpm@linux-foundation.org>
In-Reply-To: <1178748206.6760.3.camel@heimdal.trondhjem.org>
References: <46423D62.2070200@garzik.org>
	<1178748206.6760.3.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 18:03:26 -0400
Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> On Wed, 2007-05-09 at 17:30 -0400, Jeff Garzik wrote:
> > Original bug report, with hardware and software info:
> > http://lkml.org/lkml/2007/5/8/667
> > 
> > I love bisect :)  bisect has identified the following commit as the one 
> > that causes my GNOME login to die, within 10 seconds of logging in:
> > 
> > 	commit 2bea90d43a050bbc4021d44e59beb34f384438db
> > 	Author: Chuck Lever <chuck.lever@oracle.com>
> > 	Date:   Thu Mar 29 16:47:53 2007 -0400
> > 
> > 	SUNRPC: RPC buffer size estimates are too large
> > 
> > 100% reproducible, verified regression.  My home directory is an NFSv4 
> > mount, and the problem appears on my client workstation, so this makes 
> > some sense:
> > > sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
> > > pretzel:/ on /g type nfs4 (rw,noatime,proto=tcp,addr=10.10.10.1)
> 
> Known issue.

It's a bit rough that Jeff spent a large amount of time hunting down an
already-known bug.  That's normally my job :(

This five-week-old diff only ever appeared in 2.6.21-mm1, which was
released four days ago.  It was then whizzed into mainline.  We thus lost
five weeks public testing which would probably have saved Jeff his pain.

What went wrong?
