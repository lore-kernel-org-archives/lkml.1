Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbZJEK44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbZJEK44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932611AbZJEK4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:56:55 -0400
Received: from mx2.netapp.com ([216.240.18.37]:51546 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596AbZJEK4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:56:54 -0400
X-IronPort-AV: E=Sophos;i="4.44,505,1249282800"; 
   d="scan'208";a="253526380"
References: <20091004030153.GA20327@localhost> <20091005071026.GA19262@localhost> <20091005073551.GA23102@localhost> <20091005073959.GA23398@localhost>
Message-ID: <F047DA72-75B3-4447-84EB-7115C77ECBA3@netapp.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Wu Fengguang" <fengguang.wu@intel.com>
Thread-Topic: [PATCH v2] NFS: introduce writeback wait queue
Thread-Index: AcpFqm0rrfkrkClgTnS5daP+Rc5a2w==
In-Reply-To: <20091005073959.GA23398@localhost>
Content-Type: text/plain;
	format=flowed;
	delsp=yes;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [PATCH v2] NFS: introduce writeback wait queue
Date: Mon, 5 Oct 2009 06:55:54 -0400
Cc: <jens.axboe@oracle.com>, "Chris Mason" <chris.mason@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-fsdevel@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-nfs@vger.kernel.org>
X-OriginalArrivalTime: 05 Oct 2009 10:56:02.0265 (UTC) FILETIME=[6DD0FC90:01CA45AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 5, 2009, at 3:40, "Wu Fengguang" <fengguang.wu@intel.com> wrote:

> On Mon, Oct 05, 2009 at 03:35:51PM +0800, Wu Fengguang wrote:
>> Trond, I see this trace on linux-next. There are no more dirty pages
>> when `cp' aborts after filling up the partition:
>>
>>        cp: writing `/mnt/test/zero3': No space left on device
>>
>> I noticed that since then nr_writeback is decreased very slowly
>> (~100 pages per second). Looks like an interesting behavior.
>
> In the mean time, there are constant 7-8MB/s writes in the NFS server.
> The network flow is much smaller ~400K/s. How can I debug this issue?

Hi Fengguang

This is deliberate behaviour. When asynchronous writes start recieving  
errors, then we switch to synchronous write mode until the error  
condition clears.

The reason is for doing so is firstly because some filesystems (XFS)  
perform very poorly under ENOSPC, and so it takes forever to write  
back pages (we don't want to cancel all writebacks for temporary  
conditions like ENOSPC). It also allows us to deliver the errors more  
promptly to the application.

Cheers
      Trond

>
