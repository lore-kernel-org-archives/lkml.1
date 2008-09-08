Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbYIHKbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbYIHKbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 06:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYIHKbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 06:31:32 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:33350 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYIHKbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 06:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=n8yNRg7NBhXtWbXEcj4kxK4FYMiQmrrWpLGtc6lwKDoZDCVpAe5unbQD9bduBEFOpX
         ykjsIGfAoOy7HQun3Lg7LD86ZLYcpU+SNcyZNhpgaIdZ8qVpE+i/UWO9foBRPn7uJ4vJ
         j+PwsC1qgf+74r1CdN+oRSur+XWFmTYg1y+mg=
Message-ID: <48C4FEFA.6070809@gmail.com>
Date: Mon, 08 Sep 2008 18:31:22 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
References: <48BFCECE.90103@gmail.com> <48C4A0FF.8070705@gmail.com> <ee6a1e220809080251h4f8b1d1bnbc7af37f31cd2834@mail.gmail.com> <48C4FECF.2000708@gmail.com>
In-Reply-To: <48C4FECF.2000708@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Yu 写道:
> hamidreza jahanjou 写道:
>> 2008/9/8, Li Yu <raise.sail@gmail.com>:
>>   
>>> And the linear searching for whole address space of a vma is not good
>>> idea too, really.
>>>
>>>     
>>>> +	    if (!page_allowed_in_cluster(cursor_page, ci))
>>>> +		continue;
>>>>
>>>>       
>>
>> Thank you for the review and comments. You are right in that searching
>> the whole process address space is not a good idea. The idea is to
>> make the scan range flexible, thus normally, assuming that the code
>> has been well-tuned, only a very limited number of VMA's are scanned.
>>
>> In general, i think that the cluster size and the scan range should be
>> tuned depending on the backing storage characteristics and the
>> low-on-memory severity. Like any VM code, this one needs tuning.
>>
>> BTW, the code could be implemented much more elegantly if the VMA's
>> were connected using a doubly-linked list. I wonder if there are
>> enought other codes with the same situation to justify making it
>> doubly-linked.
>>   
>
> You are welcome!
>
> I think that scanning one vma each task is enough.
>
> The goal of swapoutclustering is to reduce disk heads movement while 
> swapping in, it is based on space/time locality. I think that 
> different vmas implied different using pattern, which also means they 
> have different in  program locality. Therefore, I think scanning multi 
> vmas per task is not a good idea.
>
> Maybe, we need a page cache searching like for anonymous mapping 
> instead of *linear*  searching in each vma.
>
> I also have an uncompleted implementation for this feature ^_^
>
> Good luck.
>

