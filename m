Return-Path: <linux-kernel-owner+w=401wt.eu-S965360AbXCIHws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360AbXCIHws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965495AbXCIHws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:52:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43930 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965360AbXCIHwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:52:47 -0500
Date: Fri, 9 Mar 2007 07:52:45 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
Message-ID: <20070309075245.GD8798@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1173419792.32234.131.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173419792.32234.131.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 04:56:32PM +1100, Rusty Russell wrote:
> __builtin_types_compatible_p() has been around since gcc 2.95, and we
> don't use it anywhere.  This patch quietly fixes that.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r f0ff8138f993 include/linux/kernel.h
> --- a/include/linux/kernel.h	Fri Mar 09 16:40:25 2007 +1100
> +++ b/include/linux/kernel.h	Fri Mar 09 16:44:04 2007 +1100
> @@ -35,7 +35,9 @@ extern const char linux_proc_banner[];
>  #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
>  #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
>  
> -#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> +#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
> +	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
> +		 typeof(&arr[0]))]))*0)

This needs a comment explaning why we're doing this, and maybe a little
explanation of the combination of gcc magic and C trickery used to implement
it to the brave non-uberhacker people trying to understand linux headers.

