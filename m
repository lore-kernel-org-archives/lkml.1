Return-Path: <linux-kernel-owner+w=401wt.eu-S934712AbXKPCnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934712AbXKPCnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbXKPCmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:42:51 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:43188 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023AbXKPCmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:42:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAMCSPEdMROHU/2dsb2JhbACBX451
Date: Thu, 15 Nov 2007 21:42:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Mike Mason <mmlnx@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/7] LTTng instrumentation kernel
Message-ID: <20071116024248.GE16953@Krystal>
References: <20071113193349.214098508@polymtl.ca> <20071113194024.837009055@polymtl.ca> <473CD6A1.6050008@us.ibm.com> <473CDC30.9050405@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <473CDC30.9050405@us.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:38:31 up 12 days,  7:43,  8 users,  load average: 0.39, 0.40,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Mason (mmlnx@us.ibm.com) wrote:
> snip
>> +void list_modules(void *call_data)
>> +{
>> +    /* Enumerate loaded modules */
>> +    struct list_head    *i;
>> +    struct module        *mod;
>> +    unsigned long refcount = 0;
>> +
>> +    mutex_lock(&module_mutex);
>> +    list_for_each(i, &modules) {
>> +        mod = list_entry(i, struct module, list);
>> +#ifdef CONFIG_MODULE_UNLOAD
>> +        refcount = local_read(&mod->ref[0].count);
>> +#endif
>> +        __trace_mark(0, list_module, call_data,
>> +                "name %s state %d refcount %lu",
>> +                mod->name, mod->state, refcount);
>> +    }
>> +    mutex_unlock(&module_mutex);
>> +}
>> +EXPORT_SYMBOL_GPL(list_modules);
>> +
>> /* Given an address, look for it in the module exception tables. */
>> const struct exception_table_entry *search_module_extables(unsigned long 
>> addr)
>> {
>
> What is the purpose of list_modules() in this patch?  Seems outside the 
> scope of the patches' intent.  I assume LTTng uses it for some purpose, but 
> it's not required to use the markers added by the patch.
>

Right, I should move it down in my patchset.

> Also, if list_modules() remains, the 0 should be removed from 
> "__trace_mark(0, ..." 
> Mike Mason

With the immediate values based markers, the 0 means an optimized
markers (non-generic). I use __trace_mark directly to be able to pass
the call_data argument.

Thanks for the review,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
