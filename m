Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbZKYRBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbZKYRBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZKYRBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:01:09 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46782 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZKYRBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=G4fjH60unO8LZpTyB9QzFnaXKFL/4ErX0sOB7DZuDrH3MUAbNEEHKEvwG/Mo7CdUVl
         uCoY+udPOoIHfT/zBF1RQ4UJw/vMSDeH2zTNKo5g//yVWS1UBTJVL8r3kTXLVvvHgWje
         2gOm9q5FOYsae3SVmwUOI/OUM8egHj+Z/Lk8A=
Message-ID: <4B0D62D3.8020707@tuffmail.co.uk>
Date: Wed, 25 Nov 2009 17:01:07 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Alex Chiang <achiang@hp.com>,
       Tony Luck <tony.luck@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Mike Frysinger <vapier.adi@gmail.com>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the
 kernel (__ksymtab)
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>	 <4B072E31.4000906@tuffmail.co.uk> <20091123195320.GD26810@ldl.fc.hp.com>	 <200911241127.18013.rusty@rustcorp.com.au>	 <1259041182.2433.945.camel@mulgrave.site> <4B0BA725.2050604@tuffmail.co.uk>	 <1259102629.4549.842.camel@mulgrave.site> <4B0CF5A6.7080908@tuffmail.co.uk> <1259161737.2535.6.camel@mulgrave.site>
In-Reply-To: <1259161737.2535.6.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-11-25 at 09:15 +0000, Alan Jenkins wrote:
>   
>> James Bottomley wrote:
>>     
>>> On Tue, 2009-11-24 at 09:28 +0000, Alan Jenkins wrote:
>>>   
>>>       
>>>> James Bottomley wrote:
>>>>     
>>>>         
>>>>> On Tue, 2009-11-24 at 11:27 +1030, Rusty Russell wrote:
>>>>>   
>>>>>       
>>>>>           
>>>>>> On Tue, 24 Nov 2009 06:23:20 am Alex Chiang wrote:
>>>>>>     
>>>>>>         
>>>>>>             
>>>>>>> Hi Alan, Rusty,
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>> Hi Alex,
>>>>>>
>>>>>>     
>>>>>>         
>>>>>>             
>>>>>>> In the meantime, while Alan is deciding the proper way to fix
>>>>>>> this, would it be possible to drop the offending patch series
>>>>>>> from linux-next?
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>> Done.  That takes the pressure off Alan, and makes sure he has time to get
>>>>>> it right.
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> That probably suits us on parisc too.  I just checked out our build in
>>>>> linux-next: we don't pass __modpost ... it looks like we have all the
>>>>> module symbols undefined.  Will investigate more.
>>>>>
>>>>> James
>>>>>   
>>>>>       
>>>>>           
>>>> I think parisc wants P'printk where ia64 uses @fptr(printk).
>>>>
>>>> It may also need ".import printk,code" or similar.
>>>>     
>>>>         
>>> I think if you have to make modpost architecture specific, there's
>>> something a bit wrong in the patch series.
>>>
>>> I can confirm that reverting this particular patch allows the parisc
>>> build to work again.  It still won't boot because module symbols aren't
>>> resolved.
>>>
>>> James
>>>   
>>>       
>> Yes, the series as a whole relies on that patch.  Rusty pulled the 
>> series from linux-next (thanks rusty!).
>>     
>
> Not according to current linux-next:
>
> jejb@ion> git log next-20091125|grep -3 'sort the list of symbols'
> Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date:   Sat Nov 7 21:03:56 2009 +0000
>
>     kbuild: sort the list of symbols exported by the kernel (__ksymtab)
>     
>     modpost of vmlinux.o now extracts the ksymtab sections and outputs
>     sorted versions of them as .tmp_exports-asm.S.  These sorted sections
>
> Could we please have this removed so we can resume our testing of next?
>   

Note to Rusty: the patches which depend on this are

"module: speed up find_symbol() using binary search on the builtin 
symbol tables"

and

"modpost: fix modules on ia64 - use @fptr() on exported function symbols"

(the second one needs to be rewritten anyway, because -

> We don't need there to be no arch changes ... but we do need any arch
> specificity confined to arch specific files.
>
> James
>   

