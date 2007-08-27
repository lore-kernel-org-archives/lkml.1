Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbXH0UAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbXH0UAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbXH0T7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:59:55 -0400
Received: from palrel11.hp.com ([156.153.255.246]:56005 "EHLO palrel11.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757783AbXH0T7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:59:54 -0400
Date: Mon, 27 Aug 2007 14:58:51 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.linux.org, hch@infradead.org,
       james.bottomley@steeleye.com
Subject: Re: [PATCH 1/1] cciss: fix error reporting for SG_IO
Message-ID: <20070827195851.GA25572@beardog.cca.cpqcorp.net>
References: <20070824175354.GA14125@beardog.cca.cpqcorp.net> <20070824171047.77cf7adc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824171047.77cf7adc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 05:10:47PM -0700, Andrew Morton wrote:
> On Fri, 24 Aug 2007 12:53:54 -0500
> "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> 
> > This fixes a problem with the way cciss was filling out the "errors"
> > field of the request structure upon completion of requests. 
> > Previously, it just put a 1 or a 0 in there and used the negation
> > of this as the uptodate parameter to one of the functions in the
> > block layer, being a block device.  For the SG_IO ioctl, this was not
> > sufficient, and we noticed that, for example, sg_turs from sg3_utils 
> > did not correctly detect problems due to cciss having set rq->errors 
> > incorrectly.
> 
> Do we think this problem is sufficiently serious to merit merging
> this (largeish) patch into 2.6.23?
> 
> I'm thinking "no", but that might be wrong...

We'd like to see it 2.6.23. It may help insulate me from lots of questions
about where it is. :) But it's entirely up to you.

mikem
