Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYE0NcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYE0NcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757416AbYE0NcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:32:11 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5920 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137AbYE0NcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:32:10 -0400
Date: Tue, 27 May 2008 15:32:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-btrace@vger.kernel.org
Subject: Re: [PATCH 1/2] Added in MESSAGE notes for blktraces
Message-ID: <20080527133206.GU7712@kernel.dk>
References: <483C0216.70008@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483C0216.70008@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27 2008, Alan D. Brunelle wrote:
> +#define blk_add_trace_msg(q, fmt, ...)					\
> +	do {								\
> +		struct blk_trace *bt = (q)->blk_trace;			\
> +		if (unlikely(bt))					\
> +			__trace_note_message(bt, fmt, ##__VA_ARGS__);	\
> +	} while (0)
> +#define BLK_TN_MAX_MSG		1024

BTW, I think we need to make this a lot smaller. Something like 128
chars should be enough, I think. 1K is just too much stack size to use
here.

-- 
Jens Axboe

