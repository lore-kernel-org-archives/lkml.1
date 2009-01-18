Return-Path: <linux-kernel-owner+w=401wt.eu-S935041AbZARSZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935041AbZARSZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934464AbZARSY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:24:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:25717 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934338AbZARSY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:24:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hb4RVAQVrK85POZQTNKjc4gkuFfVVVRf4XUjdOdoRTX+kG9YXfy6y7pk5oKkLlWswt
         2YycRiC9H06vtcNJtI8M8EATRxIzLcLAFP8LlRbsUbPmd1PxDjTyMEvdOZgE4QT4u9wk
         I2NIE6O5ZxzdW96vilBuuHZRxuGAF4CvuJvDc=
MIME-Version: 1.0
In-Reply-To: <f19298770901181022gf5a9ea2j154a2fea3ef4cf74@mail.gmail.com>
References: <4966897E.5020302@free.fr>
	 <f19298770901090209m7076f3afyd1e01e0fc9bbca59@mail.gmail.com>
	 <20090111024945.GC7077@elte.hu> <20090114020040.GA19806@wotan.suse.de>
	 <f19298770901181022gf5a9ea2j154a2fea3ef4cf74@mail.gmail.com>
Date: Sun, 18 Jan 2009 21:24:55 +0300
Message-ID: <f19298770901181024u63996912oa75fb76169b7e594@mail.gmail.com>
Subject: Re: next-20090107: WARNING: at kernel/sched.c:4435 sub_preempt_count
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 21:22, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> Hi.
>
> On Wed, Jan 14, 2009 at 05:00, Nick Piggin <npiggin@suse.de> wrote:
>> On Sun, Jan 11, 2009 at 03:49:45AM +0100, Ingo Molnar wrote:
>>>
>>> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>>>
>>> > One more instance of http://marc.info/?l=linux-kernel&m=123134586202636&w=2
>>> > Added Ingo Molnar to CC.
>>>
>>> added Nick on Cc:. Nick, it's about:
>>>
>>> > commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
>>> > Author: Nick Piggin <nickpiggin@yahoo.com.au>
>>> > Date:   Tue Sep 30 20:50:27 2008 +1000
>>> >
>>> >    sched: improve preempt debugging
>>>
>>> causing a seemingly spurious warning.
>>
>> I don't know how it is spurious... Presumably the sequence _would_ have
>> caused preempt count to go negative if the bkl were not held...
>>
>> __do_softirq does a __local_bh_disable on entry, and it seems like the
>> _local_bh_enable on exit is what causes this warning. So something is
>> unbalanced somehow. Or is it some weird thing we do in early boot that
>> I am missing?
>>
>> Can you put in some printks around these functions in early boot to
>> get an idea of what preempt_count is doing?
>
> Sorry for the delay. I was busy and forgot about this issue.
> The warning does not show in -rc2 any more. Was it fixed, or
> just shadowed by something?
>

Uhg, right Ingo pushed his revert to Linus. Should have looked into
the changelog before posting, not after.
