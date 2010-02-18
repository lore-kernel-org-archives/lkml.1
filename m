Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab0BRMyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:54:03 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:58911 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab0BRMx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:53:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tMhbOTp2L/0uppWMbu2yeZ8t+LxYi09Ik8IE6hxYkKIxPdAu60IlYeuGA5tsbpvvma
         hzT87oxsI2uNiEuR/zz5gwGEQ90yCltYZGXgbEkQhMYEnkgwhw6546S6Rx5nrut0uJNH
         xh84fvybuN7I38bI0YIhT1juzFrmIhRbKH+zU=
MIME-Version: 1.0
In-Reply-To: <201002172058.04043.rjw@sisk.pl>
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com>
	 <201002162216.30192.rjw@sisk.pl>
	 <9b2b86521002170327m1f08ff73ncca9e5eff77b1966@mail.gmail.com>
	 <201002172058.04043.rjw@sisk.pl>
Date: Thu, 18 Feb 2010 12:53:55 +0000
Message-ID: <9b2b86521002180453l176a83dand809dc239c220c08@mail.gmail.com>
Subject: Re: s2disk hang update
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mel Gorman <mel@csn.ul.ie>, hugh.dickins@tiscali.co.uk,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday 17 February 2010, Alan Jenkins wrote:
>> On 2/16/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Tuesday 16 February 2010, Alan Jenkins wrote:
>> >> On 2/16/10, Alan Jenkins <sourcejedi.lkml@googlemail.com> wrote:
>> >> > On 2/15/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >> On Tuesday 09 February 2010, Alan Jenkins wrote:
>> >> >>> Perhaps I spoke too soon.  I see the same hang if I run too many
>> >> >>> applications.  The first hibernation fails with "not enough swap"
>> >> >>> as
>> >> >>> expected, but the second or third attempt hangs (with the same
>> >> >>> backtrace
>> >> >>> as before).
>> >> >>>
>> >> >>> The patch definitely helps though.  Without the patch, I see a hang
>> >> >>> the
>> >> >>> first time I try to hibernate with too many applications running.
>> >> >>
>> >> >> Well, I have an idea.
>> >> >>
>> >> >> Can you try to apply the appended patch in addition and see if that
>> >> >> helps?
>> >> >>
>> >> >> Rafael
>> >> >
>> >> > It doesn't seem to help.
>> >>
>> >> To be clear: It doesn't stop the hang when I hibernate with too many
>> >> applications.
>> >>
>> >> It does stop the same hang in a different case though.
>> >>
>> >> 1. boot with init=/bin/bash
>> >> 2. run s2disk
>> >> 3. cancel the s2disk
>> >> 4. repeat steps 2&3
>> >>
>> >> With the patch, I can run 10s of iterations, with no hang.
>> >> Without the patch, it soon hangs, (in disable_nonboot_cpus(), as
>> >> always).
>> >>
>> >> That's what happens on 2.6.33-rc7.  On 2.6.30, there is no problem.
>> >> On 2.6.31 and 2.6.32 I don't get a hang, but dmesg shows an allocation
>> >> failure after a couple of iterations ("kthreadd: page allocation
>> >> failure. order:1, mode:0xd0").  It looks like it might be the same
>> >> stop_machine thread allocation failure that causes the hang.
>> >
>> > Have you tested it alone or on top of the previous one?  If you've
>> > tested it
>> > alone, please apply the appended one in addition to it and retest.
>> >
>> > Rafael
>>
>> I did test with both patches applied together -
>>
>> 1. [Update] MM / PM: Force GFP_NOIO during suspend/hibernation and resume
>> 2. "reducing the number of pages that we're going to keep preallocated by
>> 20%"
>
> In that case you can try to reduce the number of preallocated pages even
> more,
> ie. change "/ 5" to "/ 2" (for example) in the second patch.

It still hangs if I try to hibernate a couple of times with too many
applications.

Alan
