Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbXIUON4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbXIUON4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758322AbXIUONq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:13:46 -0400
Received: from mx2.netapp.com ([216.240.18.37]:64570 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211AbXIUONp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:13:45 -0400
X-IronPort-AV: E=Sophos;i="4.20,284,1186383600"; 
   d="scan'208";a="106402600"
Subject: Re: [NFS] NFS on loopback locks up entire system(2.6.23-rc6)?
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Chakri n <chakriin5@gmail.com>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <92cbf19b0709202012s375c6f54m588987b4bbf552bc@mail.gmail.com>
References: <92cbf19b0709201722k6265e647x31b7d25bc54b63a0@mail.gmail.com>
	 <1190335423.6763.180.camel@heimdal.trondhjem.org>
	 <92cbf19b0709202012s375c6f54m588987b4bbf552bc@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Fri, 21 Sep 2007 10:13:25 -0400
Message-Id: <1190384005.6680.20.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 21 Sep 2007 14:13:27.0065 (UTC) FILETIME=[941E4890:01C7FC59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 20:12 -0700, Chakri n wrote:
> Thanks Trond, for clarifying this for me.
> 
> I have seen similar behavior when a remote NFS server is not
> available. Many processes wait end up waiting in nfs_release_page. So,
> what will happen if the remote server is not available,
> nfs_release_page cannot free the memory since it waits on rpc request
> to complete, which never completes and processes wait in there for
> ever?
> 
> And unfortunately in my case, I cannot use "mount --bind". I want to
> use the same file system from two different nodes, and I want file &
> record locking to be consistent. The only way to make sure locking is
> consistent is to use loopback NFS on 1 host and NFS mount the same
> file system on other nodes, so that NFS server ensures file & record
> locking to be consistent. Is there any alternative to this?
> 
> Is it possible or any efforts to integrate ext3 or other local file
> systems locking & network file system locking, so that user can use
> "mount --bind" on local host and NFS mount on remote nodes, but file &
> record locking will be consistent between both the nodes?

Could you be a bit more specific? Is the problem that your application
is using BSD locks (flock()) instead of POSIX locks?

Cheers
   Trond
