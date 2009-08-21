Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZHUA6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZHUA6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZHUA6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:58:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbZHUA6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:58:15 -0400
Message-ID: <4A8DF0F7.6070100@cn.fujitsu.com>
Date: Fri, 21 Aug 2009 08:57:27 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
Subject: Re: [PATCH] IO-Controller: clear ioq wait flag if a request goes
 into that ioq
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-12-git-send-email-vgoyal@redhat.com> <4A8CAAE2.1030804@cn.fujitsu.com> <20090820134221.GC10615@redhat.com>
In-Reply-To: <20090820134221.GC10615@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Aug 20, 2009 at 09:46:10AM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>> ...
>>>  		/*
>>>  		 * Remember that we saw a request from this process, but
>>> @@ -1940,7 +2013,7 @@ void elv_ioq_request_add(struct request_queue *q, struct request *rq)
>>>  		 * has other work pending, don't risk delaying until the
>>>  		 * idle timer unplug to continue working.
>>>  		 */
>>> -		if (elv_ioq_wait_request(ioq)) {
>>> +		if (group_wait || elv_ioq_wait_request(ioq)) {
>> Hi Vivek,
>>
>> I guess we need to clear ioq_wait_request flags if there are requests to 
>> go in this ioq. Otherwise, once waitting request on ioq, it will go into
>> this path every time when a request is enqueued.
>>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> 
> Hi Gui,
> 
> It does sound like that we need to clear ioq wait_request flag here. In
> fact upstream CFQ code is also not clearing this flag. Looking at the
> code, can't think why it should not be cleared here.
> 
> Can you please also generate a patch for CFQ and post to lkml.
> 

Sure, will do.

-- 
Regards
Gui Jianfeng

