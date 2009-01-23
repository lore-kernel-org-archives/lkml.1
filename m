Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZAWUnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZAWUnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 15:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZAWUmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 15:42:54 -0500
Received: from ik-out-1112.google.com ([66.249.90.183]:14735 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbZAWUmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 15:42:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=r39AJqrSJLYnecFZYrTS8H3xjHgnqcFh2tA+QsocZj6dU8tsaqTZbA4SmUtzvn87G6
         zMEZ/ULkqa9Pe3q6k4gRZaC/76vNMzQLOSvDT2sqscwFNIPjePgC2sHaUBo+syc29C7s
         VUR1LfLEPjmvx0jHEEP+FA5NsFN+ytr4soxHU=
Message-ID: <497A2BC7.5030107@gmail.com>
Date: Fri, 23 Jan 2009 22:42:47 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       LLVM Developers Mailing List <llvmdev@cs.uiuc.edu>
Subject: Re: inline asm semantics: output constraint width smaller than input
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu> <497A0C0A.7080207@gmail.com> <20090123183019.GA5984@elte.hu> <497A11F5.9090005@gmail.com>
In-Reply-To: <497A11F5.9090005@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-23 20:52, Török Edwin wrote:
> On 2009-01-23 20:30, Ingo Molnar wrote:
>   
>> * Török Edwin <edwintorok@gmail.com> wrote:
>>
>>   
>>     
>>> Having said that, llvm-gcc is not yet able to compile the full Linux 
>>> kernel on its own [for example the boot code, due to asm(".code16gcc")], 
>>> but with LLVM 2.4 it was possible to build "arch=UM", and "arch=X86" (by 
>>> using gcc to build the bootcode). I'd like LLVM 2.5 to be able to build 
>>> the kernel, so I'll file bugs for llvm/kernel depending on where the 
>>> problem is.
>>>     
>>>       
>> Could we get LLVM folks on the Cc: and see how difficult it would be to 
>> fix this on the LLVM side? Asm constraints are used all around the place 
>> and different input/output types are very common.
>>     
>
>   

Hi Ingo,

Could you describe what are the semantics you need for inline asm
constraints in the kernel?
GCC doesn't document all the corner cases, and defining inline asm =
"whatever gcc accepts" is not very useful for LLVM.

So far we've encountered the problem with input/output operand tied to
same register, but having different widths:
- output wider than input, both integers: do you need this case?
- output narrower than input, both integers: this is the common case, right?
- can it also happen that input is pointer, output is integer of
different width?
- .. any other mismatches?

Could you also describe why put_user/the example from pcbios needs the
different widths?

Best regards,
--Edwin
