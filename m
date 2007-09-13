Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbXIMXBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbXIMXBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbXIMXA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:00:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbXIMXA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:00:56 -0400
Date: Thu, 13 Sep 2007 16:00:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module.c: add missing ifdefs for CONFIG_UNUSED_SYMBOLS
Message-Id: <20070913160047.159e5e3d.akpm@linux-foundation.org>
In-Reply-To: <200709132330.33283.vda.linux@googlemail.com>
References: <200709132330.33283.vda.linux@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 23:30:33 +0100
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> module.c and module.h conatains code for finding
> exported symbols which are declared with EXPORT_UNUSED_SYMBOL,
> and this code is compiled in even if CONFIG_UNUSED_SYMBOLS is not set
> and thus there can be no EXPORT_UNUSED_SYMBOLs in modules anyway
> (because EXPORT_UNUSED_SYMBOL(x) are compiled out to nothing then).
> 
> This patch adds required #ifdefs.
> 
> This shrinks module.o and each *.ko file.
> 
> Patch also regroups some struct module members so
> that on 64 bit CPUs we are not wasting 32 bits on padding here:
> 
>         const struct kernel_symbol *unused_syms;
>         unsigned int num_unused_syms;
>         const unsigned long *unused_crcs;
> 
> It groups counters and pointers separately.
> 
> Patch makes small edit to help text of CONFIG_MODULE_UNLOAD -
> it explicitly says that without that option, kernel
> will be also faster, not only "smaller and simpler".
> When I realized how much churn is going on under the hood
> in order to make module unloading possible, I felt that
> users are not informed well enough about it in the help text.
> 
> And finally, structure members which hold length of module
> code (four such members there) and count of symbols
> are converted from longs to ints.
> 
> We cannot possibly have a module where 32 bits won't
> be enough to hold such counts.
> 
> For one, module loading checks module size for sanity
> before loading, so such insanely big module will fail
> that test first.
> 
> In short, patch makes trivial changes which are "obviously correct"
> (famous last words).

The intent seems reasonable.  Would have preferred separate patches for the
separate things though..

This:

akpm:/usr/src/25> grep '^+#' patches/modulec-add-missing-ifdefs-for-config_unused_symbols.patch                                                                 +#ifdef CONFIG_UNUSED_SYMBOLS
+#endif
+#ifdef CONFIG_UNUSED_SYMBOLS
+#endif
+#ifdef CONFIG_UNUSED_SYMBOLS
+#endif
+#ifdef CONFIG_UNUSED_SYMBOLS
+#endif
+#ifdef CONFIG_UNUSED_SYMBOLS
+#endif
+#ifdef CONFIG_UNUSED_SYMBOLS
+#endif
+#ifdef CONFIG_UNUSED_SYMBOLS
+#endif
+#ifdef CONFIG_UNUSED_SYMBOLS
+#endif
+#ifdef CONFIG_UNUSED_SYMBOLS
+#endif
+#ifdef CONFIG_UNUSED_SYMBOLS
+#endif
+#ifdef CONFIG_UNUSED_SYMBOLS
+#endif

is a bit of a maintenance problem though.  Can you think of a way in whcih
we can cut down on that?

