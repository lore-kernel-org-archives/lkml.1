Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbXEZPxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbXEZPxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXEZPxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:53:06 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:23695 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXEZPxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PS3h5BayIREGIZ+c04JXDyP1u6nw8OAD4U2sy2M1md5x/0n6PC8HvvsSyvFvfVbkmkwKN35Evg5W+p8xqmNLhsllo4dEh7Z8a/Df2R1vAHWqiH4igkffjYqgQ5bbiKU2VT1xNpnOIKwT56z2avVgBg4sekVF4MVNLMrZmkuDfVg=
Message-ID: <465857DF.2020603@gmail.com>
Date: Sat, 26 May 2007 11:53:03 -0400
From: Parag Warudkar <parag.warudkar@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Folkert van Heusden <folkert@vanheusden.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [2.6.21.1] soft lockup when removing netconsole module
References: <20070526154011.GB3735@vanheusden.com>
In-Reply-To: <20070526154011.GB3735@vanheusden.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to be hrtimers related - CC'ed Thomas.

Parag

Folkert van Heusden wrote:
> Hi,
> 
> When trying to remove the netconsole module, I got the following kernel
> output after a while (couple of minutes iirc):
> 
> [525720.117293] BUG: soft lockup detected on CPU#1!
> [525720.117353]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
> [525720.117439]  [<c1004d7b>] show_trace+0x12/0x14
> [525720.117526]  [<c1004e75>] dump_stack+0x16/0x18
> [525720.117613]  [<c104dd5b>] softlockup_tick+0xa6/0xc2
> [525720.117694]  [<c1026855>] run_local_timers+0x12/0x14
> [525720.117738]  [<c1026669>] update_process_times+0x72/0xa1
> [525720.117744]  [<c1038673>] tick_sched_timer+0x53/0xb6
> [525720.117748]  [<c1033d62>] hrtimer_interrupt+0x189/0x1e3
> [525720.117753]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
> [525720.117761]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
> [525720.117766]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
> [525720.117770]  [<c120f4b1>] mutex_lock+0x8/0xa
> [525720.117775]  [<c102d2f0>] flush_workqueue+0x2f/0x8f
> [525720.117780]  [<c102d7a0>] cancel_rearming_delayed_workqueue+0x29/0x2b
> [525720.117785]  [<c102d7b1>] cancel_rearming_delayed_work+0xf/0x11
> [525720.117790]  [<c11be143>] netpoll_cleanup+0x75/0xa5
> [525720.117794]  [<f893712d>] cleanup_netconsole+0x17/0x1a [netconsole]
> [525720.117804]  [<c1041f11>] sys_delete_module+0x12f/0x14f
> [525720.117809]  [<c1003f74>] syscall_call+0x7/0xb
> [525720.117812]  =======================
> 
> Also the rmmod hangs and would not exit even with kill -9. It also
> sucks up 100% cpu.
> 
> 
> Folkert van Heusden
> 

