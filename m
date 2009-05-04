Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbZEDXhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbZEDXhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbZEDXgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:36:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:60937 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676AbZEDXgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:36:47 -0400
MIME-Version: 1.0
In-Reply-To: <20090504231626.GA27123@kroah.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com>
	 <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com>
	 <20090504220905.GA29402@kroah.com>
	 <alpine.DEB.2.00.0905041529570.2310@chino.kir.corp.google.com>
	 <20090504225936.GA9876@kroah.com>
	 <alpine.DEB.2.00.0905041607170.6073@chino.kir.corp.google.com>
	 <20090504231626.GA27123@kroah.com>
Date: Mon, 4 May 2009 16:36:47 -0700
Message-ID: <d6200be20905041636v4a1743e1mdbb5af53621e9cb3@mail.gmail.com>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Greg KH <greg@kroah.com>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 4:16 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, May 04, 2009 at 04:12:57PM -0700, David Rientjes wrote:
>> On Mon, 4 May 2009, Greg KH wrote:
>>
>> > > This patch in the series is really more of a convenience than anything
>> > > else since it doesn't change anything functionally.  I had to modify the
>> > > lowmemorykiller later because there's a potential for a NULL pointer from
>> > > dereferencing p->mm without holding task_lock(p) and also because I moved
>> > > oomkilladj from struct task_struct to struct mm_struct.
>> >
>> > Is this still the case on top of Arve's changes?
>> >
>>
>> Yeah, the first of two patches Arve just sent is broken:
>
> Ok, care to work with Arve to come up with a series that both of you
> agree will work properly?

Yes, that patch only addresses the issues brought up last time this
driver was discussed.

>
>> > Right now, people are still arguing that the android low memory driver
>> > is not needed, but something is, yet no one has proposed a viable
>> > solution for all parties :(
>> >
>>
>> There was an interest in a low mem userspace notifier that applications
>> can poll() on at configurable low mem levels to react accordingly.  This
>> would probably address the problem that the Android team is trying to fix.
>
> Yes, I think it would.
>

Possibly, but waking up a user space code when running out of memory
may need even more memory to be freed.

>> Regardless, my patchset includes two fixes for current bugs in the oom
>> killer: a possible NULL pointer when /proc/sys/vm/oom_dump_tasks is
>> enabled and a possible livelock when killing a task that shares memory
>> with an OOM_DISABLE task.  I'm not really interested in seeing who can get
>> their patches into the staging tree first, I'm more concerned about fixing
>> the oom killer.
>
> Agreed, working with Arve on this would be most appreciated.

I have no problem with the patch that adds task_lock and I can add the
same change myself if you prefer, but the code cleanup patch will
cause unnecessary conflicts for us.

-- 
Arve Hjønnevåg
