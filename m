Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZIKHzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZIKHzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZIKHzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:55:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61283 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbZIKHzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:55:53 -0400
Message-ID: <4AAA025F.4000001@cn.fujitsu.com>
Date: Fri, 11 Sep 2009 15:55:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Xiao Guangrong <ericxiao.gr@gmail.com>,
       "jirislaby@gmail.com" <jirislaby@gmail.com>,
       "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "npiggin@suse.de" <npiggin@suse.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: [-mm] warning during suspend [was: suspend race -mm regression]
References: <1249980093-16319-1-git-send-email-jirislaby@gmail.com>	 <4A81E073.5080703@gmail.com>	<4A9B9C1C.9020506@gmail.com>	 <200908312132.10904.rjw@sisk.pl>	<4AA0FEBF.7040104@gmail.com>	 <4AA19520.3070708@gmail.com>	<4AA19668.5080909@gmail.com>	 <4AA25C11.9050209@gmail.com>	<4AA278A1.2090107@gmail.com>	 <20090910135745.61de2be6.akpm@linux-foundation.org> <1252627221.2816.9.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1252627221.2816.9.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Suresh Siddha wrote:
> On Thu, 2009-09-10 at 13:57 -0700, Andrew Morton wrote:
>> On Sat, 05 Sep 2009 22:41:37 +0800
>> Xiao Guangrong <ericxiao.gr@gmail.com> wrote:
>>
>>> Jiri Slaby ______:
>>>> On 09/05/2009 12:36 AM, Jiri Slaby wrote:
>>>>> On 09/05/2009 12:30 AM, Jiri Slaby wrote:
>>>>>> WARNING: at kernel/smp.c:124
>>>>>> __generic_smp_call_function_interrupt+0xfd/0x110()
>>>>>> Hardware name: To Be Filled By O.E.M.
>>>>>> Modules linked in: nfs lockd auth_rpcgss sunrpc ath5k ath
>>>>>> Pid: 3423, comm: pm-suspend Not tainted 2.6.31-rc8-mm1_64 #762
>>>>>> Call Trace:
>>>>>>  [<ffffffff8103fc48>] warn_slowpath_common+0x78/0xb0
>>>>>>  [<ffffffff8103fc8f>] warn_slowpath_null+0xf/0x20
>>>>>>  [<ffffffff8106950d>] __generic_smp_call_function_interrupt+0xfd/0x110
>>>>>>  [<ffffffff8106956a>] hotplug_cfd+0x4a/0xa0
>>>>>>  [<ffffffff81434e47>] notifier_call_chain+0x47/0x90
>>>>>>  [<ffffffff8105b311>] raw_notifier_call_chain+0x11/0x20
>>>>>>  [<ffffffff8141ece0>] _cpu_down+0x150/0x2d0
>>>>> It's the CPU_DEAD notifier:
>>>>> ffffffff8141ecd0:       48 83 ce 07             or     $0x7,%rsi
>>>>> ffffffff8141ecd4:       48 c7 c7 08 ff 5d 81    mov
>>>>> $0xffffffff815dff08,%rdi
>>>>> ffffffff8141ecdb:       e8 20 c6 c3 ff          callq  ffffffff8105b300
>>>>> <raw_notifier_call_chain>
>>>>> ffffffff8141ece0:       3d 02 80 00 00          cmp    $0x8002,%eax
>>>> And it's due to:
>>>> generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
>>>>
>>> I think it has collision between my patch and below patch:
> 
> Xiao, I am not sure if the race that you are trying to fix here indeed
> exists. Doesn't the stop machine that we do as part of cpu down address
> and avoid the race that you mention? Have you seen any real crashes and
> hangs or is it theory?
> 

Suresh, please see my explanation in another mail, see below URL:
http://marc.info/?l=linux-kernel&m=125265516529139&w=2

Thanks,
Xiao
