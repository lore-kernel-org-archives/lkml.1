Return-Path: <linux-kernel-owner+w=401wt.eu-S1751165AbXDBPVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbXDBPVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbXDBPVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:21:25 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:14166 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbXDBPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:21:24 -0400
Message-ID: <46111D03.5020905@sciensis.com>
Date: Mon, 02 Apr 2007 18:10:59 +0300
From: Tasos Parisinos <t.parisinos@sciensis.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, indan@nul.nu
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
References: <4610D25F.7080005@ceid.upatras.gr> <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com> <20070402132820.GA28983@one.firstfloor.org>
In-Reply-To: <20070402132820.GA28983@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The main purpose behind the creation of this module was to create the
>> cryptographic infrastructure to develop an in-kernel system of signed
>> modules.
>>     
>
> So how do you plan to close the various interfaces that allow access to kernel
> memory? 
>
> I would suggest to discuss the high level design first before submitting
> code. 
>
>   
>> The best environment to deploy such functionality is in updating by remote,
>> executable code (programs, libs and modules) on embedded devices running
>> Linux, that have some form of kernel physical security, so one can't 
>>     
>
> How would that physical security look like? Would it include DMA
> protection?
>
> For example to do any useful form of graphics you need
> user controllable DMA, which can normally touch everything.
> There are various other similar "backdoors" for root.
>
> I'm somewhat sceptical because all kernels will need access
> to the direct mapping to operate and there are also various
> interfaces that can be as root (ab)used to change it.
>
> And when you can do that they can change function pointers
> and jump to arbitary code or change the kernel page tables
> and map arbitary code.
>
> Disallowing all this would probably end up with a quite
> useless kernel. 
>
>   
>> There are already some systems that implement and utilize such 
>> functionality that
>> use windows platforms, and other Linux distros that use userland 
>>     
>
> Yes, at least the Vista variant was just broken. And its designers spent
> a lot of effort on it, but it didn't help.
>
> -Andi
>
>
>   
Please read the thread i gave you for some details for things you ask

Have in thought that we mostly talk here about embedded devices
that run Linux in a very restricted environment where only specific
applications are allowed to exist and run, there are no user logons
and these applications need to be updated by remote once in a while
over public networks. These applications need not be tampered with
and must not be executed if they are, by someone that has hijacked
the connection by any means. Such devices can have some tamper
responsive hardware where the kernel (only) is protected in case
someone tries to tamper one of these devices by hand (not over the
network). You also need to have a centralized way of updating but
a de-centralized way of key usage so that if a person tampers with
one of these devices does not gain information that can be used
to attack the other devices over the network (like what would happened
if you used symmetric cryptography).

This is not a PC-security feature at all. Though it can be used in 
favour off
other tricks like trip-wire and digsig and others). Of course such 
functionality
could be easily by-passed in that case by someone root privileged with a 
good
understanding of the system internals.

As for Vista, no comments.... :)

Best regards
Tasos Parisinos
-



