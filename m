Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab0CJR2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:28:10 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:51613 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab0CJR2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:28:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lRD4Verzeqabs7ZLBepu2Fa8FNPQp/8qZpw+kQjgaUSbLrY69o9kscYSYVCpHmaJ/n
         nnY0dXp0AuuW3Btjvm0P1JWj5yJMzFmZXmC7yNJxsOfcHjIWNyo1XSyOiRy4pBl1Yb31
         ZBv9TuR4MVFZ/q86I5zzaCXn7zIgPRlCBcxNE=
MIME-Version: 1.0
In-Reply-To: <20100310100100.0d175592@multimensaje.es>
References: <20100310100100.0d175592@multimensaje.es>
Date: Wed, 10 Mar 2010 09:28:01 -0800
X-Google-Sender-Auth: 61a85da6267557ac
Message-ID: <1f1b08da1003100928r335568em4f1fa2138ada7870@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/hpet.c:404 hpet_next_event+0x57/0x77()
From: john stultz <johnstul@us.ibm.com>
To: =?ISO-8859-1?Q?Pedro_M=2E_L=F3pez?= <pmlopez@multimensaje.es>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 1:01 AM, Pedro M. López <pmlopez@multimensaje.es> wrote:
> Kernel 2.6.33
>
> [    1.200658] ------------[ cut here ]------------
> [    1.200662] WARNING: at arch/x86/kernel/hpet.c:404 hpet_next_event+0x57/0x77()
> [    1.200663] Hardware name: P55A-UD4
> [    1.200664] hpet: compare register read back failed.
> [    1.200665] Modules linked in:
> [    1.200666] Pid: 0, comm: swapper Not tainted 2.6.33-p1 #10
> [    1.200668] Call Trace:
> [    1.200671]  [<ffffffff8102c98f>] ? warn_slowpath_common+0x76/0x8c
> [    1.200673]  [<ffffffff8102c9f7>] ? warn_slowpath_fmt+0x40/0x45
> [    1.200676]  [<ffffffff81026166>] ? find_busiest_group+0x341/0x7fe
> [    1.200678]  [<ffffffff81018eb1>] ? hpet_next_event+0x57/0x77
> [    1.200681]  [<ffffffff81048d1e>] ? tick_dev_program_event+0x33/0x9e
> [    1.200684]  [<ffffffff81048836>] ?
> tick_broadcast_oneshot_control+0x9c/0xf5
> [    1.200686]  [<ffffffff81048220>] ? tick_notify+0x1f9/0x34d
> [    1.200688]  [<ffffffff8104257a>] ? notifier_call_chain+0x2e/0x5b
> [    1.200690]  [<ffffffff81047c56>] ? clockevents_notify+0x31/0x139
> [    1.200693]  [<ffffffff81175aa0>] ? acpi_idle_enter_simple+0x93/0x130
> [    1.200696]  [<ffffffff811673c3>] ?
> acpi_write_bit_register+0x9e/0xab
> [    1.200698]  [<ffffffff8117585c>] ? acpi_idle_enter_bm+0xd3/0x284
> [    1.200701]  [<ffffffff811f2705>] ? cpuidle_idle_call+0x89/0xc0
> [    1.200704]  [<ffffffff81001256>] ? cpu_idle+0x9d/0xd7
> [    1.200707] ---[ end trace a4e806103d58b3e6 ]---
>
> More info need??

Known issue with that hardware::
http://bugzilla.kernel.org/show_bug.cgi?id=14996

There's a patch that quiets the warnings on its way to mainline.

thanks
-john
