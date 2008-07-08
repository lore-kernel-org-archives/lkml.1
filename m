Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYGHT6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYGHT6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYGHT6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:58:33 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41665 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYGHT6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:58:32 -0400
Date: Tue, 8 Jul 2008 22:57:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 06/11] remove CONFIG_KMOD from fs
Message-ID: <20080708195736.GE11954@cs181140183.pp.htv.fi>
References: <20080708170015.470877000@sipsolutions.net> <20080708170045.990097000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080708170045.990097000@sipsolutions.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 07:00:21PM +0200, Johannes Berg wrote:
>...
> --- everything.orig/fs/nls/nls_base.c	2008-07-08 18:32:40.000000000 +0200
> +++ everything/fs/nls/nls_base.c	2008-07-08 18:34:44.000000000 +0200
>...
> @@ -216,15 +214,13 @@ static struct nls_table *find_nls(char *
>  struct nls_table *load_nls(char *charset)
>  {
>  	struct nls_table *nls;
> -#ifdef CONFIG_KMOD
>  	int ret;
> -#endif

That gives an "unused variable" gcc warning with CONFIG_MODULES=n.

>  	nls = find_nls(charset);
>  	if (nls)
>  		return nls;
>  
> -#ifdef CONFIG_KMOD
> +#ifdef CONFIG_MODULES
>  	ret = request_module("nls_%s", charset);
>  	if (ret != 0) {
>  		printk("Unable to load NLS charset %s\n", charset);
> 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

