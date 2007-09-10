Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbXIJIDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbXIJIDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 04:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbXIJIDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 04:03:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754901AbXIJIDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 04:03:20 -0400
Date: Mon, 10 Sep 2007 01:03:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PTR_ALIGN
Message-Id: <20070910010318.971bcfff.akpm@linux-foundation.org>
In-Reply-To: <20070823114703.GQ9163@parisc-linux.org>
References: <20070823114703.GQ9163@parisc-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 05:47:03 -0600 Matthew Wilcox <matthew@wil.cx> wrote:

> 
> The AdvanSys driver wants to align some pointers, and the ALIGN macro
> doesn't work for pointers.  Rather than try to make it work, add a new
> PTR_ALIGN macro which is typesafe.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index f592df7..47160fe 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -34,6 +34,7 @@ extern const char linux_proc_banner[];
>  
>  #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
>  #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
> +#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
>  
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>  

I'll plan on getting this thing of beauty into mainline in the next week or
so, so you can get those advansys changes into James's tree.

