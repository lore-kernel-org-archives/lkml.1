Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617Ab0AOAwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0AOAwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852Ab0AOAwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:52:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59589 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab0AOAwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:52:10 -0500
Message-ID: <4B4FBC3C.5090507@cn.fujitsu.com>
Date: Fri, 15 Jan 2010 08:52:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] prio_tree.c: quiet sparse noise
References: <201001141516.27305.hartleys@visionengravers.com>
In-Reply-To: <201001141516.27305.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
> prio_tree.c: quiet sparse noise
> 
> The function prio_tree_init is called during start_kernel. Since it
> is an __init function it is not exposed as an exported symbol.
> A sparse build produces the following warning because of this:
> 
> warning: symbol 'prio_tree_init' was not declared. Should it be static?
> 
> Quiet the warning by declaring the function as an extern before
> it's definition.
> 

Why don't you add a declaration of prio_tree_init() to prio_tree.h,
and let kernel/main.c include it?

> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> ---
> 
> diff --git a/lib/prio_tree.c b/lib/prio_tree.c
> index ccfd850..a677200 100644
> --- a/lib/prio_tree.c
> +++ b/lib/prio_tree.c
> @@ -68,6 +68,9 @@ static void get_index(const struct prio_tree_root *root,
>  
>  static unsigned long index_bits_to_maxindex[BITS_PER_LONG];
>  
> +/* Keep sparse happy since this is not an EXPORT_SYMBOL */
> +extern void prio_tree_init(void);
> +
>  void __init prio_tree_init(void)
>  {
>  	unsigned int i;
> --
