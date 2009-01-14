Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbZANIeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbZANIeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbZANIeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:34:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756669AbZANIeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:34:04 -0500
Date: Wed, 14 Jan 2009 00:32:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH][bugfix] kprobes: fix module compilation error with
 CONFIG_KPROBES=n
Message-Id: <20090114003234.3720e9a1.akpm@linux-foundation.org>
In-Reply-To: <49628849.1000706@redhat.com>
References: <49628849.1000706@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 17:23:05 -0500 Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Define kprobes related data structures even if CONFIG_KPROBES is not set.
> This fixes compilation errors which occur if CONFIG_KPROBES is not set, in
> kprobe using modules.
> 
> Reviewed-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  include/linux/kprobes.h |   45 +++++++++++++++++++++++----------------------
>  1 file changed, 23 insertions(+), 22 deletions(-)
> 
> Index: 2.6.28/include/linux/kprobes.h
> ===================================================================
> --- 2.6.28.orig/include/linux/kprobes.h
> +++ 2.6.28/include/linux/kprobes.h
> @@ -37,9 +37,9 @@
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
>  #include <linux/mutex.h>
> +#include <asm/kprobes.h>
> 
>  #ifdef CONFIG_KPROBES
> -#include <asm/kprobes.h>
> 

The above change breaks alpha, and any other architecture which has no
asm/kprobes.h.

I undid that change, but maybe that rebroke things?
