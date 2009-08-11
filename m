Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZHKSZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZHKSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZHKSZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:25:27 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:30080 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbZHKSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:25:26 -0400
Message-ID: <4A81B728.7040200@oracle.com>
Date: Tue, 11 Aug 2009 11:23:36 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: npiggin@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] ipc: sem optimise simple operations
References: <20090811110902.255877673@suse.de> <20090811111607.310739140@suse.de> <4A81B646.5060301@colorfullife.com>
In-Reply-To: <4A81B646.5060301@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A81B72B.00FE:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> On 08/11/2009 01:09 PM, npiggin@suse.de wrote:
>> Index: linux-2.6/include/linux/sem.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/sem.h
>> +++ linux-2.6/include/linux/sem.h
>> @@ -86,6 +86,8 @@ struct task_struct;
>>   struct sem {
>>       int    semval;        /* current value */
>>       int    sempid;        /* pid of last operation */
>> +    struct list_head    negv_pending;
>> +    struct list_head    zero_pending;
>>   };
>>    
> struct sem is increased from 8 to 24 bytes.

And larger still with 64bit pointers.

If it's a problem, this can be scaled back.  You can have pointers to
lists and you can have fewer lists.

Hopefully it won't be a problem, though.  We can close our eyes and
pretend that the size of the semaphore sets scale with the size of the
system and that it's such a relatively small consumer of memory that no
one will notice :).

- z
