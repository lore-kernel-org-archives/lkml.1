Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbZFVDOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbZFVDOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 23:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbZFVDOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 23:14:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58034 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZFVDOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 23:14:14 -0400
Message-ID: <4A3EF769.1090609@cn.fujitsu.com>
Date: Mon, 22 Jun 2009 11:15:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Wang Liming <liming.wang@windriver.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: don't increment @pos in g_start()
References: <4A3B347B.8090904@cn.fujitsu.com> <1245401968-25235-1-git-send-email-liming.wang@windriver.com> <4A3B5E40.8040607@cn.fujitsu.com> <4A3ED40E.6030303@cn.fujitsu.com> <4A3EEF9E.2020301@windriver.com>
In-Reply-To: <4A3EEF9E.2020301@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang Liming wrote:
> Li Zefan wrote:
>> Li Zefan wrote:
>>> Liming Wang wrote:
>>>> how about this one?
>>>>
>>> Yeah, this should work, and cleaner than my version.
>>>
>>
>> Hmmm, the patch is cleaner in diffstat but the resulted code
>> isn't..
>>
>> After yours:
>>    text    data     bss     dec     hex filename
>>   14879    5480    4240   24599    6017 kernel/trace/ftrace.o
>>
>> After mine:
>>    text    data     bss     dec     hex filename
>>   14873    5480    4240   24593    6011 kernel/trace/ftrace.o
> Hmmm, if you prefer to smaller target size, I don't care.
> But in my system, I got the same size:
> 
>   text    data     bss     dec     hex filename
>   14330    5019     104   19453    4bfd kernel/trace/ftrace.o
> 
> I use objdump to compute the actual size of all modified functions:
> 
> After mine:
> func    size
> g_start 0x50
> g_next  0x70
> 
> After yours:
> func     size
> __g_next 0x70
> g_next   0x20
> g_start  0x30
> 
> I used Steve git tree and commit e482f8395f215e0ad6557b2722cd9b9b308035c4.
> My gcc version is :
> gcc version 4.2.4
> 
> I don't know where the difference.
> 

Maybe because of different gcc versions:

# gcc --version
gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)

The point is, I don't see how the patch you posted is better than
mine. And it's fine for me to pick up yours if it's indeed better.
