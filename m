Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZH3UFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZH3UFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbZH3UFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:05:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZH3UFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:05:24 -0400
Message-ID: <4A9ADB59.2020508@zytor.com>
Date: Sun, 30 Aug 2009 13:04:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 2/3] x86, msr: rewrite AMD rd/wrmsr variants
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com> <1251633031-2244-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1251633031-2244-2-git-send-email-petkovbb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2009 04:50 AM, Borislav Petkov wrote:
> +
> +#define memset(d,c,l) __builtin_memset(d,c,l)
>  static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
>  {
> -	int err;
> +	u32 gprs[8];
> +	int err, i;
> +
> +	memset(gprs, 0, sizeof(u32) * 8);
> +
> +	gprs[1] = msr;
> +	gprs[7] = 0x9c5a203a;
> +
> +	err = native_rdmsr_safe_regs(gprs);
> +
> +	*p = gprs[0] | ((u64)gprs[2] << 32);
>  
> -	*p = native_read_msr_amd_safe(msr, &err);
>  	return err;
>  }
>  

In file included from
/home/hpa/kernel/linux-2.6-tip.msr/arch/x86/include/asm/processor.h:21,
                 from
/home/hpa/kernel/linux-2.6-tip.msr/include/linux/prefetch.h:14,
                 from
/home/hpa/kernel/linux-2.6-tip.msr/include/linux/list.h:6,
                 from
/home/hpa/kernel/linux-2.6-tip.msr/include/linux/smp.h:11,
                 from
/home/hpa/kernel/linux-2.6-tip.msr/include/linux/kernel_stat.h:4,
                 from
/home/hpa/kernel/linux-2.6-tip.msr/arch/x86/kernel/irq_64.c:11:
/home/hpa/kernel/linux-2.6-tip.msr/arch/x86/include/asm/msr.h: In
function ‘rdmsrl_amd_safe’:
/home/hpa/kernel/linux-2.6-tip.msr/arch/x86/include/asm/msr.h:176:
warning: unused variable ‘i’


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

