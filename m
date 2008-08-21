Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbYHUTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbYHUTOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYHUTOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:14:06 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:43011 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYHUTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ugc6j2EKRztzGloe6kwkUbKWxfiDvpRy+JJLXPgiuTyKqeSJUXOLRtYnZSr5pUKZHh
         hVzIbCMjo6jT2MdrJE0I7VjgA4Swwd/mIi3JqS0tDrcVvN7voR4CIiIIKEfB4JI487f2
         rVX3yFEywtHk8cdSiOdPtFAE2WlaO2R5lczsc=
Message-ID: <19f34abd0808211214x24af9351tcc077307fd1f2be5@mail.gmail.com>
Date: Thu, 21 Aug 2008 21:14:03 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <200808212107.42356.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
	 <19f34abd0808211131h7c4b4fcfo99f858218aad8027@mail.gmail.com>
	 <19f34abd0808211139s24f0d57bq7fbd6d2963594919@mail.gmail.com>
	 <200808212107.42356.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 9:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, 21 of August 2008, Vegard Nossum wrote:
>> On Thu, Aug 21, 2008 at 8:31 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> > On Thu, Aug 21, 2008 at 8:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> On Thursday, 21 of August 2008, Vegard Nossum wrote:
>> >>>
>> >>> I just got this on v2.6.27-rc4 (+ unrelated fix):
>> >>>
>> >>> ACPI: Preparing to enter system sleep state S5
>> >>
>> >> This looks fishy.
>> >>
>> >> Please check what's there in /sys/power/disk .
>> >>
>>
>> Sorry, forgot this one:
>>
>> # cat /sys/power/disk
>> test testproc [shutdown] reboot
>
> Hm, I wonder why 'platform' isn't there.
>
> Perhaps the dmesg log will tell.
>
> [/me looks]
>
> No, it doesn't.  The BIOS evidently supports S4.
>
> [/me looks into the source code]
>
> I have no idea whatsoever how it is possible to have
>
> "ACPI: (supports S0 S1 S3 S4 S5)"
>
> in the log and not to have "platform" in the output of "cat /sys/power/disk".

I'm sorry, I made a stupid mistake: That file was taken from the
system when it was booted with acpi=off. The boot log had acpi
enabled, of course. Here is the same file (now booted without
acpi=off):

# cat /sys/power/disk
[platform] test testproc shutdown reboot

> Can you please add
>
> printk(KERN_CRIT "PM: hibernation_ops = %p\n", hibernation_ops);
>
> at the end of kernel/power/disk.c:hibernation_set_ops() and see if it gets
> printed during boot?

I guess this is now not necessary anymore?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
