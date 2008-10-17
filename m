Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbYJQPaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbYJQPaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYJQP34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:29:56 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:6168 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbYJQP3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:29:55 -0400
Message-Id: <48F8CBC4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 17 Oct 2008 16:30:44 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "Chris Lalancette" <clalance@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH]: Fix Xen domU boot with batched			
	 mprotect
References: <48F5CE10.3060403@redhat.com> <48F6274D.76E4.0078.0@novell.com>
 <48F61919.2050005@goop.org> <48F72C7A.76E4.0078.0@novell.com>
 <48F76773.2090700@goop.org> <48F85711.76E4.0078.0@novell.com>
 <48F8ACF7.6050905@goop.org>
In-Reply-To: <48F8ACF7.6050905@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 17.10.08 17:19 >>>
>Jan Beulich wrote:
>>>>> Jeremy Fitzhardinge <jeremy@goop.org> 16.10.08 18:10 >>>
>>>>>         
>>> The current x86-64 implementation is:
>>>
>>> bool __virt_addr_valid(unsigned long x)
>>> {
>>> 	if (x >= __START_KERNEL_map) {
>>> 		x -= __START_KERNEL_map;
>>> 		if (x >= KERNEL_IMAGE_SIZE)
>>> 			return false;
>>>     
>>
>> This, imo, is still broken (i.e. the name of the function still isn't matched
>> by the implementation): KERNEL_IMAGE_SIZE is a constant and doesn't
>> account for the fact that only the real kernel image can be relied upon
>> to be mapped.
>>   
>
>Perhaps, but I don't think it matters too much.  Unless you have a tiny 
>amount of physical memory, locations in the kernel mapping beyond the 
>actual kernel will still resolve to proper locations in the linear map.

Is e.g. 256Mb tiny? KERNEL_IMAGE_SIZE these days is 512Mb... Indeed,
when it was 40Mb (up until a few releases ago), this indeed wouldn't
matter.

Jan

