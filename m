Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbXIMRnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbXIMRnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbXIMRna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:43:30 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:42067 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753176AbXIMRn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:43:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QusiLbK3Dk24btAMnd/OgsL21kMM8EqNNPw/4jJCPINxOXFdTHwFI2J4vA+zkUXVZZrpAuiGQoH/aVM2YNz2VssIi7kCSpCX0IvhPcyGjV+Fhqlc3KHgSDf8Mt3OMfKWIGBA//ZhbFxngzUQ1Qitz362KjJlaOtgrbvl7wXwhdg=  ;
X-YMail-OSG: mTGmbakVM1mtctFqpHhJA6D1XYGzVTbRPlBuTCAl5AZbl..f7ZT8m9.5F.ufkPQm1QTT9hylzA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Chinner <dgc@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Thu, 13 Sep 2007 12:01:45 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@skynet.ie>, Christoph Lameter <clameter@sgi.com>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709130323.22534.nickpiggin@yahoo.com.au> <20070913130342.GT734179@sgi.com>
In-Reply-To: <20070913130342.GT734179@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709131201.46720.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007 23:03, David Chinner wrote:
> On Thu, Sep 13, 2007 at 03:23:21AM +1000, Nick Piggin wrote:

> > Well, it may not be easy to _fix_, but it's easy to try a few
> > improvements ;)
> >
> > How do I make an image and run a workload that will coerce XFS into
> > doing a significant number of vmaps?
>
> # mkfs.xfs -n size=16384 <dev>
>
> to create a filesystem with a 16k directory block size on a 4k page
> machine.
>
> Then just do operations on directories with lots of files in them
> (tens of thousands). Every directory operation will require at
> least one vmap in this situation - e.g. a traversal will result in
> lots and lots of blocks being read that will require vmap() for every
> directory block read from disk and an unmap almost immediately
> afterwards when the reference is dropped....

Ah, wow, thanks: I can reproduce it.
