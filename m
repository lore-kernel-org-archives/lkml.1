Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYFYIhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYFYIhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 04:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbYFYIhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 04:37:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:35183 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751591AbYFYIhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:37:39 -0400
Date: Wed, 25 Jun 2008 10:37:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       llipavsky@suse.cz
Subject: Re: [PATCH] module: make symbol_put_addr() work for all exported
 symbols
In-Reply-To: <200806231348.58317.rusty@rustcorp.com.au>
Message-ID: <alpine.LNX.1.10.0806251034330.4593@jikos.suse.cz>
References: <alpine.LNX.1.10.0806191508020.4593@jikos.suse.cz> <200806231348.58317.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, Rusty Russell wrote:

>    It might be better to centralize all these iterators, and create a 
> proper iterator function.  Any chance you could rewrite it on top of 
> this patch? (Lightly tested)

Hi Rusty,

yes, this looks like better approach. I will respin that patch.

> +struct find_symbol_arg
> +{
> +	/* Input */
> +	const char *name;
> +	bool gplok;
> +	bool warn;
> +
> +	/* Output */
> +	struct module *owner;
> +	const unsigned long *crc;
> +	unsigned long value;
> +};

I see two options how to do this -- either I can make 'value' input 
parameter too, so that find_symbol_in_section() could perform lookup 
either according to address or according to name (whatever is specified in 
the passed struct find_symbol_arg), or I can do a completely new lookup 
function for address-wise lookups. What would you prefer? I don't have any 
strong preference either way.

Thanks,

-- 
Jiri Kosina
SUSE Labs
