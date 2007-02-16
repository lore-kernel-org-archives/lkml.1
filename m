Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbXBPP6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbXBPP6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932438AbXBPP6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:58:10 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:52661 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431AbXBPP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:58:08 -0500
Message-ID: <45D5D47F.3000303@student.ltu.se>
Date: Fri, 16 Feb 2007 16:57:51 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: Vignesh Babu BM <vignesh.babu@wipro.com>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>,
       linux-mm@kvack.org, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ] [PATCH] is_power_of_2 in ia64mm
References: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe>	<45D5C789.1090607@student.ltu.se> <jeire2nnik.fsf@sykes.suse.de>
In-Reply-To: <jeire2nnik.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Richard Knutsson <ricknu-0@student.ltu.se> writes:
>
>   
>> Vignesh Babu BM wrote:
>>     
>>> @@ -175,7 +176,7 @@ static int __init hugetlb_setup_sz(char *str)
>>>  		tr_pages = 0x15557000UL;
>>>   	size = memparse(str, &str);
>>> -	if (*str || (size & (size-1)) || !(tr_pages & size) ||
>>> +	if (*str || !is_power_of_2(size) || !(tr_pages & size) ||
>>>  		size <= PAGE_SIZE ||
>>>  		size >= (1UL << PAGE_SHIFT << MAX_ORDER)) {
>>>  		printk(KERN_WARNING "Invalid huge page size specified\n");
>>>
>>>   
>>>       
>> As we talked about before; is this really correct? !is_power_of_2(0) ==
>> true while (0 & (0-1)) == 0.
>>     
>
> size == 0 is also covered by the next two conditions, so the overall value
> does not change.
>   
Yes, but is it meant to state that 'size' is not a power of two? 
Otherwise, imho, it should be left as-is.

Richard Knutsson

