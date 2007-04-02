Return-Path: <linux-kernel-owner+w=401wt.eu-S933962AbXDBLuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962AbXDBLuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933965AbXDBLuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:50:00 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:1557 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933962AbXDBLt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:49:59 -0400
Message-ID: <4610EDF9.9000601@sciensis.com>
Date: Mon, 02 Apr 2007 14:50:17 +0300
From: Tasos Parisinos <t.parisinos@sciensis.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, indan@nul.nu
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
References: <4610D25F.7080005@ceid.upatras.gr> <p73r6r3yn9f.fsf@bingen.suse.de>
In-Reply-To: <p73r6r3yn9f.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Tasos Parisinos <parisino@ceid.upatras.gr> writes:
>
>   
>> From: Tasos Parisinos <t.parisinos@sciensis.com>
>>
>> This patch adds module rsa.ko in the kernel (built-in or as a kernel
>> module) and offers an API to do fast modular exponentiation, using the
>> Montgomery algorithm, thus the exponentiation is not generic but can
>> be used only when
>> the modulus is odd, such as RSA public/private key pairs. This module is the
>> computational core (using multiple precision integer arithmetics) and does not
>> provide any means to do key management, implement padding schemas e.t.c. so the
>> calling code should implement all those as needed. Signed-off-by:
>> Tasos Parisinos <t.parisinos@sciensis.com>
>>     
>
> You forgot to answer the most important question.
>
> What would want to use RSA in the kernel and why?  
>
> -Andi
>
>   

The main purpose behind the creation of this module was to create the
cryptographic infrastructure to develop an in-kernel system of signed
modules.

The best environment to deploy such functionality is in updating by remote,
executable code (programs, libs and modules) on embedded devices running
Linux, that have some form of kernel physical security, so one can't 
tamper the
kernel, but can read it. In this case only a public key would be 
revealed. The
vendor of the devices can sign and distribute/update executable code to 
the devices,
and the kernel will not load/run any of them if they don't match with 
their signatures.
The signature can be embedded in the elf, so this system is portable and 
centralized.
Although this functionality can be achieved using userland helper 
programs this may
create the need to physically secure entire filesystems which adds to 
the cost of
developing such devices. In such cases one needs to use asymmetric 
cryptography
because in the case of symmetric it would be very easy to give away the 
key and
end with having all your devices being attacked.

There are already some systems that implement and utilize such 
functionality that
use windows platforms, and other Linux distros that use userland 
programs to do
so, assuming physical security of the host computer.

Moreover a same system that would use hashes is easier to brake and more 
difficult
to update each time new code must be loaded to the host devices.

See also this thread

http://lkml.org/lkml/2007/3/19/447



