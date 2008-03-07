Return-Path: <linux-kernel-owner+w=401wt.eu-S1765627AbYCGEnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765627AbYCGEnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 23:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760320AbYCGEnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 23:43:16 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:37536 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760214AbYCGEnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 23:43:14 -0500
Message-ID: <47D0C76D.8050207@linux.vnet.ibm.com>
Date: Fri, 07 Mar 2008 10:11:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot time
References: <20080306185952.23290.49571.sendpatchset@localhost.localdomain> <alpine.DEB.1.00.0803061108370.13110@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0803061108370.13110@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Fri, 7 Mar 2008, Balbir Singh wrote:
> 
>> @@ -3010,3 +3020,16 @@ static void cgroup_release_agent(struct 
>>  	spin_unlock(&release_list_lock);
>>  	mutex_unlock(&cgroup_mutex);
>>  }
>> +
>> +static int __init cgroup_disable(char *str)
>> +{
>> +	int i;
>> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>> +		struct cgroup_subsys *ss = subsys[i];
>> +		if (!strcmp(str, ss->name)) {
>> +			ss->disabled = 1;
>> +			break;
>> +		}
>> +	}
>> +}
>> +__setup("cgroup_disable=", cgroup_disable);
> 
> This doesn't handle spaces very well, so isn't it possible for the name of 
> a current or future cgroup subsystem to be specified after cgroup_disable= 
> on the command line and have it disabled by accident?
> 

How do you distinguish that from the user wanting to disable the controller on
purpose? My understanding is that after parsing cgroup_disable=, the rest of the
text is passed to cgroup_disable to process further. You'll find that all the
__setup() code in the kernel is implemented this way.

>> diff -puN Documentation/kernel-parameters.txt~cgroup_disable Documentation/kernel-parameters.txt
>> --- linux-2.6.25-rc4/Documentation/kernel-parameters.txt~cgroup_disable	2008-03-06 17:57:32.000000000 +0530
>> +++ linux-2.6.25-rc4-balbir/Documentation/kernel-parameters.txt	2008-03-06 18:00:32.000000000 +0530
>> @@ -383,6 +383,10 @@ and is between 256 and 4096 characters. 
>>  	ccw_timeout_log [S390]
>>  			See Documentation/s390/CommonIO for details.
>>  
>> +	cgroup_disable= [KNL] Enable disable a particular controller
>> +			Format: {name of the controller}
>> +			See /proc/cgroups for a list of compiled controllers
>> +
> 
> This works on multiple controllers, though, if they follow 
> cgroup_disable=, so the documentation and format should reflect that.

Absolutely! done.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
