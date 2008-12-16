Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYLPRza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYLPRza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYLPRzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:55:16 -0500
Received: from gw.goop.org ([64.81.55.164]:43596 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbYLPRzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:55:14 -0500
Message-ID: <4947EB7C.9080006@goop.org>
Date: Tue, 16 Dec 2008 09:55:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH] x86-64: fix HYPERVISOR_update_descriptor()
References: <4947A108.76E4.0078.0@novell.com>
In-Reply-To: <4947A108.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>   

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> ---
>  arch/x86/include/asm/xen/hypercall.h |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- linux-2.6.28-rc8/arch/x86/include/asm/xen/hypercall.h	2008-12-11 14:45:37.000000000 +0100
> +++ 2.6.28-rc8-x86_64-xen-update-descr/arch/x86/include/asm/xen/hypercall.h	2008-12-12 10:25:55.000000000 +0100
> @@ -290,6 +290,8 @@ HYPERVISOR_get_debugreg(int reg)
>  static inline int
>  HYPERVISOR_update_descriptor(u64 ma, u64 desc)
>  {
> +	if (sizeof(u64) == sizeof(long))
> +		return _hypercall2(int, update_descriptor, ma, desc);
>  	return _hypercall4(int, update_descriptor, ma, ma>>32, desc, desc>>32);
>  }
>  
>
>
>
>   

