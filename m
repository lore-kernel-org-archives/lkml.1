Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXCKIeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXCKIeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 04:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXCKIeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 04:34:01 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:45249 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXCKIeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 04:34:00 -0400
Message-ID: <45F3BF9C.8070305@sw.ru>
Date: Sun, 11 Mar 2007 11:36:44 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@osdl.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, Kirill Korotaev <dev@sw.ru>
Subject: Re: [RFC][PATCH 6/7] Account for the number of tasks within container
References: <45ED7DEC.7010403@sw.ru> <45ED831A.5030108@sw.ru>	 <6599ad830703061800n38244a8fp68b29fa0290d18d7@mail.gmail.com>	 <45EE6601.4070107@sw.ru> <6599ad830703080549t70e66f92ua345f9fe59c44df4@mail.gmail.com>
In-Reply-To: <6599ad830703080549t70e66f92ua345f9fe59c44df4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 3/6/07, Pavel Emelianov <xemul@sw.ru> wrote:
>> The idea is:
>>
>> Task may be "the entity that allocates the resources" and "the
>> entity that is a resource allocated".
>>
>> When task is the first entity it may move across containers
>> (that is implemented in your patches). When task is a resource
>> it shouldn't move across containers like files or pages do.
>>
>> More generally - allocated resources hold reference to original
>> container till they die. No resource migration is performed.
>>
>> Did I express my idea cleanly?
> 
> Yes, but I disagree with the premise. The title of your patch is
> "Account for the number of tasks within container", but that's not
> what the subsystem does, it accounts for the number of forks within
> the container that aren't directly accompanied by an exit.
> 
> Ideally, resources like files and pages would be able to follow tasks
> as well. The reason that files and pages aren't easily migrated from
> one container to another is that there could be sharing involved;
> figuring out the sharing can be expensive, and it's not clear what to
> do if two users are in different containers.
> 
> But in the case of a task count, there are no such issues with
> sharing, so it seems to me to be more sensible (and more efficient) to
> just limit the number of tasks in a container.
> 
> i.e. when moving a task into a container or forking a task within a
> container, increment the count; when moving a task out of a container
> or when it exits, decrement the count.

Sounds reasonable.
I'll take this into account when I make the next iteration.
Thanks.

> With your approach, if you were to set the task limit of an empty
> container A to 1, and then move a process P from B into A, P would be
> able to fork a new child, since the "task count" would be 0 (as P was
> being charged to B still). Surely the fact that there's 1 process in A
> should prevent P from forking?
> 
> Paul
> 

