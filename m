Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0CESzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:55:24 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:41232 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab0CESzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:55:22 -0500
MIME-Version: 1.0
In-Reply-To: <20100305134247.EB5E.A69D9226@jp.fujitsu.com>
References: <20100202120457.GA19605@omega> <20100304140822.GA458@redhat.com> 
	<20100305134247.EB5E.A69D9226@jp.fujitsu.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 5 Mar 2010 10:55:06 -0800
Message-ID: <ac3eb2511003051055g48adcbf8p3961c45c437b5156@mail.gmail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for 
	child processes
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Lennart Poettering <lennart@poettering.net>,
       linux-kernel@vger.kernel.org, Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>, Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 20:47, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On 02/02, Lennart Poettering wrote:
>> >
>> > This patch adds a simple flag for each process that marks it as an
>> > "anchor" process for all its children and grandchildren. If a child of
>> > such an anchor dies all its children will not be reparented to init, but
>> > instead to this anchor, escaping this anchor process is not possible. A
>> > task with this flag set hence acts is little "sub-init".
>>
>> Lennart, this patch adds a noticeable linux-only feature. I see
>> your point, but imho your idea needs the "strong" acks. I cc'ed
>> some heavyweights, if someone dislikes your idea he can nack it
>> right now.
>>
>>
>> Security. This is beyond my understanding, hopefully the cc'ed
>> experts can help.
>>
>> Should we clear ->child_anchor flags when the "sub-init" execs? Or,
>> at least, when the task changes its credentials? Probably not, but
>> dunno.
>>
>> The more problematic case is when the descendant of the "sub-init"
>> execs the setuid application. Should we allow the reparenting to
>> !/sbin/init task in this case?
>>
>> Should we clear ->pdeath_signal after reparenting to sub-init ?
>>
>> Do we need the new security_operations->task_reparent() method ?
>> Or, perhaps we can reuse ->task_wait() if we add the "parent"
>> argument?
>>
>> Something else we should think about?
>
> I think changing reparent rule is a bit risky. instead, I propse
> that exporting ANCHOR flag via /proc and ps parse it.
>
> What do you think?

No, that does not help anything, as mentioned earlier. It's not about
making 'ps' look nice, we need the signals if processes die, so we
want to be the parent of the process to keep the usual semantics.

Thanks,
Kay
