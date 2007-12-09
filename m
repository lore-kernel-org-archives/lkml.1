Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbXLIV5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbXLIV5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbXLIV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:57:41 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:26700 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbXLIV5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:57:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f/aX7Qt4glmBRVhHQtfIOkJRwxiJ7sQ4AMjj9bynq4vzi+jvTwlZNL5FxfJV4ajJ6vywqRXQ87EM6Ji/z8VVydrVzQWrad2QaLiLMMtuw6mBdiqqRhTig2zHtTtvDQP0Mgo0drXf1P57sirMpZ6W3FZQPXnclQ4GYN4XZ1h8FbU=
Message-ID: <82e4877d0712091357u41973a24v38c4ad18ad596de5@mail.gmail.com>
Date: Sun, 9 Dec 2007 16:57:38 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <82e4877d0712081512s2b5a72aewbe396f28305ac963@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <20071208191330.GA21186@elte.hu>
	 <82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com>
	 <20071208194211.GA579@elte.hu>
	 <82e4877d0712081208u335c968csd1d3e9259cdd2920@mail.gmail.com>
	 <20071208201137.GA13451@elte.hu>
	 <82e4877d0712081246x4d788c36i908916185611fa94@mail.gmail.com>
	 <20071208125144.734e9f81@laptopd505.fenrus.org>
	 <82e4877d0712081304r19721b43w78b294ea8d470405@mail.gmail.com>
	 <82e4877d0712081512s2b5a72aewbe396f28305ac963@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 8, 2007 6:12 PM, Parag Warudkar <parag.warudkar@gmail.com> wrote:
> No problems after disabling CONFIG_HIGHRES_TIMERS , CONFIG_CPU_IDLE
> and CONFIG_NO_HZ.
>
> I will try enabling them one by one - HRT, NOHZ and CPU_IDLE last -
> that way we can at least tell what is required to be hit with this
> problem.

Looks like CPU_IDLE=y is necessary for the problem to show up.
With CPU_IDLE=n HRT+NO_HZ+TICK_ONESHOT does not give soft lockup problems.
(Actually with HIGH_RES_TIMERS=NO_HZ=TICK_ONESHOT=y  I do see short
freezes on ssh - when I cannot type anything for may be a second even
under 100% idle. But Soft Lock up doesnt show up in dmesg with this
configuration.)

No Soft Lockup - CPU_IDLE=n 5+ Hours uptime
---------------------------------------------------------------------------
HIGH_RES_TIMERS=NO_HZ=TICK_ONESHOT=n
HIGH_RES_TIMERS=y NO_HZ=TICK_ONESHOT=n
HIGH_RES_TIMERS=NO_HZ=y TICK_ONESHOT=n
HIGH_RES_TIMERS=NO_HZ=TICK_ONESHOT=y - short freezes.


Soft Lockup - CPU_IDLE=y 2 hours uptime
--------------------------------------------------------------------------
HIGH_RES_TIMERS=NO_HZ=TICK_ONESHOT=y

dmesg -

BUG: soft lockup - CPU#1 stuck for 11s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #13)
EIP: 0060:[<c0603eaa>] EFLAGS: 00000202 CPU: 1
EIP is at _spin_lock_irqsave+0x16/0x27
EAX: c06b4110 EBX: 00000001 ECX: f7873808 EDX: 00000293
ESI: 00000005 EDI: f7873808 EBP: 00000000 ESP: f7829f10
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 800f5958 CR3: 37284000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0438293>] tick_broadcast_oneshot_control+0x10/0xda
 [<c0437ce2>] tick_notify+0x1d4/0x2eb
 [<c04281bc>] get_next_timer_interrupt+0x143/0x1b4
 [<c06058a1>] notifier_call_chain+0x2a/0x47
 [<c04345c0>] raw_notifier_call_chain+0x17/0x1a
 [<c043781e>] clockevents_notify+0x19/0x4f
 [<c0533d23>] acpi_idle_enter_simple+0x183/0x1d0
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================

Parag
