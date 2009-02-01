Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbZBAQXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbZBAQXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZBAQXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:23:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55819 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbZBAQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:23:20 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4985CC57.7090800@s5r6.in-berlin.de>
Date: Sun, 01 Feb 2009 17:22:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
References: <20090127001708.GA4815@nowhere> <20090126163015.7f879b18@infradead.org> <20090131180347.GC5884@nowhere> <20090131101502.7ce8e7af@infradead.org> <20090131182843.GD5884@nowhere>
In-Reply-To: <20090131182843.GD5884@nowhere>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Sat, Jan 31, 2009 at 10:15:02AM -0800, Arjan van de Ven wrote:
>> On Sat, 31 Jan 2009 19:03:49 +0100
>> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>> There is one thing that make it hard to replace workqueues in such
>>> cases, there is not guarantee the function will run in user context
>>> because of this condition:
>>>
>>> if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK)
>>>
>>> I wanted to replace kpsmoused with an async function but I want to
>>> schedule a slow work that can't be done from irq...
>> if there is enough value in having a variant that is guaranteed to
>> always run from a thread we could add that. Likely that needs that the 
>> caller passes in a bit of memory, but that's not too big a deal.
>> If there is only 1 in the entire kernel it might not be worth it,
>> but if it's a common pattern then for sure...
>>
>> do you have a feeling on how common this is ?
>>
> 
> 
> I don't know, most of those I've looked on are not documented about the reason
> for a private workqueue. I guess most of them can use the usual kevent.

I have stuff in drivers/firewire/ done in a private workqueue and some
in the shared workqueue which I will eventually move either into
short-lived ad hoc created kthreads /or/ preferably into a thread pool
implementation --- if such a thing will have found its way into the
kernel when I have time for my project.

I need to get callers of scsi_add_device and scsi_remove_device out of
the picture.
-- 
Stefan Richter
-=====-==--= --=- ----=
http://arcgraph.de/sr/
