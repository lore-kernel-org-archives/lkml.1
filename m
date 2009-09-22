Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZIVVY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZIVVY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZIVVY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:24:57 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:43745 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZIVVY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VAFOQPjoIKswtqMomRDa/50gGgffPAFvcjDrgolRapsQV3nsqqpBdlv+nHSG/yKraU
         CgHAUvW+dtkA/72Od73Tfumc0WTUYltHYiwdNxpp72kNOMF19lqRh9NtHYuACZ/7D0zk
         miKJDqMSjZPJxvn2aEBIXEiH5npZ4e+5MeVgU=
Date: Tue, 22 Sep 2009 23:24:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chris Malley <mail@chrismalley.co.uk>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf sched record hangs machine
Message-ID: <20090922212453.GB6062@nowhere>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 10:09:26PM +0100, Chris Malley wrote:
> Hi
> 
> When I run "perf sched record sleep 10", and generate some activity,
> after a few seconds my machine (single cpu Dell Latitude D400, 32-bit)
> locks up.
> This happens almost every time, not always with the same call trace
> but always in default_send_IPI_self().  Occasionally I get a completed
> recording but only if the machine is otherwise quiet.
> 
> Kernel and perf sched version is current Linus tree (as of 43c1266ce4dc06b).
> 
> I've captured the netconsole output from two different crashes, config
> and dmesg below.
> Let me know if you need anything further.
> 
> cheers
> Chris
> 
> [  389.272175] BUG: unable to handle kernel paging request at ffffb300
> [  389.272294] IP: [<c011b0bd>] default_send_IPI_self+0x1d/0x50
> [  389.272366] *pde = 0073f067 *pte = 00000000
> [  389.272451] Oops: 0000 [#1] SMP
> [  389.272532] last sysfs file:
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> [  389.272597] Modules linked in: netconsole configfs arc4 ecb
> lib80211_crypt_wep i915 drm_kms_helper drm i2c_algo_bit binfmt_misc
> snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> snd_seq snd_timer snd_seq_device snd intel_agp video dcdbas soundcore
> lib80211 output pcspkr joydev snd_page_alloc agpgart ohci1394 ieee1394
> tg3 [last unloaded: cfg80211]
> [  389.273572]
> [  389.273611] Pid: 2163, comm: dbus-daemon Not tainted
> (2.6.31-cjm-07092-g819307a #4) Latitude D400
> [  389.273681] EIP: 0060:[<c011b0bd>] EFLAGS: 00010046 CPU: 0
> [  389.273727] EIP is at default_send_IPI_self+0x1d/0x50
> [  389.273771] EAX: fffff000 EBX: 000000ec ECX: 00000800 EDX: ffffb300
> [  389.273818] ESI: f201dd60 EDI: 00000000 EBP: f201dcfc ESP: f201dcf8
> [  389.273864]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  389.273909] Process dbus-daemon (pid: 2163, ti=f201c000
> task=f6bb9220 task.ti=f201c000)
> [  389.273972] Stack:
> [  389.274011]  f6b0ba14 f201dd04 c010e3b4 f201dd24 c01b9751 f26be024
> f26be020 00105558
> [  389.274198] <0> 00000000 f26be000 f6a8f800 f201dd34 c01b981a
> f201dd60 f201dd80 f201dd94
> [  389.274437] <0> c01ba690 f6a8f800 00000001 c030963e ffffffff
> ffffffff 00000000 00000001
> [  389.274708] Call Trace:
> [  389.274752]  [<c010e3b4>] ? set_perf_event_pending+0x14/0x20
> [  389.274801]  [<c01b9751>] ? perf_output_unlock+0x121/0x1a0
> [  389.274848]  [<c01b981a>] ? perf_output_end+0x4a/0x70



Ah, that calls perf_output_wakeup(), then perf_pending_counter(),
...., wake_up_all()

And it looks like this event is called with the rq lock
held, then we have a deadlock.

The problem may also happen with some other sched events
than sched_stat_runtime, such as sched_wake_up.

And that can also happen in other places that call
perf_counter_wakeup()

I guess we need to set a polling wait style for the tracepoint
events counters.

Thanks,
Frederic.

