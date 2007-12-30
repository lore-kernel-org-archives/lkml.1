Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbXL3Vpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbXL3Vpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXL3Vpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:45:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXL3Vpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:45:32 -0500
Message-ID: <4778113A.4080801@zytor.com>
Date: Sun, 30 Dec 2007 13:44:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <9FXbU-3M4-11@gated-at.bofh.it> <9G2Om-4hg-1@gated-at.bofh.it> <9G7O3-3O2-7@gated-at.bofh.it> <9G8qN-4TX-13@gated-at.bofh.it> <E1J92JB-00013N-P3@be1.7eggert.dyndns.org> <20071230181004.GA21968@elte.hu> <477805F1.4070201@zytor.com> <20071230210007.GA3136@elte.hu>
In-Reply-To: <20071230210007.GA3136@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>
>> It probably should actually HLT, to avoid sucking power, and stressing 
>> the thermal system.  We're dead at this point, and the early 486's 
>> which had problems with HLT will lock up - we don't care.
> 
> ok. Like the patch below?
> 

Don't need the cli; we're already running with interrupts disabled.

I'd do:

	while (1)
		asm volatile("hlt");

... mostly on general principles.

	-hpa
