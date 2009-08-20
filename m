Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbZHTDdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbZHTDdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 23:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZHTDdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 23:33:54 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39779 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZHTDdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 23:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b97UrYetIOZrkVu6yuobSJdSAE/0LMySlXCxES/lsWIdXAWoOtL6jErxBTOly1NYc1
         q91eoMPo0MFTGUIiiZhI9p1BHoAlmHz2Z+8Jddk7hJ8lC7rtaBwx1aPxnMJK0lCbgYU4
         v13FfdmSs5Qv6Y2ezAIgB9r+Gu19BAnQjL8oY=
MIME-Version: 1.0
In-Reply-To: <a8e1da0908190647k54cce424m560016ffeec04412@mail.gmail.com>
References: <a8e1da0908172025s728c62ber37acb6c2073f7794@mail.gmail.com>
	 <20090817203047.6cff48fb.akpm@linux-foundation.org>
	 <a8e1da0908172112kca79a1en7042fc1738ad1336@mail.gmail.com>
	 <a8e1da0908190647k54cce424m560016ffeec04412@mail.gmail.com>
Date: Thu, 20 Aug 2009 11:33:54 +0800
Message-ID: <a8e1da0908192033r2d2bc295x464fa0b8d0aba268@mail.gmail.com>
Subject: Re: -mm hang while shutdown with printk_delay
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 9:47 PM, Dave Young<hidave.darkstar@gmail.com> wrote:
> On Tue, Aug 18, 2009 at 12:12 PM, Dave Young<hidave.darkstar@gmail.com> wrote:
>> On Tue, Aug 18, 2009 at 11:30 AM, Andrew
>> Morton<akpm@linux-foundation.org> wrote:
>>> On Tue, 18 Aug 2009 11:25:22 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> Test with printk_delay=200,
>>>>
>>>> /sbin/halt -p
>>>>
>>>> kernel hang after following message:
>>>>
>>>> Disabling non-boot CPUs
>>>>
>>>> There's no such problem with 2.6.31-rc6
>>>
>>> umm, OK.  But -mm contains six patches:
>>>
>>> printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
>>> printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
>>> printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch
>>> printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
>>> printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
>>> printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
>>>
>>> from yourself.  Are they the cause?
>>>
>>
>> Actually I tested 2.6.31-rc6 with the above six patches applied,
>> there's no such problem.
>>
>
> I'm manually bisecting the mm patch series, hope find cause.

Again weird result:

linux-futexh-place-kernel-types-behind-__kernel__.patch
#bisect good
#
#
# edac
#
edac-mpc85xx-add-p2020ds-support.patch
#edac-mpc85xx-add-mpc83xx-support.patch: smp_processor_id() bug?
edac-mpc85xx-add-mpc83xx-support.patch
edac-fix-resource-size-calculation.patch
edac-i3200-memory-controller-driver.patch
edac-i3200-memory-controller-driver-fix-offset-of-reg-in-i3200_edac-module.patch
# bisect bad

I put printk_delay patches to the head of queue. test five times, same results.

bash-3.1$ grep EDAC .config
CONFIG_EDAC=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set

There's no difference between bad/good kernel indeed because the edac
code is not compiled.

hardware is dell e5400
distribution is slackware 12.2

BTW, there's lockdep warnings while umounting a reiserfs partition,
but I think it is not relevant.

Confused...

-- 
Regards
dave
