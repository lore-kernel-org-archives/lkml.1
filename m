Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZDVDFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZDVDFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 23:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZDVDFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 23:05:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59866 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZDVDFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 23:05:24 -0400
Message-ID: <49EE895A.1060101@cn.fujitsu.com>
Date: Wed, 22 Apr 2009 11:04:58 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [RFC] IO Controller
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <49DF1256.7080403@cn.fujitsu.com> <20090413130958.GB18007@redhat.com>
In-Reply-To: <20090413130958.GB18007@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Apr 10, 2009 at 05:33:10PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> Hi All,
>>>
>>> Here is another posting for IO controller patches. Last time I had posted
>>> RFC patches for an IO controller which did bio control per cgroup.
>>   Hi Vivek,
>>
>>   I got the following OOPS when testing, can't reproduce again :(
>>
> 
> Hi Gui,
> 
> Thanks for the report. Will look into it and see if I can reproduce it.

  Hi Vivek,

  The following script can reproduce the bug in my box.

#!/bin/sh

mkdir /cgroup
mount -t cgroup -o io io /cgroup
mkdir /cgroup/test1
mkdir /cgroup/test2

echo cfq > /sys/block/sda/queue/scheduler
echo 7 > /cgroup/test1/io.ioprio
echo 1 > /cgroup/test2/io.ioprio
echo 1 > /proc/sys/vm/drop_caches
dd if=1000M.1 of=/dev/null &
pid1=$!
echo $pid1
echo $pid1 > /cgroup/test1/tasks
dd if=1000M.2 of=/dev/null
pid2=$!
echo $pid2
echo $pid2 > /cgroup/test2/tasks


rmdir /cgroup/test1
rmdir /cgroup/test2
umount /cgroup
rmdir /cgroup

-- 
Regards
Gui Jianfeng



