Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXI3Urq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXI3Urq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 16:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXI3Urh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 16:47:37 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:40755 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751840AbXI3Urg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 16:47:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=EKV6ePXRiC8ka7czzoSliB1BoFm2cnLdCcQ0Ahg7lQMswX7FpuMrROGru4V1C08BIPk4vwm/UpZX1h85dp0pfQ45syrOcJVtsRu4JbRV5kIjJfu6OYJ6dPxE2xGAg64OtRDh/Onx2WF77M82Mm0WPF4nkm0zXKOZG2cY0KISnck=  ;
X-YMail-OSG: rof3SLQVM1kw5Pk_tx5YEEuZkU9jUVjwUTtOxrW2t44vACTtbBNtSSf4JpxEFVyv1Tm0Zap6RA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Date: Sun, 30 Sep 2007 14:16:09 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20070919033605.785839297@sgi.com> <200709300509.29278.nickpiggin@yahoo.com.au> <20070930131218.197e55b8.akpm@linux-foundation.org>
In-Reply-To: <20070930131218.197e55b8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709301416.10033.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2007 06:12, Andrew Morton wrote:
> On Sun, 30 Sep 2007 05:09:28 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Sunday 30 September 2007 05:20, Andrew Morton wrote:

> > > We can't "run out of unfragmented memory" for an order-2 GFP_KERNEL
> > > allocation in this workload.  We go and synchronously free stuff up to
> > > make it work.
> > >
> > > How did this get broken?
> >
> > Either no more order-2 pages could be freed, or the ones that were being
> > freed were being used by something else (eg. other order-2 slab
> > allocations).
>
> No.  The current design of reclaim (for better or for worse) is that for
> order 0,1,2 and 3 allocations we just keep on trying until it works.  That
> got broken and I think it got broken at a design level when that
> did_some_progress logic went in.  Perhaps something else we did later
> worsened things.

It will keep trying until it works. It won't have stopped trying (unless
I'm very mistaken?), it's just oom killing things merrily along the way.
