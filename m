Return-Path: <linux-kernel-owner+w=401wt.eu-S965058AbXCKTgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058AbXCKTgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965095AbXCKTgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:36:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58273 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965058AbXCKTgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:36:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill Korotaev <dev@sw.ru>, containers@lists.osdl.org, menage@google.com,
       xemul@sw.ru, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	<20070306140036.4e85bd2f.akpm@linux-foundation.org>
	<45F3F581.9030503@sw.ru>
	<20070311045111.62d3e9f9.akpm@linux-foundation.org>
Date: Sun, 11 Mar 2007 13:34:42 -0600
In-Reply-To: <20070311045111.62d3e9f9.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sun, 11 Mar 2007 04:51:11 -0800")
Message-ID: <m1wt1nvajx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> Yep.  Straightforward machine partitioning.  An attractive thing is that it
> 100% reuses existing page reclaim, unaltered.

And misses every resource sharing opportunity in sight.  Except for
filtering the which pages are eligible for reclaim an RSS limit should
not need to change the existing reclaim logic, and with things like the
memory zones we have had that kind of restriction in the reclaim logic
for a long time.  So filtering out ineligible pages isn't anything new.

>> imho memzone approach is inconvinient for pages sharing and shares accounting.
>> it also makes memory management more strict, forbids overcommiting
>> per-container etc.
>
> umm, who said they were requirements?
>
>> Maybe you have some ideas how we can decide on this?
>
> We need to work out what the requirements are before we can settle on an
> implementation.

If you are talking about RSS limits the term is well defined.  The
number of pages you can have mapped into your set of address space at
any given time.

Unless I'm totally blind that isn't what the patchset implements.  A
true RSS limit over multiple processes has a lot of potential to be
generally useful, is very understandable, doesn't affect kernel cache
decisions so largely performance should not be affected.  There is a
little more overhead in the fault logic but that is a moderately
expensive path anyway.

> Sigh.  Who is running this show?   Anyone?

Someone is supposed to run the show?  :)

> You can actually do a form of overcommittment by allowing multiple
> containers to share one or more of the zones.  Whether that is sufficient
> or suitable I don't know.  That depends on the requirements, and we haven't
> even discussed those, let alone agreed to them.  

Another really nasty issue is the container term as the resource guys
are using the term in a subtlety different way then it has been used
with namespaces leading to several threads where the participants talked
past each other.  We need a different term to designate the group of
tasks a resource controller is dealing with.

The whole filesystem interface also is over general and makes it too
easy to express the hard things (like move an existing task from one
group of tasks to another) leading to code complications.

On the up side I think the code the focus is likely in the right place
to start delivering usable code.

Eric
