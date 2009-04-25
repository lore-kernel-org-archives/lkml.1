Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZDYXTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZDYXTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 19:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZDYXTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 19:19:09 -0400
Received: from gw.goop.org ([64.81.55.164]:50522 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbZDYXTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 19:19:08 -0400
Message-ID: <49F39A69.3090906@goop.org>
Date: Sat, 25 Apr 2009 16:19:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xensource.com
Subject: Re: Bug: ptrace issues under x86_64 Xen kernel 2.6.29
References: <3e8340490903252341u55abbc3aree9afc1b0a7703e6@mail.gmail.com>	 <49D0361C.3060901@goop.org> <3e8340490904251510r5938b773r7b313555c91e214a@mail.gmail.com>
In-Reply-To: <3e8340490904251510r5938b773r7b313555c91e214a@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan wrote:
> On Sun, Mar 29, 2009 at 11:01 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> Bryan Donlan wrote:
>>     
>>> Using 2.6.29 or 2.6.28 as a 64-bit Xen domU, a number of ptrace()
>>> users seem to have issues with unexpected breakpoints. ltrace and gdb
>>> both seem to be affected, under both 64-bit and 32-bit userspace.
>>> 32-bit kernels do not seem to be affected. Typical symptoms look like:
>>>
>>>       
>> It looks like this is because the kernel sets up int3 (breakpoint) and debug
>> (watchpoints, etc) to be on a separate debug stack in the tss.  Xen doesn't
>> do this (and doesn't appear to have a mechanism to do so), so I guess the
>> on-stack format isn't what the kernel expects.  Does the patch below work?
>>     
>
> Hi,
>
> Sorry for the late reply; this message never made it to my inbox for
> some reason...
> I did try the patch, and saw similar results to Mark; ptrace works,
> but lots of warnings:
>   

Thanks.  Those warnings are harmless, but I have an updated version of 
the fix to suppress them in xen-tip/next.

    J
