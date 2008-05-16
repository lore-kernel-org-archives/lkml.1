Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYEPKN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYEPKN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 06:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYEPKNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 06:13:51 -0400
Received: from sacred.ru ([62.205.161.221]:60462 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbYEPKNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 06:13:50 -0400
Message-ID: <482D5DB8.4030200@openvz.org>
Date: Fri, 16 May 2008 14:11:04 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] Bsdacct: account dying tasks in all relevant namespaces
References: <482C15FE.7070300@openvz.org>	<482C1A7B.8050601@openvz.org> <20080515194438.5b609568.akpm@linux-foundation.org>
In-Reply-To: <20080515194438.5b609568.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 16 May 2008 14:13:30 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 May 2008 15:11:55 +0400 Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> +/**
>> + * acct_process - now just a wrapper around do_acct_process
> 
> comment seems wrong.

Oops. I've fixed it once and forgot to re-check after the set.
Will do shortly.

>> + * handles process accounting for an exiting task
>> + */
>> +void acct_process(void)
>> +{
>> +	struct pid_namespace *ns;
>> +
>> +	for (ns = task_active_pid_ns(current); ns != NULL; ns = ns->parent)
>> +		acct_process_in_ns(ns);
>> +}
> 
> Is it really safe to walk this list locklessly?

Well, yes - I wrote it in the comment to the 10th patch:

 "ns->parent access if safe lockless, since current it still
  alive and holds its namespace, which in turn holds its parent."

Should I also add this as a comment here?

Thanks,
Pavel
