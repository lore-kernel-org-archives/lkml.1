Return-Path: <linux-kernel-owner+w=401wt.eu-S932827AbXF2DEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbXF2DEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 23:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765087AbXF2DEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 23:04:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762915AbXF2DE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 23:04:29 -0400
Message-ID: <468476AA.6090905@redhat.com>
Date: Thu, 28 Jun 2007 23:04:10 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andy Isaacson <adi@hexapodia.org>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0> <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com>
In-Reply-To: <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Jun 28, 2007, at 14:49:24, Davide Libenzi wrote:
>> I was using oprofile to sample some userspace code I am working on, 
>> and I was continuosly noticing  clear_page  in the top three entries 
>> of the oprofile logs.
>>
>> Also, a simple kernel build, in my Dual Opteron with 8GB of RAM, 
>> shows  clear_page  as the first kernel entry, second only to the 
>> userspace the  cc1  and  as. Most of the userspace code uses malloc() 
>> (and anonymous  mappings) in such a way that the memory returned via 
>> kernel->glibc is immediately written soon after. The POSIX malloc() 
>> definition itself also, does not require the returned memory to be 
>> zeroed (as calloc() does).
>>
>> So I implemented a rather quick hack that introduces a new mmap() flag 
>> MAP_NOZERO (only valid for anonymous mappings) and the  vma  
>> counter-part VM_NOZERO. Also, a new sys_brk2() has been introduced to 
>> accept a new flags  parameter. A brief description of the patches 
>> follows in the next emails.
> 
> Hmm, sounds like this would also need a "MAP_NOREUSE" flag of some kind 
> for security sensitive applications.

That wants MAP_PRIVATE so that the kernel can also decide to not
swap these pages out to an unencrypted swap area.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
