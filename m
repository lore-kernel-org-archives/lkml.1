Return-Path: <linux-kernel-owner+w=401wt.eu-S940685AbXGaDpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940685AbXGaDpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935807AbXGaDp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:45:27 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50485 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933329AbXGaDpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:45:25 -0400
Message-ID: <46AEB055.9050607@us.ibm.com>
Date: Mon, 30 Jul 2007 20:45:25 -0700
From: Badari <pbadari@us.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Joe Jin <joe.jin@oracle.com>
CC: Zach Brown <zach.brown@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
Subject: Re: [PATCH] add check do_direct_IO() return val
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com> <20070726221307.3d7b3446.akpm@linux-foundation.org> <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com> <20070728034719.GA24448@joejin-pc.cn.oracle.com> <20070730135316.2ce21b28.akpm@linux-foundation.org> <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com> <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com> <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com> <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com> <20070731005348.GA8308@joejin-pc.cn.oracle.com>
In-Reply-To: <20070731005348.GA8308@joejin-pc.cn.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Jin wrote:
>> Well, I'm having a heck of a time getting this to fail.  It looks  
>> possible, though.  Joe, were you guys able to narrow it down to a  
>> reproducible test case?  Do you have any oops output messages from  
>> the crashes?
>>     
>
> Zach, it easy to reproduce through fio with following config file
>
> # cat jobfile
> [global]
> bs=8k
> iodepth=1024
> iodepth_batch=60
> randrepeat=1
> size=1m
> directory=/home/oracle
> numjobs=20
> [job1]
> 	ioengine=sync
> 	bs=1k
> 	direct=1
> 	rw=randread
> 	filename=file1:file2
> [job2]
> 	ioengine=libaio
> 	rw=randwrite
> 	direct=1
> 	filename=file1:file2
> [job3]
> 	bs=1k
> 	ioengine=posixaio
> 	rw=randwrite
> 	direct=1
> 	filename=file1:file2
> [job4]
> 	ioengine=splice
> 	direct=1
> 	rw=randwrite
> 	filename=file1:file2
> [job5]
> 	bs=1k
> 	ioengine=sync
> 	rw=randread
> 	filename=file1:file2
> [job7]
> 	ioengine=libaio
> 	rw=randwrite
> 	filename=file1:file2
> [job8]
> 	ioengine=posixaio
> 	rw=randwrite
> 	filename=file1:file2
> [job9]
> 	ioengine=splice
> 	rw=randwrite
> 	filename=file1:file2
> [job10]
> 	ioengine=mmap
> 	rw=randwrite
> 	bs=1k
> 	filename=file1:file2
> [job11]
> 	ioengine=mmap
> 	rw=randwrite
> 	direct=1
> 	filename=file1:file2 
>
>   
Hmm.. in this config file, whats causing DIO to panic ? Which test actually
passing faulty buffer ?

Thanks,
Badari
