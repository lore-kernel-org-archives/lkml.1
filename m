Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYCOMuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYCOMuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 08:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYCOMuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 08:50:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4127 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751242AbYCOMuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 08:50:05 -0400
Date: Sat, 15 Mar 2008 13:49:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] disk-protect: Add a generic block layer queue freezing facility
Message-ID: <20080315124952.GC4669@ucw.cz>
References: <87skzgd1zk.fsf@denkblock.local> <20080226123946.75dbe3d2@core> <87mypl8p49.fsf@denkblock.local> <20080228111349.6831925c@core> <87bq5qfm2v.fsf@denkblock.local> <20080307181750.9981.1330.stgit@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307181750.9981.1330.stgit@denkblock.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-07 19:26:41, Elias Oltmanns wrote:
> This patch provides a generic way to freeze the request queue of a block
> device temporarily. This functionality is exposed to user space via sysfs.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

I guess this should have patch going to documentation. Otherwise it
looks ok.


> +/*
> + * When reading the 'protect' attribute, we return seconds remaining
> + * before the unfreeze timeout expires.
> + */
> +static ssize_t queue_protect_show(struct request_queue *q, char *page)
> +{
> +	unsigned int seconds = 0;
> +
> +	if (blk_queue_stopped(q) && timer_pending(&q->unfreeze_timer))
> +		/*
> +		 * Adding 1 in order to guarantee nonzero value until timer
> +		 * has actually expired.
> +		 */
> +		seconds = jiffies_to_msecs(q->unfreeze_timer.expires
> +					   - jiffies) / 1000 + 1;

Is it okay to read expires without locking? 
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
