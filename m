Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755Ab0AKC65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab0AKC65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 21:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179Ab0AKC65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 21:58:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58653 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab0AKC64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 21:58:56 -0500
Message-ID: <4B4A92C7.10303@cn.fujitsu.com>
Date: Mon, 11 Jan 2010 10:53:59 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>, Corrado Zoccolo <czoccolo@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com> <20100111014730.GA22362@sli10-desk.sh.intel.com>
In-Reply-To: <20100111014730.GA22362@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> On Sat, Jan 09, 2010 at 11:59:17PM +0800, Corrado Zoccolo wrote:
>> Current seeky detection is based on average seek lenght.
>> This is suboptimal, since the average will not distinguish between:
>> * a process doing medium sized seeks
>> * a process doing some sequential requests interleaved with larger seeks
>> and even a medium seek can take lot of time, if the requested sector
>> happens to be behind the disk head in the rotation (50% probability).
>>
>> Therefore, we change the seeky queue detection to work as follows:
>> * each request can be classified as sequential if it is very close to
>>   the current head position, i.e. it is likely in the disk cache (disks
>>   usually read more data than requested, and put it in cache for
>>   subsequent reads). Otherwise, the request is classified as seeky.
>> * an history window of the last 32 requests is kept, storing the
>>   classification result.
>> * A queue is marked as seeky if more than 1/8 of the last 32 requests
>>   were seeky.
>>
>> This patch fixes a regression reported by Yanmin, on mmap 64k random
>> reads.
> Can we not count a big request (say the request data is >= 32k) as seeky
> regardless the seek distance? In this way we can also make a 64k random sync
> read not as seeky.

  Or maybe we can rely on *dynamic* CFQQ_SEEK_THR in terms of data lenght to 
  determine whether a request should be a seeky one.

> 
> Thanks,
> Shaohua
> 
> 
> 

-- 
Regards
Gui Jianfeng

