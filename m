Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZEHPXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZEHPXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZEHPXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:23:04 -0400
Received: from gw.goop.org ([64.81.55.164]:34009 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZEHPXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:23:02 -0400
Message-ID: <4A044E55.20803@goop.org>
Date: Fri, 08 May 2009 08:23:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/5] xen/x86-64: clean up warnings	 aboutIST-using
 traps
References: <4A032EE0.9030607@goop.org> <4A03F947.76EA.0078.0@novell.com>
In-Reply-To: <4A03F947.76EA.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> else if (addr == (unsigned long)int3)
>> 		addr = (unsigned long)xen_int3;
>> -	else
>> -		WARN_ON(val->ist != 0);
>> +	else if (addr == (unsigned long)double_fault ||
>> +		 addr == (unsigned long)stack_segment) {
>>     
>
> I don't think you want to exclude handling stack faults: Ordinary memory
> references using rsp or rbp as the base register will cause these instead
> of general protection faults when the resulting effective address is non-
> canonical.
>   

So even usermode memory accesses?  Ew.  Well, we can run the trap 
handler on the normal kernel stack in that case.  I'll cook something up.

    J
