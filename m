Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZKDCTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZKDCTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZKDCTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:19:46 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:35753 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbZKDCTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J6C7wBTvb9XAloE0tq5Xm/N95FhiyfMx1lyLAhV0ZRCEBxJrclEoVEzjubHO5tKCpI
         3pI+M5JEzkF5h8o/nbHaKzMWMUXxpBDpsFCOqH1niqjBoutin3uUe+4I7A5QiiVnZSoV
         xBvL4QmdNzUh+VI7Y1lMfBoWw5znLqaBUTKMM=
MIME-Version: 1.0
In-Reply-To: <4AEE63E2.9010003@redhat.com>
References: <3a665c760911011913q268b010cqb5da4f79df995b9b@mail.gmail.com>
	 <4AEE63E2.9010003@redhat.com>
Date: Wed, 4 Nov 2009 10:19:49 +0800
Message-ID: <3a665c760911031819t2fef1720q3e2f542a2e56a3d0@mail.gmail.com>
Subject: Re: why kernel implement "udelay" by cpu instructions?
From: loody <miloody@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Kernel Newbies <kernelnewbies@nl.linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2009/11/2 Rik van Riel <riel@redhat.com>:
> On 11/01/2009 10:13 PM, loody wrote:
>>
>> Dear all:
>> I find the kernel use cpu instruction to implement the udelay function
>> as keeping decrease a big counter by 1.
>>
>> If I search the right place in kernel, why kernel does so?
>
> Because udelay is used in places where the kernel cannot
> use other mechanisms, eg. because interrupts are blocked
> or the current process cannot be scheduled out.

Or the only way to support udelay is using CPU instruction to do the counting?
I find something interesting; kernel has msleep, but it doesn't have usleep.
Does that mean the minimum time kernel can react is msecond instead of usecond?
so if  users want to count useconds, they have to do the busy waiting,
execute some looping assembly instructions?

If my consumption is correct, where I can find the evidence?
BTW, does Hz has anything related to kernel timing?
>From the comment in the kernel, it says
Hz: clock ticks generated per second
Does that mean the kernel will get #Hz timer interrupts per second?
Whz the value of Hz is 100?
if the minimum reaction time of kernel is msecond, the value of Hz
should be 1000, right?


>
>> the precision will be different if cpu runs faster or slower, right?
>
> At bootup the kernel measures the delay loop speed of
> each CPU.  CPU frequency scaling might make the loop

would you please let me know where the source code is?
(measuring loop speed of cpu and scale cpu frequency)

> run slower at times, but that is okay because udelay
> simply specifies a *minimum* delay.
>
> This is true even on systems without frequency scaling,
> because the udelay loop could be interrupted by an
> interrupt, an NMI or by having the CPU trap into SMM
> mode and execute code there.
appreciate your kind help :)
miloody
