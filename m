Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbXL3WCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbXL3WCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 17:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbXL3WCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 17:02:10 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:42599 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbXL3WCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 17:02:09 -0500
Message-ID: <47781499.5010209@keyaccess.nl>
Date: Sun, 30 Dec 2007 22:58:49 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Bodo Eggert <7eggert@gmx.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <9FXbU-3M4-11@gated-at.bofh.it> <9G2Om-4hg-1@gated-at.bofh.it> <9G7O3-3O2-7@gated-at.bofh.it> <9G8qN-4TX-13@gated-at.bofh.it> <E1J92JB-00013N-P3@be1.7eggert.dyndns.org> <20071230181004.GA21968@elte.hu> <477805F1.4070201@zytor.com> <20071230210007.GA3136@elte.hu> <4778113A.4080801@zytor.com>
In-Reply-To: <4778113A.4080801@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-12-07 22:44, H. Peter Anvin wrote:
> Ingo Molnar wrote:
>>>>
>>> It probably should actually HLT, to avoid sucking power, and 
>>> stressing the thermal system.  We're dead at this point, and the 
>>> early 486's which had problems with HLT will lock up - we don't care.
>>
>> ok. Like the patch below?
>>
> 
> Don't need the cli; we're already running with interrupts disabled.
> 
> I'd do:
> 
>     while (1)
>         asm volatile("hlt");
> 
> ... mostly on general principles.

At least with current GCC the volatile isn't strictly needed as its implied 
without output operands but I was only certain after checking that. Do you 
remember if that used to be different for previous GCC versions? I tend to 
also stick volatiles on them still...

Rene.
