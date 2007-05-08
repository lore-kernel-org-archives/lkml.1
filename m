Return-Path: <linux-kernel-owner+w=401wt.eu-S968191AbXEHOvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968191AbXEHOvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967771AbXEHOvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:51:22 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:58317 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968005AbXEHOvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:51:20 -0400
Message-ID: <46408E58.7090306@linux.vnet.ibm.com>
Date: Tue, 08 May 2007 20:21:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: vatsa@in.ibm.com, svaidy@linux.vnet.ibm.com,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, haveblue@us.ibm.com,
       xemul@sw.ru, linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       pj@sgi.com, ebiederm@xmission.com, mbligh@google.com,
       rohitseth@google.com, serue@us.ibm.com, akpm@linux-foundation.org,
       dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 3/9] Containers (V9): Add tasks file interface
References: <20070427104607.252541000@menage.corp.google.com> <20070427111300.406327000@menage.corp.google.com> <46378311.6000703@linux.vnet.ibm.com> <6599ad830705011337r6f200baen841919ac17c6f38b@mail.gmail.com> <20070502032541.GA7311@in.ibm.com> <6599ad830705012025r64eed906sebe4b38d9977c036@mail.gmail.com>
In-Reply-To: <6599ad830705012025r64eed906sebe4b38d9977c036@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 5/1/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>> For the CPU controller I was working on, (a fast access to) such a list would
>> have been valuable. Basically each task has a weight associated with it
>> (p->load_weight) which is made to depend upon its class limit. Whenever
>> the class limit changes, we need to go and change all its member task's
>> ->load_weight value.
>>
>> If you don't maintain the per-container task list, I guess I could still
>> work around it, by either:
>>
>>         - Walk the task table and find relevant members
> 
> That doesn't seem like a terrible solution to me, unless you expect
> the class limit to be changing incredibly frequently.
> 
> If we had multiple subsystems that needed to walk the container member
> list on a fast-path operation (e.g. to make a scheduling decision)
> that would be a good reason to maintain such a list.
> 

I now have a use case for maintaining a per-container task list.
I am trying to build a per-container stats similar to taskstats.
I intend to support container accounting of

1. Tasks running
2. Tasks stopped
3. Tasks un-interruptible
4. Tasks blocked on IO
5. Tasks sleeping

This would provide statistics similar to the patch that Pavel had sent out.

I faced the following problems while trying to implement this feature

1. There is no easy way to get a list of all tasks belonging to a container
   (we need to walk all threads)
2. There is no concept of a container identifier. When a user issues a command
   to extract statistics, the only unique container identifier is the container
   path, which means that we need to do a path lookup to determine the dentry
   for the container (which gets quite ugly with all the string manipulation)

   Adding  a container id, will make it easier to find a container and return
   statistics belonging to the container.

If we get these two features added to the current patches, it will make the
infrastructure more "developer" and eventually more user friendly :-)


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
