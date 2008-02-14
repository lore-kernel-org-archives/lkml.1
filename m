Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbYBNJ3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbYBNJ3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 04:29:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYBNJ2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 04:28:47 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:44716
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYBNJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 04:28:46 -0500
Message-ID: <47B4098C.3060301@qumranet.com>
Date: Thu, 14 Feb 2008 11:27:40 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Olaf Hering <olaf@aepfle.de>, linux-kernel@vger.kernel.org
Subject: Re: KVM: Export include/linux/kvm.h only if $ARCH actually supports
 KVM
References: <20080210111525.GA28522@aepfle.de> <47B29FB5.40205@qumranet.com> <20080213203450.GB13536@uranus.ravnborg.org>
In-Reply-To: <20080213203450.GB13536@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Feb 13, 2008 at 09:43:49AM +0200, Avi Kivity wrote:
>   
>> Olaf Hering wrote:
>>     
>>>> Currently, make headers_check barfs due to <asm/kvm.h>, which 
>>>> <linux/kvm.h>
>>>> includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export 
>>>> kvm.h
>>>> only if the arch actually supports it.
>>>>    
>>>>         
>>> This makes headers_install_all unreliable.
>>> linux/kvm.h will not be exported, depending on what system the libc
>>> headers will be generated. 
>>>       
>> I see.  Any suggestions besides adding lots of asm-*/kvm.h?
>>     
>
> Do not include asm/kvm.h from linux/kvm.h.
> And in the few places where it is needed explicit include asm/kvm.h before
> linux/kvm.h.
>
> Alternatively inlcude asm/kvm.h inside #ifdef KERNEL"
> so only userspace has to do explicit include of asm before linux variant.
>   

That's not very nice for userspace, which needs asm/kvm.h for the arch 
specific parts of the interface.  I'll add asm-*/kvm.h.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

