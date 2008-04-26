Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbYDZGpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbYDZGpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 02:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYDZGou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 02:44:50 -0400
Received: from gw.goop.org ([64.81.55.164]:58575 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbYDZGot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 02:44:49 -0400
Message-ID: <4812CF5B.4080902@goop.org>
Date: Fri, 25 Apr 2008 23:44:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function
 calls
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1208890227-24808-3-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
>   
[...]
> +void arch_send_call_function_single_ipi(int cpu)
>  {
>   
[...]
> +void arch_send_call_function_ipi(cpumask_t mask)
>  {
>   
[...]
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> +void arch_send_call_function_ipi(cpumask_t mask)
> +{
>   
[...]
> +void arch_send_call_function_single_ipi(int cpu)
> +{
> +	xen_send_IPI_mask(cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
>  

Xen vs native is a runtime choice, so you can't just statically define 
arch_send_call_function(_single)_ipi for each.  You need to define the 
arch_* functions once, make them call via smp_ops, and call into the 
respective native and Xen versions of the ipi functions.

Aside from that it looks good, with a very appealing code size reduction.

    J
