Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbXE1OmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbXE1OmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 10:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXE1OmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 10:42:13 -0400
Received: from mail.tmr.com ([64.65.253.246]:48949 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbXE1OmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 10:42:12 -0400
Message-ID: <465AEAA5.7000407@tmr.com>
Date: Mon, 28 May 2007 10:43:49 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
References: <18006.38689.818186.221707@notabene.brown>
In-Reply-To: <18006.38689.818186.221707@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> We can think of there being three types of devices:
>  
> 1/ SAFE.  With a SAFE device, there is no write-behind cache, or if
>           there is it is non-volatile.  Once a write completes it is 
>           completely safe.  Such a device does not require barriers
>           or ->issue_flush_fn, and can respond to them either by a
> 	  no-op or with -EOPNOTSUPP (the former is preferred).
>
> 2/ FLUSHABLE.
>           A FLUSHABLE device may have a volatile write-behind cache.
>           This cache can be flushed with a call to blkdev_issue_flush.
> 	  It may not support barrier requests.
>
> 3/ BARRIER.
> 	  A BARRIER device supports both blkdev_issue_flush and
>           BIO_RW_BARRIER.  Either may be used to synchronise any
> 	  write-behind cache to non-volatile storage (media).
>
> Handling of SAFE and FLUSHABLE devices is essentially the same and can
> work on a BARRIER device.  The BARRIER device has the option of more
> efficient handling.
>   
There are two things I'm not sure you covered.

First, disks which don't support flush but do have a "cache dirty" 
status bit you can poll at times like shutdown. If there are no drivers 
which support these, it can be ignored.

Second, NAS (including nbd?). Is there enough information to handle this 
"really rigt?"

Otherwise looks good as a statement of issues. It seems to me that the 
filesystem should be able to pass the barrier request to the block layer 
and have it taken care of, rather than have code in each f/s to cope 
with odd behavior.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

