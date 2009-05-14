Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbZENBDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbZENBDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 21:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZENBC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 21:02:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57378 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbZENBC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 21:02:58 -0400
Message-ID: <4A0B6D8D.6060202@cn.fujitsu.com>
Date: Thu, 14 May 2009 09:02:05 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH] IO Controller: Add per-device weight and ioprio_class
 handling
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A0A29B5.7030109@cn.fujitsu.com> <20090513152909.GD7696@redhat.com>
In-Reply-To: <20090513152909.GD7696@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Wed, May 13, 2009 at 10:00:21AM +0800, Gui Jianfeng wrote:
> 
> [..]
>> @@ -2137,7 +2366,7 @@ void elv_fq_unset_request_ioq(struct request_queue *q, struct request *rq)
>>  void bfq_init_entity(struct io_entity *entity, struct io_group *iog)
>>  {
>>  	entity->ioprio = entity->new_ioprio;
>> -	entity->weight = entity->new_weight;
>> +	entity->weight = entity->new_weigh;
>>  	entity->ioprio_class = entity->new_ioprio_class;
>>  	entity->sched_data = &iog->sched_data;
>>  }
>> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
>> index db3a347..0407633 100644
>> --- a/block/elevator-fq.h
>> +++ b/block/elevator-fq.h
>> @@ -253,6 +253,14 @@ struct io_group {
>>  #endif
>>  };
>>  
>> +struct policy_node {
> 
> Would "io_policy_node" be better?

  Sure

> 
>> +	struct list_head node;
>> +	char dev_name[32];
>> +	void *key;
>> +	unsigned long weight;
>> +	unsigned long ioprio_class;
>> +};
>> +
>>  /**
>>   * struct bfqio_cgroup - bfq cgroup data structure.
>>   * @css: subsystem state for bfq in the containing cgroup.
>> @@ -269,6 +277,9 @@ struct io_cgroup {
>>  
>>  	unsigned long weight, ioprio_class;
>>  
>> +	/* list of policy_node */
>> +	struct list_head list;
>> +
> 
> How about "struct list_head policy_list" or "struct list_head io_policy"?

  OK

-- 
Regards
Gui Jianfeng

