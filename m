Return-Path: <linux-kernel-owner+w=401wt.eu-S965263AbZLHAjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263AbZLHAjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965245AbZLHAje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:39:34 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61667 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965220AbZLHAjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:39:33 -0500
Message-ID: <4B1D9EAF.90906@ct.jp.nec.com>
Date: Tue, 08 Dec 2009 09:32:47 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com,
       tytso@mit.edu
Subject: Re: + task_struct-make-journal_info-conditional.patch added to -mm
 tree
References: <4B1C6856.4060207@ct.jp.nec.com> <200912070929.AA01196@capsicum.lab.ntt.co.jp>
In-Reply-To: <200912070929.AA01196@capsicum.lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryusuke Konishi wrote:
>> Alexey Dobriyan wrote:
>>> On Fri, Dec 04, 2009 at 12:58:06PM +0900, Hiroshi Shimamoto wrote:
>>>> Alexey Dobriyan wrote:
>>>>> On Thu, Dec 03, 2009 at 02:40:57PM -0800, akpm@linux-foundation.org wrote:
>>>>>> --- a/include/linux/sched.h~task_struct-make-journal_info-conditional
>>>>>> +++ a/include/linux/sched.h
>>>>>> @@ -1452,8 +1452,10 @@ struct task_struct {
>>>>>>  	gfp_t lockdep_reclaim_gfp;
>>>>>>  #endif
>>>>>>  
>>>>>> +#ifdef CONFIG_FS_JOURNAL_INFO
>>>>>>  /* journalling filesystem info */
>>>>>>  	void *journal_info;
>>>>>> +#endif
>>>>> This will prevent using e.g. ext3 on CONFIG_EXT3_FS=n kernels.
>>>> I'm sorry, I'm not sure what you're mentioning.
>>> With this patch admin must decide in advance if he will ever use ext3.
>>> EXT3_FS=n kernels won't be able to get ext3 support without reboot
>>> even as module, because task_struct will be different.
>> I see, you want to keep this field for future use even if EXT3_FS=n.
>> I think, however, there might be a need to remove this because the user
>> never enable any journaling filesystem.
> 
> Do you have some background to remove the "void *" from task_struct?
> You need it for embedded purpose?

Yeah, it's for embedded. I think it's good if there is a option to make
memory usage small.

Thanks,
Hiroshi

