Return-Path: <linux-kernel-owner+w=401wt.eu-S935069AbZARSXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935069AbZARSXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934948AbZARSWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:22:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:24222 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934932AbZARSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cEidCsJ8KmNHeUh6OzFDiUANxrAgQyVjRDxgp7s9fGaANT8q6GJVBPJ2QJOzcljQIn
         HLcmbhcSweJk3DdpKES50aGUMebjOloXlCGYDLV51Jkin0gA9Mh/2W4+ngzUa+yYIEeM
         HbkiaGTdkCLiyKtr5vzF6vIbhNQb3O+f6iuLw=
MIME-Version: 1.0
In-Reply-To: <20090114020040.GA19806@wotan.suse.de>
References: <4966897E.5020302@free.fr>
	 <f19298770901090209m7076f3afyd1e01e0fc9bbca59@mail.gmail.com>
	 <20090111024945.GC7077@elte.hu> <20090114020040.GA19806@wotan.suse.de>
Date: Sun, 18 Jan 2009 21:22:48 +0300
Message-ID: <f19298770901181022gf5a9ea2j154a2fea3ef4cf74@mail.gmail.com>
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

Hi.

On Wed, Jan 14, 2009 at 05:00, Nick Piggin <npiggin@suse.de> wrote:
> On Sun, Jan 11, 2009 at 03:49:45AM +0100, Ingo Molnar wrote:
>>
>> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>>
>> > One more instance of http://marc.info/?l=linux-kernel&m=123134586202636&w=2
>> > Added Ingo Molnar to CC.
>>
>> added Nick on Cc:. Nick, it's about:
>>
>> > commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
>> > Author: Nick Piggin <nickpiggin@yahoo.com.au>
>> > Date:   Tue Sep 30 20:50:27 2008 +1000
>> >
>> >    sched: improve preempt debugging
>>
>> causing a seemingly spurious warning.
>
> I don't know how it is spurious... Presumably the sequence _would_ have
> caused preempt count to go negative if the bkl were not held...
>
> __do_softirq does a __local_bh_disable on entry, and it seems like the
> _local_bh_enable on exit is what causes this warning. So something is
> unbalanced somehow. Or is it some weird thing we do in early boot that
> I am missing?
>
> Can you put in some printks around these functions in early boot to
> get an idea of what preempt_count is doing?

Sorry for the delay. I was busy and forgot about this issue.
The warning does not show in -rc2 any more. Was it fixed, or
just shadowed by something?
