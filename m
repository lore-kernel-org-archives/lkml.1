Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZHTNIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZHTNIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZHTNIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:08:44 -0400
Received: from mx2.netapp.com ([216.240.18.37]:54415 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbZHTNIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:08:43 -0400
X-IronPort-AV: E=Sophos;i="4.43,414,1246863600"; 
   d="scan'208";a="228093407"
Subject: Re: [PATCH 1/3] direct-io: make O_DIRECT IO path be page based
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, zach.brown@oracle.com
In-Reply-To: <20090817121137.GW12579@kernel.dk>
References: <1250505274-17108-1-git-send-email-jens.axboe@oracle.com>
	 <1250505274-17108-2-git-send-email-jens.axboe@oracle.com>
	 <20090817121137.GW12579@kernel.dk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Thu, 20 Aug 2009 09:08:13 -0400
Message-Id: <1250773693.5352.24.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 20 Aug 2009 13:08:45.0077 (UTC) FILETIME=[59052C50:01CA2197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 14:11 +0200, Jens Axboe wrote:
> On Mon, Aug 17 2009, Jens Axboe wrote:
> > Switch the aops->direct_IO() and below code to use page arrays
> > instead, so that it doesn't make any assumptions about who the pages
> > belong to. This works directly for all users but NFS, which just
> > uses the same helper that the generic mapping read/write functions
> > also call.
> 
> A quick NFS test reveals a simple problem - it wants to free the
> pagevec on IO completion, but for O_DIRECT it should not do that anymore
> since it'll simply inherit the given page map.
> 
> There's a flag structure in the nfs_{read,write}_data structure, but I
> was not able to find out which flags (if any?!) it actually uses. So I
> just stuck an int in there. Trond?

Why not just have O_DIRECT reset the pagevec before freeing the
structure?

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
