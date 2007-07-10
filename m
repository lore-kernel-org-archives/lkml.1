Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbXGJTkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbXGJTkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbXGJTkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:40:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:48049 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbXGJTki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mO3qoWU6VCxr9KVatpb9tUVERMDPY8YeNACflKXfD2wdM8OEOYDXdY4wb2c7BE5oAXUorJ318MoMuVPkG0OZ9UAUUVuCz7JhCiyBXVVFOJKVSjc7fny+rnINzkIGPH/iOr024WrahNKWmEDXbgDXUWw8C2p16Q1fI3RsKUMCJmE=
Date: Tue, 10 Jul 2007 23:40:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix sparse problems with ARRAY_SIZE
Message-ID: <20070710194033.GB5751@martell.zuzino.mipt.ru>
References: <4693AE32.7030403@gmail.com> <4693AF4C.8010005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4693AF4C.8010005@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 06:09:48PM +0200, Adel Gadllah wrote:
> --- linux-2.6.orig/include/linux/kernel.h
> +++ linux-2.6/include/linux/kernel.h
> @@ -35,7 +35,11 @@ extern const char linux_proc_banner[];
>  #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
>  #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
>  
> +#ifdef __CHECKER_
> +#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
> +#else
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> +#endif

Al Viro recently gave a hint that he have patches for sparse to not give
spurious ARRAY_SIZE warnings.

