Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbYKKV2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbYKKV2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYKKV2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:28:10 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:2858 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYKKV2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:28:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dD7yDfwqf8PHb0A3yBwBZ2BDcZc2SSNhJRDmPkOTgMsOwkl6rKW2IZMuM7fTYfNWpF
         0CoBJ6WOxs3puGsT6CILsXfVuDhKaEAhtJFYmwQjf7BkfEtqJ8dzP3Zz0pTMiwFgjdqt
         fjK7sJe8za1Z9/EtkElwJpN+JQp4NFZTW6cYI=
Message-ID: <b647ffbd0811111328s6a0cd185we3316be5e8f5ce@mail.gmail.com>
Date: Tue, 11 Nov 2008 22:28:06 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to chanes in stop_machine
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <200811102355.42389.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <20081110120401.GA15518@osiris.boeblingen.de.ibm.com>
	 <200811101547.21325.rjw@sisk.pl> <200811102355.42389.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/10 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday, 10 of November 2008, Rafael J. Wysocki wrote:
>> On Monday, 10 of November 2008, Heiko Carstens wrote:
>> > On Sun, Nov 09, 2008 at 06:59:16PM +0100, Rafael J. Wysocki wrote:
>> > > This message has been generated automatically as a part of a report
>> > > of recent regressions.
>> > >
>> > > The following bug entry is on the current list of known regressions
>> > > from 2.6.27.  Please verify if it still should be listed and let me know
>> > > (either way).
>> > >
>> > >
>> > > Bug-Entry : http://bugzilla.kernel.org/show_bug.cgi?id=11989
>> > > Subject           : Suspend failure on NForce4-based boards due to chanes in stop_machine
>> > > Submitter : Rafael J. Wysocki <rjw@sisk.pl>
>> > > Date              : 2008-11-03 0:28 (7 days old)
>> > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c9583e55fa2b08a230c549bd1e3c0bde6c50d9cc
>> > > References        : http://marc.info/?l=linux-kernel&m=122567187604356&w=4
>> >
>> > Hi Rafael,
>>
>> Hi,
>>
>> > could you provide more informations for this, please?
>> >
>> > What is your kernel configuration?
>>
>> Available at: http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc3/kitty-config
>>
>> > Do you have any binary only modules (nvidia?) loaded?
>>
>> No, I don't.
>>
>> > Is it possible to recreate the bug by e.g. just doing something like
>> >
>> > echo 0 > /sys/devices/system/cpu/cpu1/online
>>
>> I haven't checked (yet), I'll do that later today and let you know.
>>
>> > (or any other online cpu)? Or does it trigger any lockdep warnings?
>
> It cannot be reproduced with offlining CPU1 and it doesn't trigger any
> warnings from lockdep.
>
> However, it is reproducible by doing
>
> # echo core > /sys/power/pm_test
>
> and repeating
>
> # echo disk > /sys/power/state
>
> for a couple of times, in which case the last two lines printed to the console
> before a (solid) hang are:
>
> SMP alternatives: switching to SMP code
> Booting processor 1 APIC 0x1 ip 0x6000
>
> So, it evidently fails while re-enabling the non-boot CPU and not during
> disabling it as I thought before.

Can you also provide the full log including the messages when a system
goes down please?

At first glance, "Botting processor..." as the last message looks
strange in this context.
So either wakeup_secondary_cpu()'s completion failed for some reason
(say, due to some kind of a problem that took place while disabling
non-boot cpus... I'm purely speculating here so far) or the printk's
output was not complete.

Perhaps, redoing the test with pr_debug() in arch/x86/kernel/smpboot.c
enabled would shed more light...


-- 
Best regards,
Dmitry Adamushko
