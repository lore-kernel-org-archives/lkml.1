Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbXI1OOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbXI1OOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbXI1OOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:14:00 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:42314 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755242AbXI1ON7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:13:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=OK0i4ixBOt1q3P71VG+OV/riC7KE6Nc441OynrsJqHyzjpmn94ZXSLCDyrvjgSSQMekrbcEeWxgSke0laDVcmSXU9J4/I7bDGAjjDDsJFZhgYTWa7DcI+P6XmLARZ0E2ubMFuKZTU4xO/gwNFjZE+vedQ6gZRyl2sI6clLPOKEU=  ;
X-YMail-OSG: 0X.C4IcVM1mNoslz5pSJLO4zsvY.uws392fQ9QpynS0tYlfmWkM0xlR7Entqk3TUTDdjP8wLYw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Date: Fri, 28 Sep 2007 07:42:37 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
References: <20070919033605.785839297@sgi.com> <20070919033643.763818012@sgi.com>
In-Reply-To: <20070919033643.763818012@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200709280742.38262.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 13:36, Christoph Lameter wrote:
> SLAB_VFALLBACK can be specified for selected slab caches. If fallback is
> available then the conservative settings for higher order allocations are
> overridden. We then request an order that can accomodate at mininum
> 100 objects. The size of an individual slab allocation is allowed to reach
> up to 256k (order 6 on i386, order 4 on IA64).

How come SLUB wants such a big amount of objects? I thought the
unqueued nature of it made it better than slab because it minimised
the amount of cache hot memory lying around in slabs...

vmalloc is incredibly slow and unscalable at the moment. I'm still working
on making it more scalable and faster -- hopefully to a point where it would
actually be usable for this... but you still get moved off large TLBs, and
also have to inevitably do tlb flushing.

Or do you have SLUB at a point where performance is comparable to SLAB,
and this is just a possible idea for more performance?
