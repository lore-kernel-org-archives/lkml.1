Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYCMLNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYCMLNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 07:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYCMLNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 07:13:07 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:37446 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYCMLNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 07:13:06 -0400
Date: Thu, 13 Mar 2008 12:13:03 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Avi Kivity <avi@qumranet.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: KVM: Export include/linux/kvm.h only if $ARCH actually
	supports KVM
Message-ID: <20080313111303.GA6474@aepfle.de>
References: <20080210111525.GA28522@aepfle.de> <47B29FB5.40205@qumranet.com> <20080213203450.GB13536@uranus.ravnborg.org> <47B4098C.3060301@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47B4098C.3060301@qumranet.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, Avi Kivity wrote:

> Sam Ravnborg wrote:
>> On Wed, Feb 13, 2008 at 09:43:49AM +0200, Avi Kivity wrote:
>>   
>>> Olaf Hering wrote:
>>>     
>>>>> Currently, make headers_check barfs due to <asm/kvm.h>, which 
>>>>> <linux/kvm.h>
>>>>> includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export 
>>>>> kvm.h
>>>>> only if the arch actually supports it.
>>>>>            
>>>> This makes headers_install_all unreliable.
>>>> linux/kvm.h will not be exported, depending on what system the libc
>>>> headers will be generated.       
>>> I see.  Any suggestions besides adding lots of asm-*/kvm.h?
>>>     
>>
>> Do not include asm/kvm.h from linux/kvm.h.
>> And in the few places where it is needed explicit include asm/kvm.h before
>> linux/kvm.h.
>>
>> Alternatively inlcude asm/kvm.h inside #ifdef KERNEL"
>> so only userspace has to do explicit include of asm before linux variant.
>>   
>
> That's not very nice for userspace, which needs asm/kvm.h for the arch 
> specific parts of the interface.  I'll add asm-*/kvm.h.

Can you please revert this change before 2.6.25 is released?
'make headers_install_all' has to be reliable.

 commit fb56dbb31c4738a3918db81fd24da732ce3b4ae6
 Author: Avi Kivity <avi@qumranet.com>
 Date:   Sun Dec 2 10:50:06 2007 +0200

    KVM: Export include/linux/kvm.h only if $ARCH actually supports KVM

    Currently, make headers_check barfs due to <asm/kvm.h>, which <linux/kvm.h>
    includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export kvm.h
    only if the arch actually supports it.


