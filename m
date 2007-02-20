Return-Path: <linux-kernel-owner+w=401wt.eu-S1161062AbXBTW6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161062AbXBTW6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161057AbXBTW6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:58:23 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:47708 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161052AbXBTW6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:58:22 -0500
Message-ID: <45DB7D05.2030800@vilain.net>
Date: Wed, 21 Feb 2007 11:58:13 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
References: <20070212081521.808338000@menage.corp.google.com>	 <45D0EC68.9090009@vilain.net>	 <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>	 <m1wt2c4ttj.fsf@ebiederm.dsl.xmission.com>	 <6599ad830702200955l10f3c71aucff1d4b815e1a1e7@mail.gmail.com>	 <45DB6F07.8080409@vilain.net> <6599ad830702201419n2fe02661y58f09f7dc8d23d88@mail.gmail.com>
In-Reply-To: <6599ad830702201419n2fe02661y58f09f7dc8d23d88@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
>> The term "segregated group of processes" is too vague.  Segregated for
>> what?  What is the kernel supposed to do with this information?
>>     
> The generic part of the kernel just keeps track of the fact that
> they're segregated (and their children, etc).
>
> It's the clients of this subsystem (virtual servers, resource
> controllers) that can decide to give different per-process behaviour
> based on the membership of various groups.
>   

So those clients can use helper functions to use their own namespaces. 
If they happen to group things in the same way they they'll all end up
using the same nsproxy.

>> Did you like the names I came up with in my original reply?
>>
>>  - CPUset namespace for CPU partitioning
>>  - Resource namespaces:
>>    - cpusched namespace for CPU
>>    - ulimit namespace for memory
>>    - quota namespace for disk space
>>    - io namespace for disk activity
>>    - etc
>>     
>
> This is a strange abuse of the term "namespace".
> http://en.wikipedia.org/wiki/Namespace_%28computer_science%29
>
> For the virtual server work that you're doing, namespace is a good term:
>
> pids name processes, hence a pid namespace lets you have multiple
> distinct mappings from pids to processes
> filenames name files, so a filename (or mount) namespace lets you have
> multiple distinct mappings from filenames to files.
>
> For resource QoS control, it doesn't really make sense to talk about
> namespaces. We're not virtualizing resources to rename them for
> different virtual servers, we're limiting the quality of access to the
> resources.
>
> But the semantics of the term "namespace" notwithstanding, you're
> equating a virtual server namespace (pid, ipc, uts, mounts, etc) with
> a resource controller (memory, I/O, etc) in terms of their place in a
> hierarchy, which is something I agree with. All of these subsystems
> can be considered to be units that can be associated with groups of
> processes; the ultimate grouping of processes is something that we're
> both ultimately referring to as a container.
>   

I don't necessarily agree with the 'heirarchy' bit.  It doesn't have to
be so segregated.  But I think we already covered that in this thread.

I agree with the comment on the abuse of the term "namespace", though
consider that it has already been abused with the term IPC namespaces. 
We have for some time been using it to refer to groupable entities
within the kernel that are associated with tasks, even if they don't
involve named entities that clash within a particular domain.  But there
is always an entity and a domain, and that is the key point I'm trying
to make - the features you are putting forward are no different to the
examples that we made specifically for the purpose of setting the
standard for further features to follow.

We talked about naming a bit before, see
http://lkml.org/lkml/2006/3/21/403 and possibly other threads.  So,
anyway, feel free to flog this old dead horse and suggest different
terms.  We've all had long enough to think about it since so maybe it's
worth it, but with any new term it should be really darned clear that
they're essentially the same thing as namespaces, or otherwise be really
likable.

Sam.
