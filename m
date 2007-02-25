Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbXBYQpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbXBYQpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 11:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbXBYQpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 11:45:32 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57179 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbXBYQpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 11:45:31 -0500
Date: Sun, 25 Feb 2007 17:33:11 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Threadlet/syslet v4 bug report.
Message-ID: <20070225143310.GA12456@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070221211355.GA7302@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sun, 25 Feb 2007 19:33:39 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo.

I tried to create web server application for threadlets to show (will
not write what I wanted to show, but you might guess :)

I started threadlet-test from async-test-v4 and got following bug.

To compile v4 and v3 I need to apply a patch (sent in previous e-mail),
which removes %xgs assignment since it is never used and actually does
not even exist it pt_regs.

It is 2.6.20-rc1 tree (patch failed in Makefile (no need to export your
kernel extraversion) and in asm/i386/kernel/process (i387
initialization)), both are trivially fixable by hands.

Machine is via epia, fc5 distro.

I'm currently compiling tree fwith debug support to decode where bug
lives if it will be reproduced.

[  894.597934] general protection fault: 0000 [#1]
[  894.597959] PREEMPT SMP
[  894.597975] Modules linked in: dm_mod nvram ehci_hcd uhci_hcd
snd_via82xx snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm snd_timer
snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd generic
soundcore via_rhine i2c_viapro i2c_core mii ext3 jbd ide_disk
[  894.598131] CPU:    0
[  894.598135] EIP:    0060:[<c012ab99>]    Not tainted VLI
[  894.598141] EFLAGS: 00010282   (2.6.21-rc1 #2)
[  894.598179] EIP is at cachemiss_thread+0xa/0xc6
[  894.598200] eax: cdfa8ef4   ebx: cdfa8ef4   ecx: cdfa8ef4   edx: cdfa8ef4
[  894.598222] esi: 00000000   edi: 00000000   ebp: 00000000   esp: ca6aff94
[  894.598245] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
[  894.598268] Process threadlet-test (pid: 12030, ti=ca6ae000 task=cdf9a790 task.ti=ca6ae000)
[  894.598290] Stack: cd28a080 cdfa8db8 c0114536 cdfa8c10 c012ab8f 00000000 00000000 c0103af8
[  894.598339]        cdfa8ef4 c012ab8f 00000000 cdfa8ef4 00000000 00000000 00000000 00000000
[  894.598385]        0000007b 0000007b 00000000 ffffffff c0103af0 00000060 00000286 00000000
[  894.598437] Call Trace:
[  894.598463]  [<c0114536>] schedule_tail+0x2d/0x80
[  894.598497]  [<c012ab8f>] cachemiss_thread+0x0/0xc6
[  894.598526]  [<c0103af8>] async_thread_helper+0x8/0x1c
[  894.598561]  [<c012ab8f>] cachemiss_thread+0x0/0xc6
[  894.598598]  [<c0103af0>] async_thread_helper+0x0/0x1c
[  894.598631]  =======================
[  894.598648] Code: b8 1f 00 00 89 42 38 8b 53 04 8b 46 0c 81 c2 b8 1f
00 00 89 42 2c 83 c8 ff 83 c4 10 5b 5e 5f 5d c3 57 89 c1 56 53 89 c3 83
ec 10 <64> 8b 35 08 00 00 00 8d be c4 02 00 00 89 f0 89 fa e8 ab f8 ff
[  894.598875] EIP: [<c012ab99>] cachemiss_thread+0xa/0xc6 SS:ESP 0068:ca6aff94


-- 
	Evgeniy Polyakov
