Return-Path: <linux-kernel-owner+w=401wt.eu-S1764947AbXGLK23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764947AbXGLK23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 06:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764254AbXGLK2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 06:28:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:57165 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764108AbXGLK2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 06:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MAHiBmKoQmp4zeQQ1XLxafEbxS2HlQMlTbDLGrZIANnRmplgbBUGkTVFIzCkp7exP7s5IaFP0soWWGeW8hjlK5NPAyO85Gbi5gddypbl+ahOi8hXLoJEhKsBhUQ48DRl4VmZ44rfizbTvUjOXxLDADtBBMonvc3pH+kaQ+S2zUs=
Message-ID: <46960225.1030102@gmail.com>
Date: Thu, 12 Jul 2007 12:27:49 +0200
From: Adel Gadllah <adel.gadllah@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix sparse problems with ARRAY_SIZE
References: <4693AE32.7030403@gmail.com> <4693AF4C.8010005@gmail.com> <20070710194033.GB5751@martell.zuzino.mipt.ru> <20070710205817.GR21668@ftp.linux.org.uk> <20070710224059.GS21668@ftp.linux.org.uk>
In-Reply-To: <20070710224059.GS21668@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Jul 10, 2007 at 09:58:18PM +0100, Al Viro wrote:
>   
>> On Tue, Jul 10, 2007 at 11:40:33PM +0400, Alexey Dobriyan wrote:
>>     
>>> On Tue, Jul 10, 2007 at 06:09:48PM +0200, Adel Gadllah wrote:
>>>       
>>>> --- linux-2.6.orig/include/linux/kernel.h
>>>> +++ linux-2.6/include/linux/kernel.h
>>>> @@ -35,7 +35,11 @@ extern const char linux_proc_banner[];
>>>>  #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
>>>>  #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
>>>>  
>>>> +#ifdef __CHECKER_
>>>> +#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
>>>> +#else
>>>>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>>>> +#endif
>>>>         
>>> Al Viro recently gave a hint that he have patches for sparse to not give
>>> spurious ARRAY_SIZE warnings.
>>>       
>> I do.  Right now it's either 2 or 4 patches away from mainline sparse,
>> depending on reordering...  I'm splitting the last patch in series,
>> hopefully will reorder and send tonight.
>>
>> Basically, it's a matter of getting __builtin_compatible_types_p()
>> implementation (really - evaluate.c:type_difference()) somewhere sane.
>>     
>
> Try git://git.kernel.org/pub/scm/linux/kernel/git/viro/sparse.git/,
> the branch is type_difference
>
>   
ok a proper fix is always better than a workaround ;)
it seems that ARRAY_SIZE is defined multiple times....
seem wrong... shouldn't all users include linux/kernel.h and use that one?
