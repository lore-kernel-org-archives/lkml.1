Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZHTVQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZHTVQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbZHTVQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:16:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48149 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbZHTVQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:16:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=tKnmJ9X16uHKcYMzguziWmmg3wPt3xuErdH3V4ZxlSMmdaYC03wQlyG0RhYuiD9G6
	Ihd9gQRzKq74cLoBj3mTQ==
MIME-Version: 1.0
In-Reply-To: <20090820141356.1bec84ed.akpm@linux-foundation.org>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	 <20090818235843.22531.57310.stgit@menage.mtv.corp.google.com>
	 <4A8CB750.7040509@cn.fujitsu.com>
	 <6599ad830908191945k7c5f86b6j3ea4194f0dffa9ce@mail.gmail.com>
	 <20090820141356.1bec84ed.akpm@linux-foundation.org>
Date: Thu, 20 Aug 2009 14:16:13 -0700
Message-ID: <6599ad830908201416g7362e008u167f232f2bb3f476@mail.gmail.com>
Subject: Re: [PATCH 7/8] Adds functionality to read/write lock CLONE_THREAD 
	fork()ing per-threadgroup
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lizf@cn.fujitsu.com, bblum@andrew.cmu.edu, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 2:13 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>> >
>> > s/tsk->sighand/p->sighand
>>
>> Good catch, thanks. Fixed.
>>
>
> I see no fix anywhere so I did this:

I meant fixed in my tree to go out in the next set of patches.


>
> --- a/kernel/cgroup.c~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix
> +++ a/kernel/cgroup.c
> @@ -1557,7 +1557,7 @@ struct sighand_struct *threadgroup_fork_
>                rcu_read_lock();
>                list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
>                        if (p->sighand) {
> -                               sighand = tsk->sighand;
> +                               sighand = p->sighand;
>                                break;
>                        }
>                }

Yes, looks good.

Paul
