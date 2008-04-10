Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYDJAm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYDJAm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYDJAmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:42:22 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:54038 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305AbYDJAmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:42:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkoFADf//EdMQWoK/2dsb2JhbACBXKsh
Date: Wed, 9 Apr 2008 20:42:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@osdl.org
Subject: Re: [patch 13/17] Immediate Values - x86 Optimization
Message-ID: <20080410004219.GA10557@Krystal>
References: <20080409150829.855195878@polymtl.ca> <20080409152051.117322728@polymtl.ca> <47FD0497.10303@zytor.com> <20080409190816.GB30202@Krystal> <47FD4442.3050000@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <47FD4442.3050000@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:39:14 up 40 days, 20:50,  6 users,  load average: 0.47, 0.44,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> * H. Peter Anvin (hpa@zytor.com) wrote:
>>> Mathieu Desnoyers wrote:
>>>> Ok, so the most flexible solution that I see, that should fit for both
>>>> x86 and x86_64 would be :
>>>> 1 byte  :       "=q" : "a", "b", "c", or "d" register for the i386.  For
>>>>                        x86-64 it is equivalent to "r" class (for 8-bit
>>>>                        instructions that do not use upper halves).
>>>> 2, 4, 8 bytes : "=r" : A register operand is allowed provided that it is 
>>>> in a
>>>>                        general register.
>>> Any reason to keep carrying this completely misleading comment chunk 
>>> still?
>>>
>>> 	-hpa
>> This comment explains why I use the =q constraint for the 1 bytes
>> immediate value. It makes sure we use an instruction with 1-byte opcode,
>> without REX.R prefix, on x86_64.
>
> No, it doesn't.  That would be "=Q".
>
> 	-hpa

Ok. Sorry, it's been a few months since we looked at this. So the =q
opcode lets the compiler choose instructions with or without REX prefix.
We can allow this because 

- We don't need the opcode length in the stop_machine_run() version
- we support variable length opcode in the nmi-safe version

Am I remembering correctly now ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
