Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXBTTcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXBTTcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932974AbXBTTcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:32:18 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59974 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961AbXBTTcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:32:17 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Paul Menage" <menage@google.com>
Cc: "Sam Vilain" <sam@vilain.net>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
References: <20070212081521.808338000@menage.corp.google.com>
	<45D0EC68.9090009@vilain.net>
	<6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
	<m1wt2c4ttj.fsf@ebiederm.dsl.xmission.com>
	<6599ad830702200955l10f3c71aucff1d4b815e1a1e7@mail.gmail.com>
Date: Tue, 20 Feb 2007 12:29:48 -0700
In-Reply-To: <6599ad830702200955l10f3c71aucff1d4b815e1a1e7@mail.gmail.com>
	(Paul Menage's message of "Tue, 20 Feb 2007 09:55:11 -0800")
Message-ID: <m1bqjo4ogj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul Menage" <menage@google.com> writes:

> What are you defining here as "everything"? If you mean "all things
> that could be applied to a segregated group of processes such as a
> virtual server", then "container" seems like a good name for my
> patches, since it allows you to aggregate namespaces, resource
> control, other virtualization, etc.

The aggregation happens at the task struct when you apply different
pieces to a task we don't need a structure to allow aggregation.

> Sam said "the NSProxy *is* the container". You appear to be planning
> to have some namespaces, possibly not aggregated within the nsproxy
> (pid namespace?) but are you planning to have some higher-level
> "container" object that aggregates the nsproxy and the other
> namespaces?

No. A reverse mapping is not needed and is not interesting.
As long as I can walk all processes and ask what namespace are
you in I don't care.

> If so, what is it? Does it track process membership, etc?
> What's the userspace API? In what fundamental ways would it be
> different from my generic containers patches with Serge Hallyn's
> namespace subsystem. (If these questions are answered already by
> designs or code, I'd be happy to be pointed at them).


> I guess what it comes down to, is why is an aggregation of namespaces
> suitable for the name "container", when an aggregation of namespaces
> and other resource controllers isn't?

To me at least the interesting part of your work is not the aggregation
portion.  But the infrastructure for building the different process
groups.

You seem to be calling your groups of processes lumped together for
one purpose or another a container.

> What do you think might be a better name for the generic process
> groups that I'm pushing? As I said, I'm happy to do a simple
> search/replace on my code to give a different name if that turned out
> to be the gating factor to getting it merged. But I'd be inclined to
> leave that decision up to Andrew/Linus.

As we have previously been using the term container is like
application.  The end product that the user sees built out of
individual kernel provided components, but not something that exists
in the kernel as such.

We need a term for the non-aggregated case for the individual process
groups we build this out of in your infrastructure.  Because you
clearly have more than one kind of process group a set of processes
can belong to.

>> > But there's a lot of common ground between these different approaches,
>> > and potential for synergy, so the point of this patch set is to
>> > provide a unification point for all of them, and a stepping stone for
>> > other new resource controllers and process control modules.
>>
>> For the case of namespaces I don't see how your code makes things
>> better.  I do not see a real problem that you are solving.
>
> I'm trying to solve the problem that lots of different folks
> (including us) are trying to do things that aggregate multiple process
> into some kind of constrained group, and are all trying to use
> different and incompatible ways of grouping/tracking those processes.
>
> I agree that namespaces fit slightly less well into this model than
> some other subsystems like resource management. But by integrating
> with it you'd get  automatic access to all the various different
> resource controller work that's being done.

I don't need to integrate with it to get access to the resource
controller work.  The resource controller work applies to a set of
processes.  I have a set of processes.  I just need to apply the
resource controllers to my set of processes.

At least when we don't talk about the names for these things it
is that simple.  Now global names I have issues with because almost
always the global names fall into their own category, but that is
a different story.

Now I have some half backed ideas that might be useful for providing
a better abstraction.  But it requires setting down and looking
at the problem in detail, and understanding what people are trying
to accomplish with these things they are building.  What subset of
process groups do you find interesting.

All that is necessary to have a group of processes do something
in an unnamed fashion is to hang a pointer off of the task_struct.
That's easy.  You are adding a lot more to that, and there is
enough abstraction I haven't been able to easily work my way through
the infrastructure to what is really going on.  Admittedly I haven't
looked closely yet.

Eric
