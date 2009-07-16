Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbZGPAuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbZGPAuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 20:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZGPAuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 20:50:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbZGPAuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 20:50:19 -0400
Message-ID: <4A5E78EA.60903@cn.fujitsu.com>
Date: Thu, 16 Jul 2009 08:48:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: event tracing, ringbuffer and RB_MAX_SMALL_DATA
References: <1247591891.7178.20.camel@johannes.local>	 <4A5D2BF6.6010802@cn.fujitsu.com> <1247651305.14973.3.camel@johannes.local>
In-Reply-To: <1247651305.14973.3.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> On Wed, 2009-07-15 at 09:08 +0800, Li Zefan wrote:
> 
>> Right, the length of a dynamic array is not recorded, and this
>> causes 2 problems:
>>
>> - the event filter is not working properly for dynamic strings
>> - userspace parsers can't figure out the length of those arrays
>>
>> I had an idea some time ago, and hopefully will send out a
>> patch today or tomorrow. 
> 
> Well except for the corner case I pointed out, you can determine the
> length of dynamic arrays by either
>  - the next dynamic array's offset or
>  - the length of the item.
> 
> So, afaict, the simplest solution would be to not embed the length of
> the item in type_len if it's not divisible by four and contains dynamic
> members, though the latter condition might be hard to check.
> 

Actually I'm going to encode the size of a dynamic array
in it's @offset, so the lower 16bits is offset and the
higher 16bits is size.

