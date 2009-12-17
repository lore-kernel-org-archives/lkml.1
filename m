Return-Path: <linux-kernel-owner+w=401wt.eu-S1764243AbZLQJgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764243AbZLQJgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764227AbZLQJgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:36:16 -0500
Received: from verein.lst.de ([213.95.11.210]:50300 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764214AbZLQJgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:36:13 -0500
Date: Thu, 17 Dec 2009 10:35:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jeff Moyer <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Alex Elder <aelder@sgi.com>, Mark Fasheh <mfasheh@suse.com>,
       Joel Becker <joel.becker@oracle.com>
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091217093524.GA13739@lst.de>
References: <20091217090250.GA4844@elte.hu> <20091217093216.GZ14381@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217093216.GZ14381@ZenIV.linux.org.uk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:32:16AM +0000, Al Viro wrote:
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 4012885..e82adc2 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -1206,7 +1206,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  	 * NOTE: filesystems with their own locking have to handle this
>  	 * on their own.
>  	 */
> -	if (dio->flags & DIO_LOCKING) {
> +	if (flags & DIO_LOCKING) {
>  		if (unlikely((rw & WRITE) && retval < 0)) {
>  			loff_t isize = i_size_read(inode);
>  			if (end > isize)

Hmm, yes that should fix it.  Dio is freed at that point.
