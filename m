Return-Path: <linux-kernel-owner+w=401wt.eu-S967414AbXFHCox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967414AbXFHCox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966607AbXFHCop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:44:45 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:53496 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966463AbXFHCoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:44:44 -0400
Message-ID: <4668C271.80404@linux.vnet.ibm.com>
Date: Fri, 08 Jun 2007 08:14:01 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: menage@google.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: Per container statistics (containerstats)
References: <20070606115813.GA32197@linux.vnet.ibm.com> <20070607155445.edd5fded.akpm@linux-foundation.org> <4668BD18.7090603@linux.vnet.ibm.com> <20070607193917.c21f9071.akpm@linux-foundation.org>
In-Reply-To: <20070607193917.c21f9071.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 08 Jun 2007 07:51:12 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Andrew Morton wrote:
>>> I'd have hoped to see containerstats.c in here.
>>>
>> The current statistics code is really small, so it fit into taskstats.c.
>> May be in the future, we could re-factor it and move it out.
> 
> I was referring to your userspace tool which reads this stuff.  The one
> which you described in the changelog.
> 

Ahh.. yes.. I'll make the changes and repost with the tool.

>>>> +	rcu_read_lock();
>>>> +
>>>> +	for_each_root(root) {
>>>> +		if (!root->subsys_bits)
>>>> +			continue;
>>>> +		root_cont = &root->top_container;
>>>> +		get_first_subsys(root_cont, NULL, &subsys_id);
>>>> +		do_each_thread(g, p) {
>>> this needs tasklist_lock?
>>>
>> rcu_read_lock() should be fine. From Eric's patch at
>>
>> 2.6.17-mm2 - proc-remove-tasklist_lock-from-proc_pid_readdir.patch
>>
>> The patch mentions that "We don't need the tasklist_lock to safely
>> iterate through processes anymore."
>>
> 
> oh, OK.  rcu_read_lock() is the new lock_kernel() - always hard to tell
> what it's locking.
> 

:-) I'll add a comment to make it clearer.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
