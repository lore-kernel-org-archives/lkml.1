Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbXKOXyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbXKOXyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbXKOXy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:54:28 -0500
Received: from sitemail2.everyone.net ([216.200.145.36]:35744 "EHLO
	omta18.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757240AbXKOXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:54:27 -0500
X-Eon-Dm: dm43
X-Eon-Sig: AQEbFf9HPNwym+FDtwIAAAAD,3de2f6f5e8e20b2213090a64b7cbf7d4
Message-ID: <473CDC30.9050405@us.ibm.com>
Date: Thu, 15 Nov 2007 15:54:24 -0800
From: Mike Mason <mmlnx@us.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/7] LTTng instrumentation kernel
References: <20071113193349.214098508@polymtl.ca> <20071113194024.837009055@polymtl.ca> <473CD6A1.6050008@us.ibm.com>
In-Reply-To: <473CD6A1.6050008@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

snip
> 
> +void list_modules(void *call_data)
> +{
> +    /* Enumerate loaded modules */
> +    struct list_head    *i;
> +    struct module        *mod;
> +    unsigned long refcount = 0;
> +
> +    mutex_lock(&module_mutex);
> +    list_for_each(i, &modules) {
> +        mod = list_entry(i, struct module, list);
> +#ifdef CONFIG_MODULE_UNLOAD
> +        refcount = local_read(&mod->ref[0].count);
> +#endif
> +        __trace_mark(0, list_module, call_data,
> +                "name %s state %d refcount %lu",
> +                mod->name, mod->state, refcount);
> +    }
> +    mutex_unlock(&module_mutex);
> +}
> +EXPORT_SYMBOL_GPL(list_modules);
> +
> /* Given an address, look for it in the module exception tables. */
> const struct exception_table_entry *search_module_extables(unsigned long 
> addr)
> {

What is the purpose of list_modules() in this patch?  Seems outside the scope of the patches' intent.  I assume LTTng uses it for some purpose, but it's not required to use the markers added by the patch.

Also, if list_modules() remains, the 0 should be removed from "__trace_mark(0, ..." 

Mike Mason
