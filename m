Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbZKSQgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbZKSQgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZKSQgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:36:13 -0500
Received: from mx2.netapp.com ([216.240.18.37]:60927 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZKSQgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:36:12 -0500
X-IronPort-AV: E=Sophos;i="4.44,771,1249282800"; 
   d="scan'208";a="277013077"
Subject: [GIT] Please pull NFS client bugfixes
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Thu, 19 Nov 2009 11:35:08 -0500
Message-Id: <1258648508.30333.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
X-OriginalArrivalTime: 19 Nov 2009 16:35:50.0420 (UTC) FILETIME=[5AB14D40:01CA6936]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the "bugfixes" branch of the repository at

   git pull git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git bugfixes

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 fs/nfs/nfs4proc.c |    2 +-
 net/sunrpc/addr.c |   18 ++++++++----------
 2 files changed, 9 insertions(+), 11 deletions(-)

commit 1e360a60b24ad8f8685af66fa6de10ce46693a4b
Author: Chuck Lever <chuck.lever@oracle.com>
Date:   Fri Nov 13 10:52:55 2009 -0500

    SUNRPC: Address buffer overrun in rpc_uaddr2sockaddr()
    
    The size of buf[] must account for the string termination needed for
    the first strict_strtoul() call.  Introduced in commit a02d6926.
    
    Fábio Olivé Leite points out that strict_strtoul() requires _either_
    '\n\0' _or_ '\0' termination, so use the simpler '\0' here instead.
    
    See http://bugzilla.kernel.org/show_bug.cgi?id=14546 .
    
    Reported-by: argp@census-labs.com
    Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
    Signed-off-by: Fábio Olivé Leite <fleite@redhat.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 96d25e532234bec1a1989e6e1baf702d43a78b0d
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Wed Nov 11 16:15:42 2009 +0900

    NFSv4: Fix a cache validation bug which causes getcwd() to return ENOENT
    
    Changeset a65318bf3afc93ce49227e849d213799b072c5fd (NFSv4: Simplify some
    cache consistency post-op GETATTRs) incorrectly changed the getattr
    bitmap for readdir().
    This causes the readdir() function to fail to return a
    fileid/inode number, which again exposed a bug in the NFS readdir code that
    causes spurious ENOENT errors to appear in applications (see
    http://bugzilla.kernel.org/show_bug.cgi?id=14541).
    
    The immediate band aid is to revert the incorrect bitmap change, but more
    long term, we should change the NFS readdir code to cope with the
    fact that NFSv4 servers are not required to support fileids/inode numbers.
    
    Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>


