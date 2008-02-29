Return-Path: <linux-kernel-owner+w=401wt.eu-S932735AbYB2VNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbYB2VNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYB2VNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:13:33 -0500
Received: from gw.goop.org ([64.81.55.164]:52830 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYB2VNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:13:32 -0500
Message-ID: <47C87488.9030205@goop.org>
Date: Fri, 29 Feb 2008 13:09:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>
Subject: Re: bad paravirt/Xen interaction in "x86 - Enhance DEBUG_RODATA support
 - alternatives"
References: <47C86D7A.5030608@goop.org> <47C8717F.3030009@zytor.com>
In-Reply-To: <47C8717F.3030009@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>> The patch "x86 - Enhance DEBUG_RODATA support - alternatives" enables 
>> the kernel for writing by clearing X86_CR0_WP allow privileged 
>> writes.  This won't work in a paravirt environment for two reasons:
>>
>>   1. the kernel may not be running in ring 0, so writes will still be
>>      prevented
>>   2. the hypervisor prevents X86_CR0_WP from being cleared anyway (it
>>      GPFs the cr0 update)
>>
>> This crashes on Xen, and it would probably break VMI too.

(lguest too, of course)

>> The only safe way to allow writes is to change the page permissions 
>> (either on the page itself, or create a temporary writable alias for 
>> that page).  Perhaps something you could do it with kmap_atomic.
>>
>
> A properly implemented hypervisor should arguably emulate this.
>
> Doesn't really mean the patch is worth the pain.

No, it would be irritating to implement.

Seems to me that doing the update in a temporary kmap_atomic mapping 
would be a more straightforward way to go, anyway.  How would you 
implement this on a processor without something like X86_CR0_WP?

    J
