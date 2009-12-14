Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbZLNBlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbZLNBlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZLNBlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:41:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54651 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZLNBlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:41:19 -0500
Message-ID: <4B2597A8.7020909@cn.fujitsu.com>
Date: Mon, 14 Dec 2009 09:40:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] tracing/filters: Fix MATCH_FULL filter matching	for
 PTR_STRING
References: <4B2217D0.5000308@cn.fujitsu.com> <4B2217EA.4010902@cn.fujitsu.com> <20091211120753.GE5244@nowhere>
In-Reply-To: <20091211120753.GE5244@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Dec 11, 2009 at 05:59:06PM +0800, Li Zefan wrote:
>> MATCH_FULL matching for PTR_STRING is not working correctly:
>>
>>   # echo 'func == vt' > events/bkl/lock_kernel/filter
>>   # echo 1 > events/bkl/lock_kernel/enable
>>   ...
>>   # cat trace
>>    Xorg-1484  [000]  1973.392586: lock_kernel: ... func=vt_ioctl()
>>     gpm-1402  [001]  1974.027740: lock_kernel: ... func=vt_ioctl()
>>
>> We should pass to regex.match(..., len) the length (including '\0')
>> of the source string instead of the length of the pattern string.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> This patch is cool but it seems to also break middle and end
> matching (at least what was working with end matching :)
> 

No, it won't, unless I miss something.

I changed what value ptr_string passes the length param to match(),
but this param is not used in match_middle and match_end.

It does break match_front for ptr_string, but that's because
the mixture of 2 bugs happened to make things right. I can
sort this out by reordering the 2 patches.

> I know you fix that in the subsequent patches, but please
> avoid that. A fix should not bring another known bug,
> event if it's fixed in the same batch.
> 
