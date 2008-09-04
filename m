Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYIDROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYIDROU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYIDROG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:14:06 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:30213 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYIDROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:14:05 -0400
Message-ID: <48C0175B.3070500@ct.jp.nec.com>
Date: Thu, 04 Sep 2008 10:14:03 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Rui Sousa <rui.p.m.sousa@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATH] Fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is
 not set
References: <200809031753.07292.rui.p.m.sousa@gmail.com> <20080904143918.GA28095@elte.hu>
In-Reply-To: <20080904143918.GA28095@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rui Sousa <rui.p.m.sousa@gmail.com> wrote:
> 
>> Hi,
>>
>> This patch fixes compilation if CONFIG_TRACE_IRQFLAGS_SUPPORT is ever 
>> disabled (which is currently not allowed by Kconfig). Alternatively we 
>> could just remove the option altogether and the associated code paths. 
>> Since the compilation error has been in the tree for at least two 
>> years and no one noticed it, I guess we don't really have the need for 
>> CONFIG_TRACE_IRQFLAGS_SUPPORT=n. Boot tested on x86 UP.
> 
> applied to tip/core/locking - thanks Rui.
> 
> since you fixed it i prefer the fix over the removal. We could still 
> remove the !TRACE_IRQFLAGS_SUPPORT now (in a separate commit) and 
> simpify this header a bit that way. Thus if someone needs the 
> !TRACE_IRQFLAGS_SUPPORT mode of build for future work, it can be 
> restored via a simple revert.

Hi, it seems that this patch breaks uml build.

kernel/printk.c: In function 'vprintk':
kernel/printk.c:674: error: implicit declaration of function 'raw_local_irq_save'
kernel/printk.c:772: error: implicit declaration of function 'raw_local_irq_restore'

thanks,
Hiroshi Shimamoto
