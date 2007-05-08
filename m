Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbXEHUbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbXEHUbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbXEHUbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:31:43 -0400
Received: from gw.goop.org ([64.81.55.164]:56839 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328AbXEHUbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:31:41 -0400
Message-ID: <4640DE27.5030801@goop.org>
Date: Tue, 08 May 2007 13:31:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-git8+ BUG: NMI Watchdog detected LOCKUP on CPU1
References: <46403642.7020501@googlemail.com> <4640924F.8020600@redhat.com>
In-Reply-To: <4640924F.8020600@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Michal Piotrowski wrote:
>   
>> Hi,
>>
>> / filesystem was full
>>
>> [39525.460000] BUG: NMI Watchdog detected LOCKUP on CPU1, eip 08056990, registers:
>> [39525.468000] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat autofs4 af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss evdev snd_pcm intel_agp snd_timer snd agpgart soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
>> [39525.518000] CPU:    1
>> [39525.518000] EIP:    0073:[<08056990>]    Not tainted VLI
>> [39525.518000] EFLAGS: 00000202   (2.6.21-ga989705c #187)
>> [39525.529000] EIP is at 0x8056990
>> [39525.529000] eax: 6e560d60   ebx: 0000000b   ecx: 00000000   edx: 000dd15e
>> [39525.541000] esi: 00000000   edi: 6e560220   ebp: bfeb0a58   esp: bfeb0990
>> [39525.547000] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 007b
>> [39525.553000] Process line (pid: 4277, ti=cf200000 task=f6f560b0 task.ti=cf200000)
>> [39525.560000] Kernel panic - not syncing: Aiee, killing interrupt handler!
>>
>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-git8/git-console.log
>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-git8/git-config
>>
>>     
>
> Nice. System was in user mode with interrupts enabled but none happened
> for a long time. Maybe something forgot to schedule a timer interrupt?
>
> (What mechanism is there to prevent this from happening?)

I think its supposed to be dealt with by explicitly poking at the
softlockup watchdog when exiting a tickless sleep - if we're exiting the
sleep to run the watchdog process, then it should see that it has been
freshly poked and not complain.

But its all fairly subtle and complex, and I couldn't convince myself
that it was correct.  I had an experimental patch to explicitly
disable/enable the watchdog when entering a tickless sleep, but it got
overly complex and I dropped it.

I don't think my softlockup watchdog changes have hit git yet (not
-git8+, anyway), so I don't have to worry about being responsible yet ;)

    J
