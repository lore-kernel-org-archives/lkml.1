Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYDXBCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYDXBCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYDXBCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:02:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54830 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbYDXBCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:02:04 -0400
Message-ID: <480FDBC4.9020001@cn.fujitsu.com>
Date: Thu, 24 Apr 2008 09:00:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: use read lock to guard find_existing_css_set()
References: <480EA744.2050300@cn.fujitsu.com> <480EDBD2.2060709@linux.vnet.ibm.com>
In-Reply-To: <480EDBD2.2060709@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Li Zefan wrote:
>> The function does not modify anything (except the temporary
>> css template), so it's sufficient to hold read lock.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/cgroup.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 2727f92..e9eb5da 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -406,11 +406,11 @@ static struct css_set *find_css_set(
>>
>>  	/* First see if we already have a cgroup group that matches
>>  	 * the desired set */
>> -	write_lock(&css_set_lock);
>> +	read_lock(&css_set_lock);
>>  	res = find_existing_css_set(oldcg, cgrp, template);
>>  	if (res)
>>  		get_css_set(res);
>> -	write_unlock(&css_set_lock);
>> +	read_unlock(&css_set_lock);
>>
>>  	if (res)
>>  		return res;
> 
> Looks good to me. Did you run lockdep?
> 

No, I found this when reading the code, but I do have done some test.
