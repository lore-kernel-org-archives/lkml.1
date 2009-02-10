Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZBJBJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZBJBJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZBJBJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:09:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:41890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbZBJBJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:09:19 -0500
Message-ID: <4990D397.8060705@kernel.org>
Date: Tue, 10 Feb 2009 10:08:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 03/11] x86: fix math_emu register frame access
References: <1234186798-16820-1-git-send-email-tj@kernel.org>	 <1234186798-16820-4-git-send-email-tj@kernel.org> <73c1f2160902090913n20283872r2cb5ae774560d047@mail.gmail.com>
In-Reply-To: <73c1f2160902090913n20283872r2cb5ae774560d047@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Feb 2009 01:08:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

Brian Gerst wrote:
>>  {
>>        printk(KERN_EMERG
>>                "math-emulation not enabled and no coprocessor found.\n");
>> @@ -910,16 +910,19 @@ asmlinkage void math_emulate(long arg)
>>  }
>>  #endif /* CONFIG_MATH_EMULATION */
>>
>> -dotraplinkage void __kprobes
>> -do_device_not_available(struct pt_regs *regs, long error)
>> +dotraplinkage void __kprobes do_device_not_available(struct pt_regs regs)
> 
> Why did you change this to pass by value?  This is called from the
> generic trap handler (error_code), which already passes the pt_regs
> pointer in %eax.

Ah.. right, my bad.  I somehow thought dotraplinkage is asmlinkage on
x86_32.  Yeah, the original code was fine in that area, but then again
most other trap functions take struct pt_regs.  Anyways, you're gonna
post patches to convert trap functions to take pointer to pt_regs,
right?  Can you please fix this one up together with those?

Thanks.

-- 
tejun
