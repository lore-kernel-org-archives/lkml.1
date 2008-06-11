Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYFKEBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYFKEBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 00:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbYFKEBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 00:01:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60409 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbYFKEBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 00:01:04 -0400
Date: Wed, 11 Jun 2008 09:29:55 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, akpm@linux-foundation.org
Subject: Re: [PATCH] kprobes: remove redundant config check
Message-ID: <20080611035955.GA19154@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <484EB61E.7050509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484EB61E.7050509@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 10:43:02PM +0530, Abhishek Sagar wrote:
> Hi,
> 
> I noticed that there's a CONFIG_KPROBES check inside kernel/kprobes.c,
> which seems redundant. Can be removed?
> 
> Diff'd against v2.6.26-rc5.
> 
> 
> Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
> ---
> remove redundant CONFIG_KPROBES check.
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 1e0250c..2b2cae2 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1283,13 +1283,8 @@ EXPORT_SYMBOL_GPL(register_jprobe);
>  EXPORT_SYMBOL_GPL(unregister_jprobe);
>  EXPORT_SYMBOL_GPL(register_jprobes);
>  EXPORT_SYMBOL_GPL(unregister_jprobes);
> -#ifdef CONFIG_KPROBES
>  EXPORT_SYMBOL_GPL(jprobe_return);
> -#endif
> -
> -#ifdef CONFIG_KPROBES
>  EXPORT_SYMBOL_GPL(register_kretprobe);
>  EXPORT_SYMBOL_GPL(unregister_kretprobe);
>  EXPORT_SYMBOL_GPL(register_kretprobes);
>  EXPORT_SYMBOL_GPL(unregister_kretprobes);
> -#endif

Abhishek,

This was intentional (to take care of some gcc 4.2 issues). See commit
cd5bfea278987ebfe60f3ff92a01696b17c4f978 (fix compilation with gcc 4.2)
from Peter Chubb for details.

Ananth
