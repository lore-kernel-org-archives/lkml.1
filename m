Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYGBRP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYGBRP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 13:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYGBRPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 13:15:15 -0400
Received: from mx2.netapp.com ([216.240.18.37]:43187 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYGBRPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 13:15:13 -0400
X-IronPort-AV: E=Sophos;i="4.27,738,1204531200"; 
   d="scan'208";a="4660050"
Subject: Re: inux-next: Tree for July 1
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: chucklever@gmail.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, kernel-testers@vger.kernel.org,
       linux-nfs@vger.kernel.org
In-Reply-To: <76bd70e30807020734g3db408dcqea2a61622c83004d@mail.gmail.com>
References: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
	 <200807012236.19400.rjw@sisk.pl> <1214959743.10317.3.camel@localhost>
	 <76bd70e30807020734g3db408dcqea2a61622c83004d@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Wed, 02 Jul 2008 13:15:11 -0400
Message-Id: <1215018911.9783.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 02 Jul 2008 17:15:12.0330 (UTC) FILETIME=[2FE46AA0:01C8DC67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 10:34 -0400, Chuck Lever wrote:
> On Tue, Jul 1, 2008 at 8:49 PM, Trond Myklebust
> <Trond.Myklebust@netapp.com> wrote:
> > On Tue, 2008-07-01 at 22:36 +0200, Rafael J. Wysocki wrote:
> >> I can't mount NFS shares with this kernel.  I get something of this sort in
> >> dmesg and it seems to be 100% reproducible:
> >>
> >> [  314.058858] RPC: Registered udp transport module.
> >> [  314.058863] RPC: Registered tcp transport module.
> >> [  314.490970] RPC: transport (0) not supported
> >> [  319.246987] __ratelimit: 23 messages suppressed
> >
> > Does this patch fix the problem for you?
> > -----------------------------------------------------------------------------------
> > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > NFS: Fix the mount protocol defaults for binary mounts
> >
> > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > ---
> >
> >  fs/nfs/super.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> > index e09b1c2..85fbb98 100644
> > --- a/fs/nfs/super.c
> > +++ b/fs/nfs/super.c
> > @@ -1575,6 +1575,7 @@ static int nfs_validate_mount_data(void *options,
> >
> >                if (!(data->flags & NFS_MOUNT_TCP))
> >                        args->nfs_server.protocol = XPRT_TRANSPORT_UDP;
> > +               nfs_set_transport_defaults(args);
> 
> nfs_set_transport_defaults() is overkill for the legacy mount path.
> The bug is that the logic here assumes that nfs_server.protocol
> already has the default value of XPRT_TRANSPORT_TCP, but commit
> 8b59ea3c removed that default.  The correct fix is to add
> 
>             args->nfs_server.protocol = XPRT_TRANSPORT_TCP;
> 
> just before the 'if' statement.  We should fold that into 8b59ea3c to
> preserve bisectability.

NACK. You still need to set the appropriate retrans and timeo defaults.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
