Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZHGD0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZHGD0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 23:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZHGD0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 23:26:00 -0400
Received: from [222.73.24.84] ([222.73.24.84]:55464 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZHGD0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 23:26:00 -0400
Message-ID: <4A7B9E6B.2090202@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 11:24:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/filters: Support filtering for char * strings
References: <4A7A72BD.5030201@cn.fujitsu.com> <4A7A72FA.9040102@cn.fujitsu.com> <alpine.DEB.2.00.0908061020240.9870@gandalf.stny.rr.com> <4A7B8149.3070901@cn.fujitsu.com> <alpine.DEB.2.00.0908062251230.2840@gandalf.stny.rr.com> <4A7B9BB5.3040005@cn.fujitsu.com> <alpine.DEB.2.00.0908062321420.2840@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908062321420.2840@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 7 Aug 2009, Li Zefan wrote:
>>> What protection is this giving us?
>>>
>> __field(char *) suggests it should be treated as plain pointer,
>> while __field_ext(char *, FILTER_PTR_STR) suggests he's aware it's
>> safe to dereference the pointer, for example the case in Frederic's
>> blk events.
>>
>> In Frederic's initial version, "char *" field will always be
>> attached to ptr_str filter function. This is unsafe, because for
>> other fields defined as "char *" but not safe to dereference,
>> a user still can do this:
>>
>> 	# echo 'name == abc' > filter
>>
>> Then we'll deref a pointer that can point to unsafe data.
>>
>> In this patch, this won't happen, as long as the developer is
>> aware that his use of __field_ext(char *) is right.
>>
>> Otherwise, he will just use normal __field(char *) and print
>> the pointer itself in TP_printk().
> 
> Ah, so the answer I'm looking for is:
> 
> The filtering will not dereference "char *" unless the developer 
> explicitly sets FILTER_PTR_STR in __field_ext.
> 
> Is this above statement correct?
> 

Exactly. Sorry that I didn't explain it clearly in the
first place. :)

