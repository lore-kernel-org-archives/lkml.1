Return-Path: <linux-kernel-owner+w=401wt.eu-S933215AbXDZIOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbXDZIOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbXDZIOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:14:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45508 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933215AbXDZIOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:14:37 -0400
Date: Thu, 26 Apr 2007 18:14:11 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [10/17] Variable Order Page Cache: Add clearing and flushing function
Message-ID: <20070426081411.GS65285596@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070424222306.764423792@sgi.com> <Pine.LNX.4.64.0704260001540.30701@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704260001540.30701@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 12:02:31AM -0700, Christoph Lameter wrote:
> On Tue, 24 Apr 2007, clameter@sgi.com wrote:
> 
> > +{									\
> > +	memset(page_address(__page), (__offset), (__size));		\
> > +	flush_mapping_page(__page);					\
> 
> This was borked. Dave does this patch make it work?
> 
> ---
>  include/linux/highmem.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.21-rc7/include/linux/highmem.h
> ===================================================================
> --- linux-2.6.21-rc7.orig/include/linux/highmem.h	2007-04-25 23:59:33.000000000 -0700
> +++ linux-2.6.21-rc7/include/linux/highmem.h	2007-04-26 00:00:05.000000000 -0700
> @@ -88,7 +88,7 @@ static inline void clear_highpage(struct
>   */
>  #define memclear_highpage_flush(__page,__offset,__size) \
>  {									\
> -	memset(page_address(__page), (__offset), (__size));		\
> +	memset(page_address(__page) + (__offset), 0, (__size));		\
>  	flush_mapping_page(__page);					\
>  }
>  #else

Yes, works for me.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
