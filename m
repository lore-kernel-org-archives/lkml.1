Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbZF3Vif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbZF3Vif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZF3Vi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:38:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753721AbZF3Vi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:38:27 -0400
Date: Tue, 30 Jun 2009 14:38:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: torvalds@linux-foundation.org, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, mhiramat@redhat.com
Subject: Re: [BUGFIX][ PATCH] kprobes: fix kprobe selftest configuration
 dependency
Message-Id: <20090630143806.9ab4519d.akpm@linux-foundation.org>
In-Reply-To: <20090622210302.4984.82798.stgit@localhost.localdomain>
References: <20090622210302.4984.82798.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 17:03:02 -0400
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Select CONFIG_KALLSYMS_ALL when CONFIG_KPROBES_SANITY_TEST=y.
> Kprobe selftest always fail without CONFIG_KALLSYMS_ALL=y, because
> kallsyms doesn't list up the target functions which are probed in this
> test.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> ---
> 
>  lib/Kconfig.debug |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 23067ab..661c675 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -727,6 +727,7 @@ config KPROBES_SANITY_TEST
>  	bool "Kprobes sanity tests"
>  	depends on DEBUG_KERNEL
>  	depends on KPROBES
> +	select KALLSYMS_ALL
>  	default n
>  	help
>  	  This option provides for testing basic kprobes functionality on

KALLSYMS_ALL depends on KALLSYMS, so what happens here if KALLSYMS=n?

Ah, KPROBES depends on KALLSYMS, so that problem won't be occurring.

Still, the end result is significently more complex and fragile than a
`depends on' would have been.  But I suppose we've done worse.  Oh well.


