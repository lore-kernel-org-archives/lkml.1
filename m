Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbXHLG6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbXHLG6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 02:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXHLG6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 02:58:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49700 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXHLG6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 02:58:08 -0400
Date: Sun, 12 Aug 2007 07:58:06 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: cciss: warning: right shift count >= width of type
Message-ID: <20070812065806.GC21089@ftp.linux.org.uk>
References: <200708120228.26234.jesper.juhl@gmail.com> <46BE60B5.7010708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BE60B5.7010708@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 03:21:57AM +0200, Rene Herman wrote:
> @@ -2609,13 +2609,13 @@ static void do_cciss_request(request_queue_t *q)
>  		} else {
>  			c->Request.CDBLen = 16;
>  			c->Request.CDB[1]= 0;
> -			c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
> -			c->Request.CDB[3]= (start_blk >> 48) & 0xff;
> -			c->Request.CDB[4]= (start_blk >> 40) & 0xff;
> -			c->Request.CDB[5]= (start_blk >> 32) & 0xff;
> -			c->Request.CDB[6]= (start_blk >> 24) & 0xff;
> -			c->Request.CDB[7]= (start_blk >> 16) & 0xff;
> -			c->Request.CDB[8]= (start_blk >>  8) & 0xff;
> +			c->Request.CDB[2]= ((u64)start_blk >> 56) & 0xff;	//MSB
> +			c->Request.CDB[3]= ((u64)start_blk >> 48) & 0xff;
> +			c->Request.CDB[4]= ((u64)start_blk >> 40) & 0xff;
> +			c->Request.CDB[5]= ((u64)start_blk >> 32) & 0xff;
> +			c->Request.CDB[6]= ((u64)start_blk >> 24) & 0xff;
> +			c->Request.CDB[7]= ((u64)start_blk >> 16) & 0xff;
> +			c->Request.CDB[8]= ((u64)start_blk >>  8) & 0xff;

	put_unaligned(cpu_to_be64(start_blk), &c->Request.CDB[2]);

which is what's happening here anyway.
