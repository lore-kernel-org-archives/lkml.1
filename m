Return-Path: <linux-kernel-owner+w=401wt.eu-S1765061AbXHYALa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765061AbXHYALa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbXHYALV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:11:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592AbXHYALU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:11:20 -0400
Date: Fri, 24 Aug 2007 17:10:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.linux.org, hch@infradead.org,
       james.bottomley@steeleye.com
Subject: Re: [PATCH 1/1] cciss: fix error reporting for SG_IO
Message-Id: <20070824171047.77cf7adc.akpm@linux-foundation.org>
In-Reply-To: <20070824175354.GA14125@beardog.cca.cpqcorp.net>
References: <20070824175354.GA14125@beardog.cca.cpqcorp.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 12:53:54 -0500
"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:

> This fixes a problem with the way cciss was filling out the "errors"
> field of the request structure upon completion of requests. 
> Previously, it just put a 1 or a 0 in there and used the negation
> of this as the uptodate parameter to one of the functions in the
> block layer, being a block device.  For the SG_IO ioctl, this was not
> sufficient, and we noticed that, for example, sg_turs from sg3_utils 
> did not correctly detect problems due to cciss having set rq->errors 
> incorrectly.

Do we think this problem is sufficiently serious to merit merging
this (largeish) patch into 2.6.23?

I'm thinking "no", but that might be wrong...
