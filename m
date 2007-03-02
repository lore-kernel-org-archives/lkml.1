Return-Path: <linux-kernel-owner+w=401wt.eu-S2992566AbXCBQLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992566AbXCBQLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992565AbXCBQLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:11:06 -0500
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:45309 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S2992566AbXCBQLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:11:05 -0500
Message-ID: <45E84C95.3060604@grupopie.com>
Date: Fri, 02 Mar 2007 16:11:01 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Robert Peterson <rpeterso@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc1] Extend print_symbol capability
References: <45E744E2.1040000@redhat.com>
In-Reply-To: <45E744E2.1040000@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Peterson wrote:
> [...]
> #define KSYM_NAME_LEN 127
> +#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN + \
> +                        2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1)
> 
> #ifdef CONFIG_KALLSYMS
> /* Lookup the address for a symbol. Returns 0 if not found. */
> @@ -22,6 +24,9 @@ const char *kallsyms_lookup(unsigned long addr,
>                            unsigned long *offset,
>                            char **modname, char *namebuf);
> 
> +/* Look up a kernel symbol and return it in a text buffer. */
> +extern void lookup_symbol(unsigned long addr, char *buffer);

I don't like this name much :(

We already have kallsyms_lookup and kallsyms_lookup_name. The name of 
this function should imply that it will print the formatted result into 
the buffer, not just lookup a symbol.

Maybe "__sprint_symbol", and change the interface to 
"__sprint_symbol(char *buffer, unsigned long addr)"?

> +
> /* Replace "%s" in format with address, if found */
> extern void __print_symbol(const char *fmt, unsigned long address);
> 
> @@ -47,6 +52,11 @@ static inline const char *kallsyms_lookup(unsigned 
> long addr,
>        return NULL;
> }
> 
> +static inline void lookup_symbol(unsigned long addr, char *buffer)
> +{
> +       return NULL;
> +}

Returning NULL in a function returning "void" doesn't seem right :P

Maybe it should be something like this instead:
{
	*buffer = '\0';
}

> [...]

Anyway, the change looks useful, so thanks for the patch :)

-- 
Paulo Marques - www.grupopie.com

"Very funny Scotty. Now beam up my clothes."
