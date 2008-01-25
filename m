Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbYAYAEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbYAYAEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYAYAEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:04:41 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1766 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYAYAEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:04:40 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc8-mm1: old sparc64 bug
Date: Fri, 25 Jan 2008 01:04:34 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, perex@perex.cz
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801250104.34669.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	I was digging through the gentoo bugzilla and found this:

http://bugs.gentoo.org/show_bug.cgi?id=141823

As you see this bug is present since at least 2.6.17. I can reproduce
that here on my hardware with 2.6.24-rc8-mm1. All you need to do is install
mp3blaster on sparc64, run:

$ mp3blaster some_mp3_file.mp3 

and stop it by pressing ctrl-c. It oopses when you stop it. It doesn't happen
every time but it'll oops in a few tries.

This is my trace:

Unable to handle kernel paging request at virtual address 0000000100024000
tsk->{mm,active_mm}->context = 0000000000000dd8
tsk->{mm,active_mm}->pgd = fffff800bf5d6000
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
mp3blaster(3254): Oops [#1]
TSTATE: 0000000080009607 TPC: 000000000056a320 TNPC: 000000000056a324 Y: 00000000    Not tainted
TPC: <memcpy+0x1a8/0x13c0>
g0: 0000000000795b00 g1: 0000000100024ff8 g2: 0000000000000000 g3: 0000000000000038
g4: fffff800bf581580 g5: fffff8007f988000 g6: fffff800bdd70000 g7: 0000000000001000
o0: fffff800bdbd6740 o1: 0000000100024000 o2: 0000000000000008 o3: 000000000056a300
o4: fffff800bdbd6080 o5: 0000000000000000 sp: fffff800bdd72b21 ret_pc: 000000000056c228
RPC: <memcpy_user_stub+0x14/0x24>
l0: fffff800bdd73468 l1: fffff800bdd73370 l2: 0000000000755000 l3: fffff800bdb35fa0
l4: fffff800bdb34001 l5: 0000000000000000 l6: 0000000000000000 l7: 0000000000000000
i0: fffff800bdbd6080 i1: 0000000100023880 i2: 0000000000001780 i3: fffff800bf3419b0
i4: 00000000000005e0 i5: 0000000000000000 i6: fffff800bdd72be1 i7: 00000000100554cc
I7: <snd_pcm_lib_write_transfer+0x94/0xe0 [snd_pcm]>
Caller[00000000100554cc]: snd_pcm_lib_write_transfer+0x94/0xe0 [snd_pcm]
Caller[0000000010053294]: snd_pcm_lib_write1+0x15c/0x2a0 [snd_pcm]
Caller[0000000010074924]: snd_pcm_oss_sync+0x28c/0x2c0 [snd_pcm_oss]
Caller[00000000100756d0]: snd_pcm_oss_release+0x38/0xa0 [snd_pcm_oss]
Caller[00000000004c8eb0]: __fput+0xb8/0x1e0
Caller[00000000004c5e58]: filp_close+0x60/0x80
Caller[00000000004723d4]: put_files_struct+0xfc/0x120
Caller[0000000000473a98]: do_exit+0x160/0x840
Caller[00000000004741ac]: do_group_exit+0x34/0xc0
Caller[000000000047db0c]: get_signal_to_deliver+0x274/0x300
Caller[0000000000449f64]: do_signal32+0x2c/0x1240
Caller[0000000000434758]: do_notify_resume+0x1c0/0x5a0
Caller[0000000000404afc]: __handle_signal+0x18/0x54
Caller[00000000f7e3ebd0]: 0xf7e3ebd8
Instruction DUMP: b7b2890c  bbb3090e  bfb38910 <c19a5e00> e3ba1e00  92026040  8ea1e040  02600020  90022040 
Fixing recursive fault but reboot is needed!

If you need any more info/debugging/testing please let me know.

Regards,

	Mariusz

