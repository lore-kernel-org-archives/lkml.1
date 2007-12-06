Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbXLFNV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbXLFNV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 08:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXLFNVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 08:21:19 -0500
Received: from r00tworld.com ([212.85.137.21]:48875 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbXLFNVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 08:21:18 -0500
From: pageexec@freemail.hu
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2007 14:19:33 +0200
MIME-Version: 1.0
Subject: Re: [patch 06/11] Text Edit Lock - Alternative code for x86
Reply-to: pageexec@freemail.hu
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <475804F5.4781.35D49FA@pageexec.freemail.hu>
In-reply-to: <20071206020441.851817020@polymtl.ca>
References: <20071206020246.417605824@polymtl.ca>, <20071206020441.851817020@polymtl.ca>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 06 Dec 2007 14:19:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Dec 2007 at 21:02, Mathieu Desnoyers wrote:

> Fix a memcpy that should be a text_poke (in apply_alternatives).
> 
> Use kernel_wp_save/kernel_wp_restore in text_poke to support DEBUG_RODATA
> correctly and so the CPU HOTPLUG special case can be removed.
> 
> Add text_poke_early, for alternatives and paravirt boot-time and module load
> time patching.
> 
> Notes:
> - we use a macro for kernel_wp_save/restore to mimic local_irq_save/restore: the
>   argument is passed without &.

sorry to chime in again, but lately i've been thinking that the
cr0 argument is not really needed if one can ensure that calls
to the kernel open/close macros won't nest (i checked and even
in the PaX case it's easy to ensure, even desirable in fact).

in your case it's also true for now and i can't think of a situation
where you'd really want to nest in the future (that'd mean opening
up the kernel while some complex piece of code runs, more complex
than a mere memset at least ;-). what do you think?

