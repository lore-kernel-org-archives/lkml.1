Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387Ab0AGLkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0AGLkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 06:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263Ab0AGLkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 06:40:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab0AGLko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 06:40:44 -0500
Message-ID: <4B45C83A.9000803@suse.cz>
Date: Thu, 07 Jan 2010 12:40:42 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Cheng Renquan <crquan@gmail.com>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] kallsyms: skip kernel symbols when lookup in module
References: <1262846626-27109-1-git-send-email-crquan@gmail.com>
In-Reply-To: <1262846626-27109-1-git-send-email-crquan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.1.2010 07:43, Cheng Renquan wrote:
> kernel symbols lookup is expensive, when we know it's a lookup in module,
> we can skip the heavy kernel symbols.
> 
> Signed-off-by: Cheng Renquan <crquan@gmail.com>
> ---
>  kernel/kallsyms.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 8e5288a..bb9fdc5 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -173,12 +173,16 @@ unsigned long kallsyms_lookup_name(const char *name)
>  	unsigned long i;
>  	unsigned int off;
>  
> -	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
> -		off = kallsyms_expand_symbol(off, namebuf);
> +	/* if a colon ':' found, skip the heavy kernel symbols */
> +	if (strchr(name, ':') == NULL) {
> +		for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
> +			off = kallsyms_expand_symbol(off, namebuf);
>  
> -		if (strcmp(namebuf, name) == 0)
> -			return kallsyms_addresses[i];
> +			if (strcmp(namebuf, name) == 0)
> +				return kallsyms_addresses[i];
> +		}
>  	}
> +
>  	return module_kallsyms_lookup_name(name);
>  }
>  EXPORT_SYMBOL_GPL(kallsyms_lookup_name);

It think Rusty is the right person to handle this (CC added). But if you
want my opinion: The patch looks ok.

Acked-by: Michal Marek <mmarek@suse.cz>

Michal
