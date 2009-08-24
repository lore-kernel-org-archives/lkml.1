Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZHXXSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZHXXSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZHXXSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:18:41 -0400
Received: from mx2.netapp.com ([216.240.18.37]:21764 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbZHXXSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:18:41 -0400
X-IronPort-AV: E=Sophos;i="4.44,267,1249282800"; 
   d="scan'208";a="230721875"
Subject: Re: [2.6.31-rc7] NFS4 client manager kthread spinning...
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220908241612g32cf4e61l3bc80c3f8c9d4037@mail.gmail.com>
References: <6278d2220908240818g3fc23311i607143b7cb6b965d@mail.gmail.com>
	 <1251134769.6325.273.camel@heimdal.trondhjem.org>
	 <6278d2220908241612g32cf4e61l3bc80c3f8c9d4037@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Mon, 24 Aug 2009 19:18:27 -0400
Message-Id: <1251155907.6325.359.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 24 Aug 2009 23:18:27.0933 (UTC) FILETIME=[2FC100D0:01CA2511]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 00:12 +0100, Daniel J Blueman wrote:
> Perhaps unrelated to the manager kthread, I reproduced a
> "nfs4_reclaim_open_state: Lock reclaim failed!" message ultimately -
> expected/significant?

It is not unexpected in a situation where you lose connection with the
server. Another client is then free step in and grab the lock.

We should probably be issuing a SIGLOST to the process and clear the
page cache in this situation. Currently, we cravenly write out the data
despite the fact that we're no longer holding a lock...

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
