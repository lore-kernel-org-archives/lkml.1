Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbZCHKVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbZCHKVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZCHKVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:21:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZCHKVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:21:32 -0400
Subject: Re: [git-pull -tip] x86:perf_counter cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1236507232.28127.2.camel@localhost.localdomain>
References: <1236507232.28127.2.camel@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 08 Mar 2009 11:20:43 +0100
Message-Id: <1236507643.22914.3642.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 15:43 +0530, Jaswinder Singh Rajput wrote:

> +/*
> + * Exported because of ACPI idle
> + */
>  u64 hw_perf_save_disable(void)
>  {
>  	if (unlikely(!perf_counters_initialized))
> @@ -270,9 +272,6 @@ u64 hw_perf_save_disable(void)
>  
>  	return pmc_ops->save_disable_all();
>  }
> -/*
> - * Exported because of ACPI idle
> - */
>  EXPORT_SYMBOL_GPL(hw_perf_save_disable);
>  
>  static void pmc_intel_restore_all(u64 ctrl)
> @@ -301,6 +300,9 @@ static void pmc_amd_restore_all(u64 ctrl)
>  	}
>  }
>  
> +/*
> + * Exported because of ACPI idle
> + */
>  void hw_perf_restore(u64 ctrl)
>  {
>  	if (unlikely(!perf_counters_initialized))
> @@ -308,9 +310,6 @@ void hw_perf_restore(u64 ctrl)
>  
>  	pmc_ops->restore_all(ctrl);
>  }
> -/*
> - * Exported because of ACPI idle
> - */
>  EXPORT_SYMBOL_GPL(hw_perf_restore);

Please leave those comments where they are, they do not describe the
function, but comment on the export.
