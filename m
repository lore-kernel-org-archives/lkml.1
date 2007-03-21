Return-Path: <linux-kernel-owner+w=401wt.eu-S964931AbXCUU6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931AbXCUU6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964960AbXCUU6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:58:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40817 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbXCUU6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:58:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sukadev@us.ibm.com, linux-kernel@vger.kernel.org, serue@us.ibm.com,
       haveblue@us.ibm.com, Containers <containers@lists.osdl.org>,
       clg@fr.ibm.com
Subject: Re: [PATCH] Define CLONE_NEWPID flag
References: <20070321194103.GA29820@us.ibm.com>
	<20070321133938.bff535a3.akpm@linux-foundation.org>
Date: Wed, 21 Mar 2007 14:57:30 -0600
In-Reply-To: <20070321133938.bff535a3.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 21 Mar 2007 13:39:38 -0700")
Message-ID: <m1y7lq9ux1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> Index: lx26-21-rc3-mm2/include/linux/sched.h
>> ===================================================================
>> --- lx26-21-rc3-mm2.orig/include/linux/sched.h 2007-03-20 20:13:19.000000000
> -0700
>> +++ lx26-21-rc3-mm2/include/linux/sched.h 2007-03-21 11:10:33.000000000 -0700
>> @@ -26,6 +26,7 @@
>> #define CLONE_STOPPED 0x02000000 /* Start in stopped state */
>>  #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
>>  #define CLONE_NEWIPC		0x08000000	/* New ipcs */
>> +#define CLONE_NEWPID		0x10000000      /* New pid namespace */
>>  
>
> Do we actually have any need to reserve it at this time?  I'd have thought
> that we could defer adding this until we have some code in-kernel which
> uses it.

In practice this is pretty much reserved already but I understand the sentiment.

Currently the plan is to work on the core pid namespace and get those functions
merged at least to -mm with a big fat CONFIG_EXPERIMENTAL so people
can really understand what we are talking about when we say a
pid_namespace.  Then go through and finish up all converting the rest
of the pid uses that we haven't tackled yet.  There aren't that many
left and most of the remaining conversions only make sense in the
context of a pid namespace.

Currently we are one or two review cycles away from being able to push
out the core pid namespace code.

Further it is actually critical that we have a clone flag for the pid
namespace because unshare is very much harder if it is possible at
all.

Personally if you want to delay it a week or two, until the rest of
the code is ready that is fine.  Mostly getting it out now is about
release early and release often.

Eric
