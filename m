Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbYACOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbYACOqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYACOqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:46:06 -0500
Received: from mx2.netapp.com ([216.240.18.37]:29418 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYACOqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:46:04 -0500
X-IronPort-AV: E=Sophos;i="4.24,239,1196668800"; 
   d="scan'208";a="139611074"
Subject: Re: [GIT] More NFS client fixes for 2.6.24-rc6
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
In-Reply-To: <20080103093048.GA16803@elte.hu>
References: <1199329417.28241.3.camel@heimdal.trondhjem.org>
	 <20080103093048.GA16803@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 03 Jan 2008 09:45:57 -0500
Message-Id: <1199371557.7357.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 03 Jan 2008 14:45:58.0492 (UTC) FILETIME=[5A3869C0:01C84E17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 10:30 +0100, Ingo Molnar wrote:
> * Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> 
> > commit 53478daff2c8b494d2af1ede6611f166f81bc393
> > Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Date:   Wed Jan 2 13:28:57 2008 -0500
> > 
> >     NFS: Fix a possible Oops in fs/nfs/super.c
> >     
> >     Sigh... commit 4584f520e1f773082ef44ff4f8969a5d992b16ec (NFS: Fix NFS
> >     mountpoint crossing...) had a slight flaw: server can be NULL if sget()
> >     returned an existing superblock.
> >     
> >     Fix the fix by dereferencing s->s_fs_info.
> >     
> >     Also add in the same namespace Oops fix for NFSv4 in both the mountpoint
> >     crossing case, and the referral case.
> >     
> >     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> shouldnt this commit have included the full credit of the bugfix:
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=9647
> 
>   ------------>
>   Description From Adrian Bunk 2007-12-27 12:36
> 
>   The Coverity checker spotted that commit
>   4584f520e1f773082ef44ff4f8969a5d992b16ec introduced the following NULL
>   dereference in 2.6.24-rc6:

Point taken, however I assume that a reference to the bugzilla report
should suffice. I've therefore updated the commit changelog to read as
follows:

    NFS: Fix a possible Oops in fs/nfs/super.c
    
    Sigh... commit 4584f520e1f773082ef44ff4f8969a5d992b16ec (NFS: Fix NFS
    mountpoint crossing...) had a slight flaw: server can be NULL if sget()
    returned an existing superblock.
    
    Fix the fix by dereferencing s->s_fs_info.
    
    Thanks to Coverity/Adrian Bunk and Frank Filz for spotting the bug.
    (See http://bugzilla.kernel.org/show_bug.cgi?id=9647)
    
    Also add in the same namespace Oops fix for NFSv4 in both the mountpoint
    crossing case, and the referral case.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Cheers
  Trond
