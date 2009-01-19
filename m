Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZASQG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZASQG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZASQGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:06:49 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:58707 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZASQGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:06:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TJF9VkjurrPSJlxUOWwO5/i+SsPMEaTXGBFSeDKiOHrkInMjvD21Chm6d9Okm7CAgR
         wwMVqdIwcCKpA5STcCKugOCM3Ewn9sLltfrl5KL3lPjn1nAfICl6W+2OwiG2vRLAjLLi
         rwszucjOIqeflTW02ELc/ngVHM0p50LmuSNrA=
MIME-Version: 1.0
In-Reply-To: <c4e36d110901190154y59436b74nbcd1c35712111741@mail.gmail.com>
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <200901121340.21009.rjw@sisk.pl>
	 <c4e36d110901120450q10278979j5cf726a5175cc3f1@mail.gmail.com>
	 <200901121819.01042.rjw@sisk.pl>
	 <c4e36d110901131436y79beaf40h2da44e5925d574b5@mail.gmail.com>
	 <c4e36d110901131441t46fed880j6ac4641a011fb761@mail.gmail.com>
	 <c4e36d110901190154y59436b74nbcd1c35712111741@mail.gmail.com>
Date: Mon, 19 Jan 2009 16:59:08 +0100
Message-ID: <b647ffbd0901190759l7a255005jdef3a927eb23f52b@mail.gmail.com>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/19 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>>> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
>>>> On Monday 12 January 2009, Zdenek Kabelac wrote:
>>>
>>>> Sure, good idea.  I've been running with this reverted recently.
>>>>
>>>>> PS: I'll do the above 'echo' trace later (being busy right now).
>>>>
>>>> That shouldn't be necessary if you can suspend-resume with
>>>> 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted and the USB controller
>>>> modules unloaded.
>>>>
>>>> Instead, with 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted, please write
>>>> 'disabled' to the /sys/devices/.../power/wakeup files of all USB controllers
>>>> and see if suspend-resume works in this configuration.
>>>>
>>>
>>> Hi
>>>
>>> So I've check some   find /sys/device | grep usb | grep power/wakeup
>>> and there was no difference.
>>> I've updated to latest git to be in sync
>>> (e0b325d310a6b11f1538413fd557d2eb98f2fae5)
>>> I'm still keeping reverted commit: 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
>>>
>>> And I've figured out - the only  'modprobe -r ehci_hcd' is enough to
>>> keep my suspend/resume sequence working. (Though I would have say,
>>> that now it takes fairly noticable time to get keyboard and synaptics
>>> usable - but it might be connected with my move to evdev and hal... :)
>>> )
>>>
>>> So I'm adding cc: to David - maybe he has some suspected patches for
>>> ehci_hcd ? (as doing a bisect in such a broken merge window is going
>>> to give me probably a lot of unsable kernels nowdays....)
>>>
>>
>> And I've forget to append trace from supend /resume with INFO trace:
>> (which might be a part of problem??)
>
> Hi
>
>
> Just an update for  2.6.29-rc2 (f3b8436ad9a8ad36b3c9fa1fe030c7f38e5d3d0b)
>
> With this kernel I still have to keep reverted patch commit:
> 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
> (otherwise I see the auto-wake-up immediately after suspend)
>
> I also keep module ehci_hcd away from my kernel - so the
> suspend-resume seems to be working.
>
> I've checked the ideas from thread: 2.6.29-rc1: [SOLVED] thinkpad
> problems during resume
> http://lkml.org/lkml/2009/1/17/181  and they seems to produce some
> ugly Ooops with my configuration.
> so for now I stay with my revert/ehci fix.
>
> Also I still get the INFO trace:
> processor ACPI_CPU:01: legacy suspend
> processor ACPI_CPU:00: legacy suspend
> button LNXPWRBN:00: legacy suspend
> acpi LNXSYSTM:00: legacy suspend
> ACPI: Preparing to enter system sleep state S3
> Disabling non-boot CPUs ...
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.29-rc2 #14
> -------------------------------------------------------
> pm-suspend/2873 is trying to acquire lock:
>  (&per_cpu(cpu_policy_rwsem, cpu)){----}, at: [<ffffffff8049a27b>]
> lock_policy_rwsem_write+0x4b/0x90
>
> but task is already holding lock:
>  (&cpu_hotplug.lock){--..}, at: [<ffffffff80246832>] cpu_hotplug_begin+0x22/0x60
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&cpu_hotplug.lock){--..}:
>       [<ffffffff80270ce6>] __lock_acquire+0x1416/0x1db0
>       [<ffffffff80271711>] lock_acquire+0x91/0xc0
>       [<ffffffff8053d99c>] mutex_lock_nested+0xec/0x360
>       [<ffffffff80246a4a>] get_online_cpus+0x3a/0x50
>       [<ffffffff802594b7>] work_on_cpu+0x67/0xb0
>       [<ffffffff8021e85e>] get_measured_perf+0x1e/0xb0


Ingo,


it looks like e39ad415ac15116df213dfa2aa2a4f1b0857af9c should have
been reverted together with 7503bfbae89eba07b46441a5d1594647f6b8ab7d.

In general, perhaps all "set_cpus_allowed_ptr() -> work_on_cpu()"
conversions - if they involve any cpu-hotplug callback paths - may
lead to similar reports (and possible lockups).


-- 
Best regards,
Dmitry Adamushko
