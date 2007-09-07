Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbXIGK2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbXIGK2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 06:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965073AbXIGK2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 06:28:11 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53738 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965027AbXIGK2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 06:28:10 -0400
Date: Fri, 7 Sep 2007 15:58:05 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Subject: Re: [patch 06/10] Text Edit Lock - kprobes architecture independent support
Message-ID: <20070907102805.GA10389@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070906200124.595238505@polymtl.ca> <20070906200212.399420921@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906200212.399420921@polymtl.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 04:01:30PM -0400, Mathieu Desnoyers wrote:

<snip>

> @@ -716,8 +720,9 @@ static int __kprobes pre_handler_kretpro
>  				 struct kretprobe_instance, uflist);
>  		ri->rp = rp;
>  		ri->task = current;
> +		kernel_text_lock();
>  		arch_prepare_kretprobe(ri, regs);
> -
> +		kernel_text_unlock();

pre_handler_kretprobe() is run when the entry probe for a retprobed
function is hit and cannot block. You can't take a mutex here.

And why do we need to take the kernel_text_lock() here anyway? All
arch_prepare_kretprobe() does is modify the return address stored either
on stack or a register (arch specific) to the trampoline. We don't
change any kernel text here.

Ananth
