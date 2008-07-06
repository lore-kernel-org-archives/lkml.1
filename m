Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbYGFEQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbYGFEQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 00:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYGFEQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 00:16:14 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38018 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbYGFEQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 00:16:13 -0400
Date: Sun, 6 Jul 2008 00:15:02 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH] fix potential latency issues in JBD's journal code
Message-ID: <20080706041502.GB21990@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <20080704192929.2c4dd4ca@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704192929.2c4dd4ca@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 07:29:29PM -0700, Arjan van de Ven wrote:
> @@ -165,7 +165,7 @@ static void journal_do_submit_data(struct buffer_head **wbuf, int bufs)
>  	for (i = 0; i < bufs; i++) {
>  		wbuf[i]->b_end_io = end_buffer_write_sync;
>  		/* We use-up our safety reference in submit_bh() */
> -		submit_bh(WRITE, wbuf[i]);
> +		submit_bh(WRITE_SYNC, wbuf[i]);
>  	}
>  }

So I started looking at this patch more closely when trying to
replicate it for ext4.  Don't you want to only use WRITE_SYNC() only
for the very last time in the loop?  Otherwise you end up unplugging
the queue after each bufferhead, which wouldn't be a good thing, right?

    	  	     		       		- Ted
