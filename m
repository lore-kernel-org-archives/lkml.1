Return-Path: <linux-kernel-owner+w=401wt.eu-S1761675AbXIUSOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675AbXIUSOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbXIUSOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:14:33 -0400
Received: from mx2.netapp.com ([216.240.18.37]:53493 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbXIUSOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:14:32 -0400
X-IronPort-AV: E=Sophos;i="4.20,284,1186383600"; 
   d="scan'208";a="106473313"
Subject: Re: [NFS] NFS on loopback locks up entire system(2.6.23-rc6)?
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Chakri n <chakriin5@gmail.com>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <92cbf19b0709211106n12b1b4ecxc0d415aa097d21b2@mail.gmail.com>
References: <92cbf19b0709201722k6265e647x31b7d25bc54b63a0@mail.gmail.com>
	 <1190335423.6763.180.camel@heimdal.trondhjem.org>
	 <92cbf19b0709202012s375c6f54m588987b4bbf552bc@mail.gmail.com>
	 <1190384005.6680.20.camel@heimdal.trondhjem.org>
	 <92cbf19b0709210920p3647788dl11d8c4e0cee1f70f@mail.gmail.com>
	 <1190391881.6680.73.camel@heimdal.trondhjem.org>
	 <92cbf19b0709211106n12b1b4ecxc0d415aa097d21b2@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Fri, 21 Sep 2007 14:14:13 -0400
Message-Id: <1190398453.6690.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 21 Sep 2007 18:14:15.0286 (UTC) FILETIME=[37EDD960:01C7FC7B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No. The requirement for 'hard' mounts is not that the server be up all
the time. The server can go up and down as it pleases: the client can
happily recover from that.

The requirement is rather that nobody remove it permanently before the
application is done with it, and the partition is unmounted. That is
hardly unreasonable (it is the only way I know of to ensure data
integrity), and it is much less strict than the requirements for local
disks.

Trond

On Fri, 2007-09-21 at 11:06 -0700, Chakri n wrote:
> Isn't this a strict requirement from client side, asking to guarantee
> that a server stays up all the time?
> 
> I have seen many cases, where people go and directly change IP of
> their NFS filers or servers worrying least about the clients using
> them.
> 
> Can we get around with some sort of congestion logic?
> 
> Thanks
> --Chakri
> 
> On 9/21/07, Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> > On Fri, 2007-09-21 at 09:20 -0700, Chakri n wrote:
> > > Thanks.
> > >
> > > I was using flock (BSD locking) and I think the problem should be
> > > solved if I move my application to use POSIX locks.
> >
> > Yup.
> >
> > > And any option to avoid processes waiting indefinitely to free pages
> > > from NFS requests waiting on unresponsive NFS server?
> >
> > The only solution I know of is to use soft mounts, but that brings
> > another set of problems:
> >      1. most applications don't know how to recover safely from an EIO
> >         error.
> >      2. You lose data.
> >
> > Cheers
> >   Trond
> >
