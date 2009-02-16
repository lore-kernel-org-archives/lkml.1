Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZBPXLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZBPXLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZBPXLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:11:05 -0500
Received: from ozlabs.org ([203.10.76.45]:47854 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZBPXLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:11:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH] bitmap: Cleanup find_last_bit
Date: Tue, 17 Feb 2009 09:40:59 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200812011848.31552.rusty@rustcorp.com.au> <1234789120-31543-1-git-send-email-bhalevy@panasas.com>
In-Reply-To: <1234789120-31543-1-git-send-email-bhalevy@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170940.59703.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009 23:28:40 Benny Halevy wrote:
> Fix cut & paste error in header comment.
> Simplify implementation a bit.

Hi Benny,

  Nice catch!  But I disagree with one change:

>  	/* Partial final word? */
> -	if (size & (BITS_PER_LONG-1)) {
> -		tmp = (addr[words] & (~0UL >> (BITS_PER_LONG
> -					 - (size & (BITS_PER_LONG-1)))));
> +	tmp = size & (BITS_PER_LONG-1);
> +	if (tmp) {
> +		tmp = addr[words] & (~0UL >> (BITS_PER_LONG - tmp));
>  		if (tmp)
>  			goto found;
>  	}

The overloading of tmp to the remainder size here is not really a cleanup: it
makes it into a dual-use var.  I know it's called tmp, but that's a sign of
poor code too :)

I'd prefer a new final_bits var: gcc will almost certainly just slap it in
a register anyway, but it's clearer.

tmp could then be called something like... word?

Thanks!
Rusty.
