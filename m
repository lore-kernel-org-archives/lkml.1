Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXIZNkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXIZNkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbXIZNkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:40:33 -0400
Received: from sacred.ru ([62.205.161.221]:43084 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbXIZNkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:40:32 -0400
Message-ID: <46FA608E.1060009@openvz.org>
Date: Wed, 26 Sep 2007 17:37:18 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unused member from nsproxy
References: <46FA5B39.1010204@openvz.org> <46FA5F26.2030100@fr.ibm.com>
In-Reply-To: <46FA5F26.2030100@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 26 Sep 2007 17:39:40 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
> Pavel Emelyanov wrote:
>> The nslock spinlock is not used in the kernel at all. 
> 
> it's also useless now that you have put some RCU rules around it.
> right ? 

Exactly!

> C.
> 
>> Remove it.
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>>
>> ---
>>
>> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
>> index a3f2541..cae35b6 100644
>> --- a/include/linux/init_task.h
>> +++ b/include/linux/init_task.h
>> @@ -73,7 +73,6 @@ extern struct nsproxy init_nsproxy;
>>  #define INIT_NSPROXY(nsproxy) {						\
>>  	.pid_ns		= &init_pid_ns,					\
>>  	.count		= ATOMIC_INIT(1),				\
>> -	.nslock		= __SPIN_LOCK_UNLOCKED(nsproxy.nslock),		\
>>  	.uts_ns		= &init_uts_ns,					\
>>  	.mnt_ns		= NULL,						\
>>  	INIT_NET_NS(net_ns)                                             \
>> diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
>> index 4d564d8..0e66b57 100644
>> --- a/include/linux/nsproxy.h
>> +++ b/include/linux/nsproxy.h
>> @@ -23,7 +23,6 @@ struct pid_namespace;
>>   */
>>  struct nsproxy {
>>  	atomic_t count;
>> -	spinlock_t nslock;
>>  	struct uts_namespace *uts_ns;
>>  	struct ipc_namespace *ipc_ns;
>>  	struct mnt_namespace *mnt_ns;
>> _______________________________________________
>> Containers mailing list
>> Containers@lists.linux-foundation.org
>> https://lists.linux-foundation.org/mailman/listinfo/containers
>>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

