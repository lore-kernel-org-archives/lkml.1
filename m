Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbXITJON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbXITJON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760113AbXITJMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:12:20 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:57705 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650AbXITJMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:12:18 -0400
Message-ID: <46F2396D.7090404@fr.ibm.com>
Date: Thu, 20 Sep 2007 11:12:13 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc6-mm1 - make access to tasks nsproxy ligther (fix)
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F2324E.9020707@fr.ibm.com> <46F23681.2030400@openvz.org>
In-Reply-To: <46F23681.2030400@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Looks sane :)
> 
> [snip]
> 
>> Index: 2.6.23-rc6-mm1/kernel/exit.c
>> ===================================================================
>> --- 2.6.23-rc6-mm1.orig/kernel/exit.c
>> +++ 2.6.23-rc6-mm1/kernel/exit.c
>> @@ -408,6 +408,8 @@ void daemonize(const char *name, ...)
>>  	current->fs = fs;
>>  	atomic_inc(&fs->count);
>>  
>> +	if (current->nsproxy != init_task.nsproxy)
>> +		get_nsproxy(init_task.nsproxy);
>>  	switch_task_namespaces(current, init_task.nsproxy);
> 
> shouldn't we make the switch under this if() as well?

right. we can probably simplify switch_task_namespaces() and remove :

	if (ns == new)
		return;

I'll cook a better one today.

Thanks !

C. 
