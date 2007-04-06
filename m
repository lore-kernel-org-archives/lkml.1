Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXDFV3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXDFV3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXDFV3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:29:32 -0400
Received: from main.gmane.org ([80.91.229.2]:34223 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064AbXDFV3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:29:31 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Date: Fri, 06 Apr 2007 17:30:49 -0400
Message-ID: <4616BC09.2080509@tmr.com>
References: <4610D25F.7080005@ceid.upatras.gr> <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Andi Kleen <andi@firstfloor.org>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, indan@nul.nu
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <4610EDF9.9000601@sciensis.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tasos Parisinos wrote:
> Andi Kleen wrote:
>> Tasos Parisinos <parisino@ceid.upatras.gr> writes:
>>
>>  
>>> From: Tasos Parisinos <t.parisinos@sciensis.com>
>>>
>>> This patch adds module rsa.ko in the kernel (built-in or as a kernel
>>> module) and offers an API to do fast modular exponentiation, using the
>>> Montgomery algorithm, thus the exponentiation is not generic but can
>>> be used only when
>>> the modulus is odd, such as RSA public/private key pairs. This module 
>>> is the
>>> computational core (using multiple precision integer arithmetics) and 
>>> does not
>>> provide any means to do key management, implement padding schemas 
>>> e.t.c. so the
>>> calling code should implement all those as needed. Signed-off-by:
>>> Tasos Parisinos <t.parisinos@sciensis.com>
>>>     
>>
>> You forgot to answer the most important question.
>>
>> What would want to use RSA in the kernel and why? 
>> -Andi
>>
>>   
> 
> The main purpose behind the creation of this module was to create the
> cryptographic infrastructure to develop an in-kernel system of signed
> modules.
> 
I don't really see why this has to be in the kernel, even after reading 
your text below. This would be code which a tiny number of users would 
find useful, someone in the future might find exploitable, to perform a 
function which can be done in user space.

> The best environment to deploy such functionality is in updating by
> remote, executable code (programs, libs and modules) on embedded
> devices running Linux, that have some form of kernel physical
> security, so one can't tamper the kernel, but can read it. In this
> case only a public key would be revealed. The vendor of the devices
> can sign and distribute/update executable code to the devices, and
> the kernel will not load/run any of them if they don't match with
> their signatures. The signature can be embedded in the elf, so this
> system is portable and centralized. 

> Although this functionality can be achieved using userland helper
> programs this may create the need to physically secure entire
> filesystems which adds to the cost of developing such devices.

So to save cost on your end you want to make this feature part of the 
mainline kernel. Am I misreading your intent here?

> In such cases one needs to use asymmetric cryptography because in the
> case of symmetric it would be very easy to give away the key and end
> with having all your devices being attacked.
> 
Which make a good argument for doing asymmetric anyway, it would seem. 
That way any updates can be checked off the target machine and validated 
as authentic.

> There are already some systems that implement and utilize such 
> functionality that use windows platforms, and other Linux distros
> that use userland programs to do so, assuming physical security of
> the host computer.
> 
Exactly.

> Moreover a same system that would use hashes is easier to brake and
> more difficult to update each time new code must be loaded to the
> host devices.
> 
> See also this thread
> 
> http://lkml.org/lkml/2007/3/19/447
> 
Having said all this, we have a boatload of other crypto in the kernel, 
if it's just the crypto module, like aes, anubis or micheal_mic, and is 
GPL compatible, some people may agree. But if this is an embedded 
system, and you have the patch, why not just apply it to your kernel and 
forget mainline?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

