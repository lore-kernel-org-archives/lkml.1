Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYGNWJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYGNWJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbYGNWFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:05:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690AbYGNWFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:05:43 -0400
Message-ID: <487BCD9C.4030003@zytor.com>
Date: Mon, 14 Jul 2008 15:05:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: ia32_signal.c: use macro instead of immediate
References: <487BC1B9.1090400@ct.jp.nec.com>
In-Reply-To: <487BC1B9.1090400@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Make and use macro FIX_EFLAGS, instead of immediate value 0x40DD5 in
> ia32_restore_sigcontext().
> 
> +
> +#ifdef CONFIG_X86_32
> +# define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
> +#else
> +# define FIX_EFLAGS	__FIX_EFLAGS
> +#endif
> +

Where did this come from?  First of all, this is in a 64-bit-only file, 
so CONFIG_X86_32 will never be set; second of all, it seems a bit fishy 
that these should be different.

	-hpa
