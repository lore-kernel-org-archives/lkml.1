Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbZG2JJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbZG2JJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 05:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZG2JJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 05:09:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49826 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZG2JJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 05:09:00 -0400
Message-ID: <4A701155.4060908@cn.fujitsu.com>
Date: Wed, 29 Jul 2009 17:07:33 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [RFC] IO scheduler based IO controller V6
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <4A6D0C9A.3080600@cn.fujitsu.com> <20090727125503.GA24449@redhat.com>
In-Reply-To: <20090727125503.GA24449@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Jul 27, 2009 at 10:10:34AM +0800, Gui Jianfeng wrote:
>> Hi，
>>
>> Here are some fio test results for IO Controller V6 built and not built.
>> Iozone test results are also attached.
>>
> 
> Hi Gui,
> 
> Thanks a lot for some performance numbers. It seems to be a mixed chart.
> Performance gains at some places and loss at others. I am curious about
> that -7.0% for normal writes. Not sure what can contribute to that.
> 
> What was the value of "fairness" parameter when you ran those tests? Can you
> please set fairness = 0 and re-run the tests (if you have already not done so).
> 
> By default fairness is set to 1 in V6. With fairness = 0, we should be very
> close to existing CFQ behavior. If not, then we need to dive deeper and
> see why variations are happening.

  Hi Vivek,

  I re-run the fio test under V6 for normal reads and writes with fairness == 0.
  It seems the performance gets a little better for normal writes than before.
  

  Mode                    Normal read   |   Random read   |   Normal write   |   Random write

  2.6.31-rc1              53,547KiB/s       2,894KiB/s        44,088KiB/s        8,450KiB/s

  V6(fairness = 0)        53,199KiB/s       2,847KiB/s        41,898KiB/s        8,582KiB/s

  Performance		  0%		    -1.6%             -4.9%		 +1.5%

> 
> Is it also possible to run the same tests with V7. 
> 
> Thanks
> Vivek
> 
>> Arch: X86
>> Mem:  1G
>> Disk: 320G
>> IO Scheduler: CFQ
>>
>> ============
>> By normal read and write syscall.
>>
>> Block Size:32K
>> File Size: 1G * 10
>>
>> Mode                    Normal read   |   Random read   |   Normal write   |   Random write | Direct read | Direct write
>>
>> 2.6.31-rc1              47,932KiB/s       3,566KiB/s        45,693KiB/s        8,501KiB/s     50,088KiB/s   43,473KiB/s
>>
>> 2.6.31-rc1-Vivek-V6     47,231KiB/s       3,411KiB/s        42,451KiB/s        8,714KiB/s     51,284KiB/s   42,341KiB/s
>>
>> Performance             -1.5%             -4.4%             -7.0%              +2.5%          +2.4%         -2.6%
>>
>> ============
>>
>> By mmap.
>>
>> Block Size:32K
>> File Size: 500M
>>
>> Mode                    Normal read   |   Random read   |   Normal write   |   Random write
>>
>> 2.6.31-rc1              49,951KiB/s       3,245KiB/s        21,950KiB/s        2,771KiB/s
>>
>> 2.6.31-rc1-Vivek-V6     49,951KiB/s       3,154KiB/s        22,593KiB/s        2,648KiB/s
>>
>> Performance             0%                -2.8%             +2.9%              -4.4%
>>
>> ============
>>  
>> By libaio calls
>>
>> Block Size:32K
>> File Size: 500M
>>
>> Mode                    Normal read   |  Random read   |   Normal write   |   Random write
>>
>> 2.6.31-rc1              49,447KiB/s       3,296KiB/s        57,519KiB/s        21,093KiB/s
>>
>> 2.6.31-rc1-Vivek-V6     50,142KiB/s       3,238KiB/s        57,791KiB/s        21,283KiB/s
>>
>> Performance             +1.4%             -1.8%             0%                 +0.1%
>>
>> ============
>>
>>
>>
>>
>>
>>
>>
>>
>>
>>
>>
> 
> 
> 
> 
> 
> 

-- 
Regards
Gui Jianfeng


