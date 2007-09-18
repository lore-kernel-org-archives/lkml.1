Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbXIRN2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbXIRN2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 09:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbXIRN14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 09:27:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:53816 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbXIRN1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 09:27:55 -0400
Message-ID: <46EFD24C.2050701@qumranet.com>
Date: Tue, 18 Sep 2007 15:27:40 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: kvm-devel@lists.sourceforge.net, Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 2/3] Refactor hypercall infrastructure (v3)
References: <1190059071649-git-send-email-aliguori@us.ibm.com>	<11900590723438-git-send-email-aliguori@us.ibm.com> <46EFCE2A.1020105@qumranet.com> <46EFCED0.5050209@qumranet.com>
In-Reply-To: <46EFCED0.5050209@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Avi Kivity wrote:
>> Anthony Liguori wrote:
>>  
>>> This patch refactors the current hypercall infrastructure to better 
>>> support live
>>> migration and SMP.  It eliminates the hypercall page by trapping the UD
>>> exception that would occur if you used the wrong hypercall 
>>> instruction for the
>>> underlying architecture and replacing it with the right one lazily.
>>>
>>> It also introduces the infrastructure to probe for hypercall 
>>> available via
>>> CPUID leaves 0x40000000.  CPUID leaf 0x40000001 should be filled out by
>>> userspace.
>>>
>>> A fall-out of this patch is that the unhandled hypercalls no longer 
>>> trap to
>>> userspace.  There is very little reason though to use a hypercall to 
>>> communicate
>>> with userspace as PIO or MMIO can be used.  There is no code in tree 
>>> that uses
>>> userspace hypercalls.
>>>
>>>       
>>
>>
>> Surprisingly, this patch kills Windows XP (ACPI HAL).  I'll try to 
>> find out why.
>>
>>   
>
> Not trapping #UD brings things back to normal.  So, Windows likes to 
> execute undefined instructions, and we don'd handle these well.
>
Okay, vmx_inject_ud() was broken.  Fixed now.


-- 
error compiling committee.c: too many arguments to function

