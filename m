Return-Path: <linux-kernel-owner+w=401wt.eu-S934924AbZLGJ4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934924AbZLGJ4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934860AbZLGJ4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:56:49 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:39146 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934756AbZLGJ4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:56:48 -0500
X-Greylist: delayed 1514 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2009 04:56:48 EST
Message-Id: <200912070929.AA01196@capsicum.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Mon, 07 Dec 2009 18:29:34 +0900
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com,
       tytso@mit.edu
Subject: Re: + task_struct-make-journal_info-conditional.patch added to -mm
 tree
In-Reply-To: <4B1C6856.4060207@ct.jp.nec.com>
References: <4B1C6856.4060207@ct.jp.nec.com>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Alexey Dobriyan wrote:
>> On Fri, Dec 04, 2009 at 12:58:06PM +0900, Hiroshi Shimamoto wrote:
>>> Alexey Dobriyan wrote:
>>>> On Thu, Dec 03, 2009 at 02:40:57PM -0800, akpm@linux-foundation.org wrote:
>>>>> --- a/include/linux/sched.h~task_struct-make-journal_info-conditional
>>>>> +++ a/include/linux/sched.h
>>>>> @@ -1452,8 +1452,10 @@ struct task_struct {
>>>>>  	gfp_t lockdep_reclaim_gfp;
>>>>>  #endif
>>>>>  
>>>>> +#ifdef CONFIG_FS_JOURNAL_INFO
>>>>>  /* journalling filesystem info */
>>>>>  	void *journal_info;
>>>>> +#endif
>>>> This will prevent using e.g. ext3 on CONFIG_EXT3_FS=n kernels.
>>> I'm sorry, I'm not sure what you're mentioning.
>> 
>> With this patch admin must decide in advance if he will ever use ext3.
>> EXT3_FS=n kernels won't be able to get ext3 support without reboot
>> even as module, because task_struct will be different.
>
>I see, you want to keep this field for future use even if EXT3_FS=n.
>I think, however, there might be a need to remove this because the user
>never enable any journaling filesystem.

Do you have some background to remove the "void *" from task_struct?
You need it for embedded purpose?

Ryusuke Konishi
