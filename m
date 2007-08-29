Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbXH2La2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbXH2La2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 07:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbXH2LaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 07:30:17 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:37753 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbXH2LaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 07:30:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=cnkAvrwO+ZQJTmJFHNkcK+hPWT0ZLX3qt3ljdv4g7Jit/Uth1xafWfyKLZFBjMAyHgoHuuecNMP35JE+hXjCiWX9fopvL+5Rt7GcqEWsGTkCgdhrWF1YMBLcjEJkTaeh;
Message-ID: <33633.simon.1188386980@5ec7c279.invalid>
In-Reply-To: <25ae38200708290248w2cdd152fpbdaa1b123de0b7ef@mail.gmail.com>
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
    <46C4BC46.7000305@redhat.com>
    <25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com>
    <46C9A867.6090509@redhat.com>
    <25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com>
    <m3d4xeii2z.fsf@maximus.localdomain> <46CDD98F.2020208@redhat.com>
    <25ae38200708290248w2cdd152fpbdaa1b123de0b7ef@mail.gmail.com>
Date: Wed, 29 Aug 2007 12:29:40 +0100
Subject: Re: Fork Bombing Patch
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Anand Jahagirdar" <anandjigar@gmail.com>
Cc: "Chris Snook" <csnook@redhat.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, August 29, 2007 10:48, Anand Jahagirdar wrote:
> Hi
>                 printk_ratelimit function takes care of flooding the
> syslog. due to printk_ratelimit function syslog will not be flooded
> anymore. as soon as administrator gets this message, he can take
> action against that user (may be block user's access on server). i
> think the my fork patch is very useful and helps administrator lot.
>                 i would also like to mention that in some of the cases
> ulimit solution wont work. in that case fork bombing takes the machine
> and server needs a reboot. i am sure in that situation this printk
> statement helps administrator to know what has happened.

If ulimit "wont work" in some situations, how is it going to trigger this printk?
(When doesn't it work?)

> Anand
>
> On 8/24/07, Chris Snook <csnook@redhat.com> wrote:
>> Krzysztof Halasa wrote:
>> > Hi,
>> >
>> > "Anand Jahagirdar" <anandjigar@gmail.com> writes:
>> >
>> >>    I am forwarding one more improved patch which i have modified as
>> >> per your suggestions. Insted of KERN_INFO i have used KERN_NOTICE and
>> >> i have added one more if block to check hard limit. how good it is?
>> >
>> > Not very, still lacks "#ifdef CONFIG_something" and the required
>> > Kconfig change (or other runtime thing defaulting to "no printk").
>>
>> Wrapping a single printk that's unrelated to debugging in an #ifdef
>> CONFIG_* or a sysctl strikes me as abuse of those configuration
>> facilities.  Where would we draw the line for other patches wanting to
>> do similar things?
>>
>> I realized that even checking the hard limit it insufficient, because
>> that can be lowered (but not raised) by unprivileged processes.  If we
>> can't do this unconditionally (and we can't, because the log pollution
>> would be intolerable for many people) then we shouldn't do it at all.
>>
>> Anand -- I appreciate the effort, but I think you should reconsider
>> precisely what problem you're trying to solve here.  This approach can't
>> tell the difference between legitimate self-regulation of resource
>> utilization and a real attack.  Worse, in the event of a real attack, it
>> could be used to make it more difficult for the administrator to notice
>> something much more serious than a forkbomb.
>>
>> I suspect that userspace might be a better place to solve this problem.
>>  You could run your monitoring app with elevated or even realtime
>> priority to ensure it will still function, and you have much more
>> freedom in making the reporting configurable.  You can also look at much
>> more data than we could ever allow in fork.c, and possibly detect
>> attacks that this patch would miss if a clever attacker stayed just
>> below the limit.
>>
>>        -- Chris
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Simon Arlott
