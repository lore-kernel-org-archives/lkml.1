Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbXISJl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbXISJl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbXISJlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:41:20 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:49350 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbXISJlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:41:18 -0400
Message-ID: <cac28cb80709190241m3fb1913ft64148071b54a1cb4@mail.gmail.com>
Date: Wed, 19 Sep 2007 13:41:17 +0400
From: "Alex Tomas" <alex@clusterfs.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nathan Scott" <nscott@aconex.com>, "Andrea Arcangeli" <andrea@suse.de>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Lameter" <clameter@sgi.com>, "Mel Gorman" <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Christoph Hellwig" <hch@lst.de>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Badari Pulavarty" <pbadari@gmail.com>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Fengguang Wu" <fengguang.wu@gmail.com>,
       "swin wang" <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com,
       joern@lazybastard.org
In-Reply-To: <20070919050910.GK995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070911060349.993975297@sgi.com>
	 <200709161853.12050.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
	 <200709181116.22573.nickpiggin@yahoo.com.au>
	 <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
	 <20070918191853.GB7541@v2.random>
	 <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
	 <1190163523.24970.378.camel@edge.yarra.acx>
	 <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org>
	 <20070919050910.GK995458@sgi.com>
X-SystemSpamProbe: GOOD 0.0001900 7b2d88e6b9dce5f7cc1a3fbd0afaec62
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, David Chinner <dgc@sgi.com> wrote:
> The problem is this: to alter the fundamental block size of the
> filesystem we also need to alter the data block size and that is
> exactly the piece that linux does not support right now.  So while
> we have the capability to use large block sizes in certain
> filesystems, we can't use that capability until the data path
> supports it.

it's much simpler to teach fs to understand multipage data (like
multipage bitmap scan, multipage extent search, etc) then deal with mm
fragmentation. IMHO. at same time you don't bust IO traffic with
non-used space.

-- 
thanks, Alex

