Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbYKVBux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbYKVBux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYKVBun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:50:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYKVBum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:50:42 -0500
Message-ID: <4927655B.5070906@zytor.com>
Date: Fri, 21 Nov 2008 17:50:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: signal: cosmetic unification of sys_rt_sigreturn()
References: <49276229.9060000@ct.jp.nec.com> <492762B1.4020107@ct.jp.nec.com>
In-Reply-To: <492762B1.4020107@ct.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
>  
> +#ifdef CONFIG_X86_32
>  asmlinkage int sys_rt_sigreturn(unsigned long __unused)
>  {
>  	struct pt_regs *regs = (struct pt_regs *)&__unused;
>  
>  	return do_rt_sigreturn(regs);
>  }

Why not:

asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
{
	return do_rt_sigreturn(&regs);
}

...?

	-hpa
