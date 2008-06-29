Return-Path: <linux-kernel-owner+w=401wt.eu-S1763577AbYF2Tpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763577AbYF2Tpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762972AbYF2Tji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:39:38 -0400
Received: from bu3sch.de ([62.75.166.246]:40661 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760913AbYF2Tjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:39:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Oops when using growisofs
Date: Sun, 29 Jun 2008 21:39:02 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200806221818.24372.mb@bu3sch.de> <200806262021.32140.mb@bu3sch.de> <20080626183610.GI20851@kernel.dk>
In-Reply-To: <20080626183610.GI20851@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806292139.02928.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008 20:36:11 Jens Axboe wrote:
> Something like this, totally untested...

> +	switch (capbuf.blocklen) {
> +	case 512:
> +	case 1024:
> +	case 2048:
> +	case 4096:
> +		break;
> +	default:
> +		printk(KERN_ERR "ide-cd: weird block size %u\n",
> +							capbuf.blocklen);
> +		printk(KERN_ERR "ide-cd: default to 2kb block size\n");
> +		capbuf.blocklen = 2048;
> +		break;
>  	}

So I applied this patch and it works fine.
However I cannot say if this fixed it. The warning does not appear, however,
it's probably possible that the drive does only return a wrong blocksize
under weird conditions (firmware bug).

So in any case, I think this patch should be applied. Checking device sanity
is always a good thing.

-- 
Greetings Michael.
