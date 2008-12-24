Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbYLXMa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbYLXMa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 07:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYLXMaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 07:30:21 -0500
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:40292 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYLXMaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 07:30:20 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: parsing mem=700M broken
Date: Wed, 24 Dec 2008 13:30:27 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Hugh Dickins <hugh@veritas.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils> <20081223143327.GF29151@elte.hu> <200812241808.16195.rusty@rustcorp.com.au>
In-Reply-To: <200812241808.16195.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812241330.29784.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rusty,

On Wednesday 24 December 2008, Rusty Russell wrote:
>  void __init finish_e820_parsing(void)
>  {
> +	bool userdef;

maybe init with userdef = false;

> +	int i;
> +
> +	if (memlimit) {
> +		e820_remove_range(memlimit, ULLONG_MAX - memlimit, E820_RAM, 1);
> +		userdef = true;
> +	}
> +
> +	if (exactmap) {
> +#ifdef CONFIG_CRASH_DUMP
> +		/*
> +		 * If we are doing a crash dump, we still need to know
> +		 * the real mem size before original memory map is
> +		 * reset.
> +		 */
> +		saved_max_pfn = e820_end_of_ram_pfn();
> +#endif
> +		e820.nr_map = 0;
> +		userdef = true;
> +	}
> +
> +	for (i = 0; i < user_e820.nr_map; i++) {
> +		e820_add_region(user_e820.map[i].addr, user_e820.map[i].size,
> +				user_e820.map[i].type);
> +		userdef = true;
> +	}
> +
>  	if (userdef) {
>  		int nr = e820.nr_map;

Because here it might be used uninitialized.

Best Regards

Ingo Oeser
