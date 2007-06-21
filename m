Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbXFUF0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbXFUF0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 01:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbXFUF0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 01:26:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58693 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbXFUF0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 01:26:30 -0400
Date: Wed, 20 Jun 2007 22:26:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Bob Picco <bob.picco@hp.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [31/37] Large blocksize support: Core piece
In-Reply-To: <20070621002013.GC10927@localhost>
Message-ID: <Pine.LNX.4.64.0706202225110.1579@schroedinger.engr.sgi.com>
References: <20070620182907.506775016@sgi.com> <20070620183013.224208780@sgi.com>
 <20070621002013.GC10927@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Bob Picco wrote:

> > +	if (size > (PAGE_SIZE << MAX_ORDER) || size < 512 ||
> > +						!is_power_of_2(size))
> I think this should be:
> 	if (size > (MAX_ORDER_NR_PAGES << PAGE_SHIFT) ... 
> 	or
> 	if (size > (PAGE_SIZE << (MAX_ORDER - 1)) ...
> bob
> >  		return -EINVAL;


Right.... MAX_ORDER is the first illegal order not the last usable.

