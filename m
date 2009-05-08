Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbZEHPaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbZEHPaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZEHPaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:30:08 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15667 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZEHPaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:30:07 -0400
Message-Id: <4A046C3F.76EA.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 08 May 2009 16:30:39 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "the arch/x86 maintainers" <x86@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/5] xen/x86-64: clean up warnings	
	 aboutIST-usingtraps
References: <4A032EE0.9030607@goop.org> <4A03F947.76EA.0078.0@novell.com>
 <4A044E55.20803@goop.org>
In-Reply-To: <4A044E55.20803@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 08.05.09 17:23 >>>
>Jan Beulich wrote:
>>> else if (addr == (unsigned long)int3)
>>> 		addr = (unsigned long)xen_int3;
>>> -	else
>>> -		WARN_ON(val->ist != 0);
>>> +	else if (addr == (unsigned long)double_fault ||
>>> +		 addr == (unsigned long)stack_segment) {
>>>     
>>
>> I don't think you want to exclude handling stack faults: Ordinary memory
>> references using rsp or rbp as the base register will cause these instead
>> of general protection faults when the resulting effective address is non-
>> canonical.
>>   
>
>So even usermode memory accesses?  Ew.

Yes, just try it out - you'll observe them generate SIGBUS instead of SIGSEGV.

Jan

