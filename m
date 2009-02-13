Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbZBMRuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbZBMRuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 12:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZBMRuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 12:50:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58025 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZBMRuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 12:50:00 -0500
Message-ID: <4995B1E7.4070908@zytor.com>
Date: Fri, 13 Feb 2009 09:46:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 4/7] x86: memtest: adapt log messages
References: <20090213144600.GA6298@alberich.amd.com>	 <20090213145517.GD13000@alberich.amd.com>  <20090213165302.GA24299@elte.hu> <1234544696.26783.2.camel@localhost.localdomain>
In-Reply-To: <1234544696.26783.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Fri, 2009-02-13 at 17:53 +0100, Ingo Molnar wrote:
>> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
>>
>>> +#ifdef CONFIG_X86_64
>>> +			printk(KERN_CONT "\n  %010llx - %010llx pattern %016llx",
>>> +			       t_start, t_start + t_size, cpu_to_be64(pattern));
>>> +#else
>>> +			printk(KERN_CONT "\n  %010llx - %010llx pattern %08x",
>>> +			       t_start, t_start + t_size, cpu_to_be32(pattern));
>>> +#endif
>> hm, is there really no cleaner way to do this?
> 
> Can we use this:
> 
> +			printk(KERN_CONT "\n  %010llx - %010llx pattern %016llx",
> +			       t_start, t_start + t_size, cpu_to_be64(pattern));
> 

Only if you don't mind 8 extra zeros on 32 bits.

There are other problems with this, too.  There is a KERN_CONT at the
end of it, but it starts a new line, and then doesn't have another
priority flag.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

