Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZBDLbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZBDLbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZBDLaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:30:55 -0500
Received: from ozlabs.org ([203.10.76.45]:53862 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZBDLay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:30:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Arnold <jbarnold@mit.edu>
Subject: Re: [PATCH 5/7] Ksplice: Add functions for walking kallsyms symbols
Date: Wed, 4 Feb 2009 22:00:50 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>, Tim Abbott <tabbott@mit.edu>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-5-git-send-email-jbarnold@mit.edu> <1228521840-3886-6-git-send-email-jbarnold@mit.edu>
In-Reply-To: <1228521840-3886-6-git-send-email-jbarnold@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042200.50726.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008 10:33:58 Jeff Arnold wrote:
> From: Anders Kaseorg <andersk@mit.edu>
> 
> kallsyms_lookup_name only returns the first match that it finds.  Ksplice
> needs information about all symbols with a given name in order to correctly
> resolve local symbols.
> 
> kallsyms_on_each_symbol provides a generic mechanism for iterating over the
> kallsyms table.

Seems reasonable.  Did you really not want a name-filtering version?  That
might be generally useful.

> +/* Call a function on each kallsyms symbol in the core kernel */
> +int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
> +				      unsigned long),
> +			    void *data);

But does no locking at all.  It either needs a comment that it can only be
called from inside stop_machine, or that it needs preempt disabled, or
whatever.

> +static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *,
> +						    struct module *,
> +						    unsigned long),
> +					  void *data)
> +{
> +	return 0;
> +}

Is the !CONFIG_KALLSYMS version useful to you?  If not, please don't
implement the noop version.  I want someone who *does* expect it to work to
have to think about it if they use it...

Thanks,
Rusty.
