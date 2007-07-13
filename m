Return-Path: <linux-kernel-owner+w=401wt.eu-S933293AbXGMR3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbXGMR3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXGMR2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:28:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbXGMR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:28:54 -0400
Date: Fri, 13 Jul 2007 10:27:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Gabriel C <nix.or.die@googlemail.com>,
       linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: On current git head webservers stopped working
In-Reply-To: <20070713093459.GB5328@kernel.dk>
Message-ID: <alpine.LFD.0.999.0707131025550.20061@woody.linux-foundation.org>
References: <469745A8.6010005@googlemail.com>
 <20070713093459.GB5328@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Jul 2007, Jens Axboe wrote:
> 
> Does this work?

Ok, so it apparently works, but:

> diff --git a/fs/splice.c b/fs/splice.c
> index ed2ce99..92646aa 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -491,7 +491,7 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
>  
>  	ret = 0;
>  	spliced = 0;
> -	while (len) {
> +	while (len && !spliced) {
>  		ret = __generic_file_splice_read(in, ppos, pipe, len, flags);

This hunk basically make sthe whole "while" loop pointless. You'll never 
go through it more than once.

So at that point, maybe the loop should be removed entirely? Or maybe this 
part of the patch is wrong, and the fix was in the _other_ parts?

		Linus
