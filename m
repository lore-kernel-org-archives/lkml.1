Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbYIPSzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbYIPSzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYIPSz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:55:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54195 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbYIPSz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:55:27 -0400
Message-ID: <48D000B0.8070108@zytor.com>
Date: Tue, 16 Sep 2008 11:53:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jbaron <jbaron@redhat.com>
Subject: Re: [PATCH] introduce boot_printk()
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>	 <86802c440809151034ycd6442me679792880b03320@mail.gmail.com>	 <1221575196.6943.24.camel@lappy.programming.kicks-ass.net>	 <48CFD97C.6080002@zytor.com>	 <86802c440809161045q2f6d80f1yb6e79f32c6e0c303@mail.gmail.com>	 <48CFF281.7010101@zytor.com>	 <86802c440809161110q1fc3d66vedcaa32dea2b2233@mail.gmail.com>	 <48CFF7DF.6010404@zytor.com>	 <86802c440809161124h1245380ch9a3ba588e6ff737@mail.gmail.com>	 <48CFFB72.70203@zytor.com> <86802c440809161137r4264190bxe76f7e6b90235087@mail.gmail.com>
In-Reply-To: <86802c440809161137r4264190bxe76f7e6b90235087@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>
>> Not only do you have duplication, here, but inconsistency...
> 
> how about
> pci_printk(v, KERN_DEBUG "...\n");
> 
> will put
> <pci> <7> ...\n
> in dmesg bug,
> 
> and let vprintk get rid of <pci> like <7>
> 
> is that what you want?
> 

First of all, what is the "v" here, and why not just have
printk(KERN_PCI KERN_DEBUG "...\n");

... and we can do #define PCI_DEBUG KERN_PCI KERN_DEBUG even.

We do have a need for special macros when we're doing device-specific 
prefixes, of course.  If that is what your "v" is meant to be, then 
there was an implicit topic shift in the discussion thread.

	-hpa
