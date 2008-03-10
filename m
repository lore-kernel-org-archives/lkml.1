Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYCJP5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYCJP5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYCJP45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:56:57 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:10730 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYCJP44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:56:56 -0400
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <markus.t.metzger@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: prevent unconditional writes to DebugCtl MSR
References: <47D54185.76E4.0078.0@novell.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 Mar 2008 16:56:47 +0100
In-Reply-To: <47D54185.76E4.0078.0@novell.com>
Message-ID: <87r6ei8tds.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Mar 2008 15:50:15.0517 (UTC) FILETIME=[6EDCF8D0:01C882C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <jbeulich@novell.com> writes:
>  
> +static inline void update_debugctlmsr(unsigned long debugctlmsr)
> +{
> +#ifndef CONFIG_X86_DEBUGCTLMSR
> +	if (boot_cpu_data.x86 < 6)
> +		return;
> +#endif
> +	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);

It would be better to use checking_wrmsrl() instead of the model
check because often VMs etc. are missing such MSRs too, but 
report the higher family number.

Also silently failing is not very nice, but that's a different issue.

-Andi
