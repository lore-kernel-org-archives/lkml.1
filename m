Return-Path: <linux-kernel-owner+w=401wt.eu-S1751021AbXBNI4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021AbXBNI4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXBNI4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:56:10 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:54265
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbXBNI4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:56:10 -0500
Message-Id: <45D2DCB9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Wed, 14 Feb 2007 08:56:09 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <virtualization@lists.osdl.org>, <xen-devel@lists.xensource.com>,
       "Andi Kleen" <ak@muc.de>, "Andrew Morton" <akpm@osdl.org>,
       "Chris Wright" <chrisw@sous-sol.org>, <linux-kernel@vger.kernel.org>,
       "Zachary Amsden" <zach@vmware.com>
Subject: [Xen-devel] Re: [patch 16/21] Xen-paravirt: Add code into
	head.S to handle being booted by Xen
References: <20070213221729.772002682@goop.org>
 <20070213221830.707197267@goop.org> <20070213235424.GA1908@muc.de>
 <45D25A56.1000706@goop.org>
In-Reply-To: <45D25A56.1000706@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> @@ -528,7 +532,7 @@ ENTRY(_stext)
>>>  /*
>>>   * BSS section
>>>   */
>>> -.section ".bss.page_aligned","w"
>>> +.section ".bss.page_aligned"
>>>     
>>
>> Why? 
>>   
>
>I got complaints about section attribute mismatches without it.

Then perhaps ... "aw" is meant?

>>> +fastcall unsigned long long xen_pgd_val(pgd_t pgd)
>>> +{
>>> +	unsigned long long ret = pgd.pgd;
>>> +	if (ret)
>>> +		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
>>>     
>>
>> Why can they be 0 here anyways?
>>
>> Normally they are all considered undefined when not present
>>   
>
>Not sure.

This should probably get sync-ed up with the page table handling changes
submitted to xen-devel yesterday. Using zero/non-zero tests in contexts
like this was always broken; should check for _PAGE_PRESENT.

Jan
