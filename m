Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbYLAJZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbYLAJZC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 04:25:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYLAJYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 04:24:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33495 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbYLAJYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 04:24:51 -0500
Message-ID: <4933AD51.5000202@redhat.com>
Date: Mon, 01 Dec 2008 11:24:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lguest@ozlabs.org, Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, jeremy@xensource.com,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104150729.GC21470@localhost> <20081129154516.GA26579@mailshack.com> <49318871.8010501@redhat.com> <200812011502.37170.rusty@rustcorp.com.au>
In-Reply-To: <200812011502.37170.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Sunday 30 November 2008 04:52:41 Avi Kivity wrote:
>   
>> Alexander van Heukelum wrote:
>>     
>>> I now did the benchmarks for the same -rc6 with hpa's 4-byte stubs
>>> too. Same machine. It's significantly better than the other two
>>> options in terms of speed. It takes about 7% less cpu to handle
>>> the interrupts. (0.64% cpu instead of 0.69%.) I have to run now,
>>> I'll let interpreting the histogram to someone else ;).
>>>       
>> This is noise. 0.05% cpu on a 1GHz machine servicing 1000 interrupt/sec
>> boils down to 500 cycles/interrupt.  These changes shouldn't amount to
>> so much (and I doubt you have 1000 interrupts/sec with a single disk)..
>>     
>
> Sure, but smallest cache wins.  Which is why I thought hpa chose the 3 byte 
> option.
>
>   

Four bytes was the smallest sane option.  Three bytes involved 
instruction opcodes overlap.

>> I'm sorry, but the whole effort is misguided, in my opinion.
>>     
>
> Respectfully disagree.  I wouldn't do it, but it warms my heart that others 
> are.  It's are not subtractive from other optimization efforts.
>   

Once it's done there's no reason not to commit it.  But the effort 
expended to do it is gone, without any measurable return.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

