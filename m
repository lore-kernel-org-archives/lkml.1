Return-Path: <linux-kernel-owner+w=401wt.eu-S1946007AbXBPQno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946007AbXBPQno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946004AbXBPQnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:43:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:45278 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003AbXBPQnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:43:42 -0500
From: Andreas Schwab <schwab@suse.de>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Vignesh Babu BM <vignesh.babu@wipro.com>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>,
       linux-mm@kvack.org, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ] [PATCH] is_power_of_2 in ia64mm
References: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe>
	<45D5C789.1090607@student.ltu.se> <jeire2nnik.fsf@sykes.suse.de>
	<45D5D47F.3000303@student.ltu.se> <je3b56nlds.fsf@sykes.suse.de>
	<45D5DE6F.6030604@student.ltu.se>
X-Yow: Here is my refrigerator full of FLANK STEAK...and over there is my
 UPHOLSTERED CANOE...I don't know WHY I OWN them!!
Date: Fri, 16 Feb 2007 17:43:32 +0100
In-Reply-To: <45D5DE6F.6030604@student.ltu.se> (Richard Knutsson's message of
	"Fri, 16 Feb 2007 17:40:15 +0100")
Message-ID: <jeps8am4sr.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Knutsson <ricknu-0@student.ltu.se> writes:

> Andreas Schwab wrote:
>> Richard Knutsson <ricknu-0@student.ltu.se> writes:
>>   
>>> Andreas Schwab wrote:
>>>     
>>>> Richard Knutsson <ricknu-0@student.ltu.se> writes:
>>>>         
>>>>> Vignesh Babu BM wrote:
>>>>>         
>>>>>> @@ -175,7 +176,7 @@ static int __init hugetlb_setup_sz(char *str)
>>>>>>  		tr_pages = 0x15557000UL;
>>>>>>   	size = memparse(str, &str);
>>>>>> -	if (*str || (size & (size-1)) || !(tr_pages & size) ||
>>>>>> +	if (*str || !is_power_of_2(size) || !(tr_pages & size) ||
>>>>>>  		size <= PAGE_SIZE ||
>>>>>>  		size >= (1UL << PAGE_SHIFT << MAX_ORDER)) {
>>>>>>  		printk(KERN_WARNING "Invalid huge page size specified\n");
>>>>>>           
>>>>> As we talked about before; is this really correct? !is_power_of_2(0) ==
>>>>> true while (0 & (0-1)) == 0.
>>>>>         
>>>> size == 0 is also covered by the next two conditions, so the overall value
>>>> does not change.
>>>>       
>>> Yes, but is it meant to state that 'size' is not a power of two?
>>>     
>>
>> What else can it mean?
>>   
> What about !one_or_less_bit()?

Obviously not.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
