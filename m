Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZKIC0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZKIC0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 21:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZKIC0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 21:26:35 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:33070 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZKIC0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 21:26:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HgPwcky6KihqZSOYwoDU2YnJaCCeOZjsEvDSZK3nXtxZJe4s3OxF1u23SRkm4/a454
         +3g4+tDYqX+CK/fx7nvJAWxfwqEd5OMjtciLmlz8JH31tOLXuRiy4Tem1YwBwnAQZDhs
         2tdPsvsSIYnIA+zceqVPb1cZJIyKdDjpnEEho=
Date: Mon, 9 Nov 2009 03:26:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Subject: Re: [PATCH -v6 08/13] tracing: add IRQENTRY_EXIT section for MIPS
Message-ID: <20091109022640.GC13153@nowhere>
References: <cover.1256569489.git.wuzhangjin@gmail.com> <f746f813531a16bd650f9290787c66cbc0cdc34d.1256569489.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f746f813531a16bd650f9290787c66cbc0cdc34d.1256569489.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 11:13:25PM +0800, Wu Zhangjin wrote:
> This patch add a new section for MIPS to record the block of the hardirq
> handling for function graph tracer(print_graph_irq) via adding the
> __irq_entry annotation to the the entrypoints of the hardirqs(the block
> with irq_enter()...irq_exit()).
> 
> Thanks goes to Steven & Frederic Weisbecker for their feedbacks.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> +
> +/*
> + * do_IRQ handles all normal device IRQ's (the special
> + * SMP cross-CPU interrupts have their own specific
> + * handlers).
> + */
> +unsigned int __irq_entry do_IRQ(unsigned int irq)
> +{
> +	irq_enter();
> +	__DO_IRQ_SMTC_HOOK(irq);
> +	generic_handle_irq(irq);
> +	irq_exit();
> +
> +	return 1;
> +}



Nano-neat:

Why is it returning a value, it doesn't seem needed (the macro
version didn't)?

Anyway, that looks good to me. I hope the changes from macro
to function calls will be ack by the MIPS maintainers.

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

