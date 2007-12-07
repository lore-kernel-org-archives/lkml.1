Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbXLGSOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbXLGSOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXLGSOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:14:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:43776 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbXLGSOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:14:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rKIC3OpIzw7GPZQnI4rI3z0XG7XwnfOjOeAcestzmaCE2nrAuFL7+WCNQDZHeoK01kR2hh7UB31SXxM/Cei4s1vMBFY3Dfah0fMEVlzKpQMTaDcRQDspWeCwg5ASEAwHJI8GJiKxK806AF/4vlT0I70vKVEcW1xvSrbxmu8+GvE=
Message-ID: <fa4052ef0712071014l524951e2we4705d84c5005cf3@mail.gmail.com>
Date: Fri, 7 Dec 2007 13:14:34 -0500
From: Shane <gnome42@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Cc: linux-kernel@vger.kernel.org,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20071207040219.e231cbc7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	 <20071207040219.e231cbc7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 7:02 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
...
> > 2.6.24-rc3-git1 is last known good kernel. The problem also exists
> > with the latest snap 2.6.24-rc4-git4. NFS server is 2.6.23-rc9 and
> > is unchanged.
>
> hm, there have been no nfs changes since 2.6.24-rc4.

Ok, but the problem seems to have appeared before 2.6.24-rc4.

> > It is easily reproducible here, hopefully for the person who
> > knows how to debug it too :)
> >
>
> I guess a full set of the commands which you typed to reproduce this would
> help.

Server is 2.6.23-rc9 and is exporting:

/dirA/dirB
10.10.20.0/255.255.255.0(rw,async,no_root_squash,no_subtree_check,insecure,crossmnt)
/dirA/dirB/dirC
10.10.20.0/255.255.255.0(rw,async,no_root_squash,no_subtree_check,insecure)
/dirA/dirB/dirD
10.10.20.0/255.255.255.0(rw,async,no_root_squash,no_subtree_check,insecure)

The NFS client (Core2 SMP) 2.6.24-rc3-git4:

NFS-server:/dirA/dirB     /dirA/dirB    nfs
auto,rsize=16384,wsize=16384,hard,intr,users,exec,nfsvers=3,tcp,nolock,actimeo=0

Then on the client when the new kernel has booted:

ls /dirA/dirB      --> normal listing
ls /dirA/dirB/dirC   -->  Stale NFS file handle
ls /dirA/dirB/dirD   -->  Stale NFS file handle

I will do a few more builds/boots and check -rc3-git2 and -rc3-git3.

Will report back shortly,

Shane
