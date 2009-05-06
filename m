Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbZEFLbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbZEFLbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757721AbZEFLaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:30:52 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:34343 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbZEFLav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:30:51 -0400
Message-ID: <4A0174E4.5090002@hp.com>
Date: Wed, 06 May 2009 07:30:44 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] blktrace: correct remap names
References: <20090430133627.D217.A69D9226@jp.fujitsu.com> <49F9D82D.50901@hp.com> <49F9D906.40300@hp.com> <49FE8165.80709@cn.fujitsu.com> <20090506095343.GA15323@elte.hu>
In-Reply-To: <20090506095343.GA15323@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>>> Subject: [PATCH] blktrace: correct remap names
>>>
>>> This attempts to clarify names utilized during block I/O remap operations
>>> (partition, volume manager). It correctly matches up the /from/ information for both device & sector. This takes in the concept from osaki Motohiro and extends it to include better naming for the "device_from" field.
>>>
>> I also noticed this..
>>
>>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>> Cc: Li Zefan <lizf@cn.fujitsu.com>
>>> Cc: Jens Axboe <jens.axboe@oracle.com>
>>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>>> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
>>> ---
>>>  include/linux/blktrace_api.h |    4 ++--
>>>  include/trace/block.h        |    4 ++--
>>>  kernel/trace/blktrace.c      |   21 +++++++++++----------
>>>  3 files changed, 15 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
>>> index d960889..da1a14e 100644
>>> --- a/include/linux/blktrace_api.h
>>> +++ b/include/linux/blktrace_api.h
>>> @@ -116,9 +116,9 @@ struct blk_io_trace {
>>>   * The remap event
>>>   */
>>>  struct blk_io_trace_remap {
>>> -	__be32 device;
>>>  	__be32 device_from;
>>> -	__be64 sector;
>>> +	__be32 device_to;
>>> +	__be64 sector_from;
>>>  };
>>>  
>> If we are really fine with this change, then:
>>
>> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> is it acceptable to break the sector output ordering of all past 
> blktrace+blkparse binaries, as far as remap events go?
> 
> 	Ingo

The binary order of data sent remains the same: the field names for the
structure & parameters passed around were wrong^Wmisleading (as was
pointed out previously by Kosaki Motoiro). I've tested this and the
blkparse output remains identical (both with the previous version of
blktrace/blkparse & with a posted patch to blkparse which also fixes the
field names of blk_io_trace_remap). The testing included permutations of
(old/new) kernel traces & (old/new) blkparse. They all resulted in the
same blkparse output.

Alan
