Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbXI1TVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbXI1TVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXI1TVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:21:07 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:43135 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750921AbXI1TVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:21:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=hWCRFMVsrfb1uiuIB1WId6wfo3jniCLD6gV4/xvelIgEwQYKPb/6ReZ78yiqBlzjvA4J+EdH0KdYJcAXdwihBUGgKwjPPEW2S0YcbNK4ucvGeGprjXcPecRjzGGpjfhm328tFsAH7/h9Tjr0Gwl1cJX84ObI6iGTrpcbXImBGfw=  ;
X-YMail-OSG: hNfPk9wVM1lAQ3mn2pKG_wPJjTStLptWEejnt0W6ImCQPMB0B4JvhGDMZuLQ4zbpHwHYEzsOeUWvajbMo.iAsclqboC3ReMg.7npCItVtBSXvB6JJeA-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Chinner <dgc@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Fri, 28 Sep 2007 12:46:29 +1000
User-Agent: KMail/1.9.5
Cc: Andrea Arcangeli <andrea@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nathan Scott <nscott@aconex.com>, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <200709161853.12050.nickpiggin@yahoo.com.au> <20070919140430.GJ4608@v2.random> <20070920013821.GR995458@sgi.com>
In-Reply-To: <20070920013821.GR995458@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709281246.30539.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 11:38, David Chinner wrote:
> On Wed, Sep 19, 2007 at 04:04:30PM +0200, Andrea Arcangeli wrote:

> > Plus of course you don't like fsblock because it requires work to
> > adapt a fs to it, I can't argue about that.
>
> No, I don't like fsblock because it is inherently a "struture
> per filesystem block" construct, just like buggerheads. You
> still need to allocate millions of them when you have millions
> dirty pages around. Rather than type it all out again, read
> the fsblocks thread from here:

I don't think there is anything inherently wrong with a structure
per filesystem block construct. In the places where you want to
have a handle on that information.

In the data path of a lot of filesystems, it's not really useful, no
question.

But the block / buffer head concept is there and is useful for many
things obviously. fsblock, I believe, improves on it; maybe even to
the point where there won't be too much reason for many
filesystems to convert their data paths to something different (eg.
nobh mode, or an extent block mapping).


> http://marc.info/?l=linux-fsdevel&m=118284983925719&w=2
>
> FWIW, with Chris mason's extent-based block mapping (which btrfs
> is using and Christoph Hellwig is porting XFS over to) we completely
> remove buggerheads from XFS and so fsblock would be a pretty
> major step backwards for us if Chris's work goes into mainline.

If you don't need to manipulate or manage the pagecache on a
per-block basis anyway, then you shouldn't need fsblock (or anything
else particularly special) to do higher order block sizes.

If you do sometimes need to, then fsblock *may* be a way you can
remove vmap code from your filesystem and share it with generic
code...


> But, I'm not going to argue endlessly for one solution or another;
> I'm happy to see different solutions being chased, so may the
> best VM win ;)

Agreed :)

