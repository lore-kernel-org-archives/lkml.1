Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbXF1W3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbXF1W3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763628AbXF1W3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:29:32 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:57689 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759668AbXF1W3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:29:31 -0400
Date: Thu, 28 Jun 2007 18:18:35 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Joshua Wise <jwise@google.com>
Cc: linux-kernel@vger.kernel.org, akpm@google.com, thockin@google.com,
       mikew@google.com, masouds@google.com
Subject: Re: [PATCH] Info dump on Oops or panic()
Message-ID: <20070628221835.GI2784@fattire.cabal.ca>
References: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:05:56PM -0700, Joshua Wise wrote:
> --- a/arch/x86_64/kernel/process.c
> +++ b/arch/x86_64/kernel/process.c
> @@ -356,6 +356,7 @@ void show_regs(struct pt_regs *regs)
>  	printk("CPU %d:", smp_processor_id());
>  	__show_regs(regs);
>  	show_trace(NULL, regs, (void *)(regs + 1));
> +	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
>  }
> 

woah woah woah. This could push critical bits of the register dump or
stacktrace off the screen... Barring any other problems with the patch,
this should probably be dumped in the oops header, not trailing it where
it could hide critical debugging info.

Regards,
	Kyle M.
