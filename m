Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbXIRNbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbXIRNbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 09:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbXIRNbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 09:31:12 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:6858 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbXIRNbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 09:31:11 -0400
Message-ID: <46EFD318.3070401@codemonkey.ws>
Date: Tue, 18 Sep 2007 08:31:04 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20070830)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       Zachary Amsden <zach@vmware.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 2/3] Refactor hypercall infrastructure (v3)
References: <1190059071649-git-send-email-aliguori@us.ibm.com>	<11900590723438-git-send-email-aliguori@us.ibm.com>	<46EFCE2A.1020105@qumranet.com> <46EFCED0.5050209@qumranet.com> <46EFD24C.2050701@qumranet.com>
In-Reply-To: <46EFD24C.2050701@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Avi Kivity wrote:
>   
>> Avi Kivity wrote:
>>     
>>> Anthony Liguori wrote:
>>>  
>>>       
>>>> This patch refactors the current hypercall infrastructure to better 
>>>> support live
>>>> migration and SMP.  It eliminates the hypercall page by trapping the UD
>>>> exception that would occur if you used the wrong hypercall 
>>>> instruction for the
>>>> underlying architecture and replacing it with the right one lazily.
>>>>
>>>> It also introduces the infrastructure to probe for hypercall 
>>>> available via
>>>> CPUID leaves 0x40000000.  CPUID leaf 0x40000001 should be filled out by
>>>> userspace.
>>>>
>>>> A fall-out of this patch is that the unhandled hypercalls no longer 
>>>> trap to
>>>> userspace.  There is very little reason though to use a hypercall to 
>>>> communicate
>>>> with userspace as PIO or MMIO can be used.  There is no code in tree 
>>>> that uses
>>>> userspace hypercalls.
>>>>
>>>>       
>>>>         
>>> Surprisingly, this patch kills Windows XP (ACPI HAL).  I'll try to 
>>> find out why.
>>>
>>>   
>>>       
>> Not trapping #UD brings things back to normal.  So, Windows likes to 
>> execute undefined instructions, and we don'd handle these well.
>>
>>     
> Okay, vmx_inject_ud() was broken.  Fixed now.
>   

Yeah, I was just about to send the patch for that.  Sorry about that, I 
didn't even think to test Windows...

Regards,

Anthony Liguori

