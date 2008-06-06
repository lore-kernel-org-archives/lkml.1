Return-Path: <linux-kernel-owner+w=401wt.eu-S1762248AbYFFINl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762248AbYFFINl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYFFINY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:13:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16161 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYFFINX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:13:23 -0400
Message-Id: <48490DEC.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 06 Jun 2008 09:14:04 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Stable Kernel" <stable@kernel.org>, <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
References: <4848046A.5060006@goop.org> <87ve0ntk6v.fsf@basil.nowhere.org>
 <4848EE5C.6040003@goop.org>
In-Reply-To: <4848EE5C.6040003@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 06.06.08 09:59 >>>
>Andi Kleen wrote:
>> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>>   
>>> The 46-bit mask used in 64-bit seems pretty arbitrary. 
>>>     
>>
>> The rationale for the 46 bits is that the kernel needs roughly 4x as 
>> much virtual space as physical space and the virtual space is limited
>> to 48bits.
>>
>> To be exact 47 bits is always user space and the 47 bits remaining
>> for the kernel are split into half, with one half for the direct mapping
>> and the other half for random mappings.  With some pushing you could
>> extend it to 46.5 bits or so, but beyond that you'll be in trouble.
>>   
>
>Why's that?  Is the issue the amount of memory needed for pagetables and 
>page structures if you did have more than 2^48 bytes of physical memory?

No, it's the fact that the 1:1 mapping needs as much virtual space as
the physical range covered (including all holes).

Jan

