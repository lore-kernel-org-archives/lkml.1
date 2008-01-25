Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYAYSeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYAYSeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYAYSem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:34:42 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1518 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbYAYSel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:34:41 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.24-rc8-mm1: old sparc64 bug
Date: Fri, 25 Jan 2008 19:34:35 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>,
       perex@perex.cz
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <200801250104.34669.m.kozlowski@tuxland.pl> <s5hhch1j0ek.wl%tiwai@suse.de>
In-Reply-To: <s5hhch1j0ek.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251934.35782.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > 	I was digging through the gentoo bugzilla and found this:
> > 
> > http://bugs.gentoo.org/show_bug.cgi?id=141823
> > 
> > As you see this bug is present since at least 2.6.17. I can reproduce
> > that here on my hardware with 2.6.24-rc8-mm1. All you need to do is install
> > mp3blaster on sparc64, run:
> > 
> > $ mp3blaster some_mp3_file.mp3 
> > 
> > and stop it by pressing ctrl-c. It oopses when you stop it. It doesn't happen
> > every time but it'll oops in a few tries.
> 
> This looks similar like a bug I fixed ago.  Damn, it's still there.
> 
> Could you build with CONFIG_SND_DEBUG=y ?  It addas some sanity checks
> and might catch the fatal condition.

Done. I don't think it changed much though :-/ If you have any other ideas please
let me know.

Unable to handle kernel paging request at virtual address 0000000100024000
tsk->{mm,active_mm}->context = 0000000000000dac
tsk->{mm,active_mm}->pgd = fffff800bdb64000
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
mp3blaster(3201): Oops [#1]
TSTATE: 0000000080009600 TPC: 000000000056a294 TNPC: 000000000056a298 Y: 00000000    Not tainted
TPC: <memcpy+0x11c/0x13c0>
g0: 0000000000795b00 g1: 0000000100025ec0 g2: 0000000000000000 g3: 0000000000000038
g4: fffff800bf58a5a0 g5: fffff8007f988000 g6: fffff800bc91c000 g7: 0000000000001ec0
o0: fffff800bdeb2080 o1: 0000000100024000 o2: 0000000000000008 o3: fffff801bdeb6080
o4: fffff800bdeb2080 o5: 0000000000000000 sp: fffff800bc91eb21 ret_pc: 000000000056c228
RPC: <memcpy_user_stub+0x14/0x24>
l0: fffff800bc91f468 l1: fffff800bc91f370 l2: 0000000000755000 l3: fffff800bde7dfa0
l4: fffff800bde7c001 l5: 0000000000000001 l6: fffff800bc818000 l7: 0000000000446600
i0: fffff800bdeb2080 i1: 0000000100024000 i2: 0000000000001f00 i3: 00000000100575b8
i4: 00000000000007c0 i5: fffff800bdeb0000 i6: fffff800bc91ebe1 i7: 0000000010054a30
I7: <snd_pcm_lib_write_transfer+0xb8/0x120 [snd_pcm]>
Caller[0000000010054a30]: snd_pcm_lib_write_transfer+0xb8/0x120 [snd_pcm]
Caller[000000001005215c]: snd_pcm_lib_write1+0x164/0x2e0 [snd_pcm]
Caller[0000000010074cc4]: snd_pcm_oss_sync+0x28c/0x2c0 [snd_pcm_oss]
Caller[0000000010075b64]: snd_pcm_oss_release+0x8c/0xe0 [snd_pcm_oss]
Caller[00000000004c8eb0]: __fput+0xb8/0x1e0
Caller[00000000004c5e58]: filp_close+0x60/0x80
Caller[00000000004723d4]: put_files_struct+0xfc/0x120
Caller[0000000000473a98]: do_exit+0x160/0x840
Caller[00000000004741ac]: do_group_exit+0x34/0xc0
Caller[000000000047db0c]: get_signal_to_deliver+0x274/0x300
Caller[0000000000449f64]: do_signal32+0x2c/0x1240
Caller[0000000000434758]: do_notify_resume+0x1c0/0x5a0
Caller[0000000000404afc]: __handle_signal+0x18/0x54
Caller[00000000f7bd0fcc]: 0xf7bd0fd4
Instruction DUMP: 94228007  82004007  94a28003 <c19a5e00> 92026040  82004003  e19a5e00  92026040  8e21e080 
Fixing recursive fault but reboot is needed!

Thanks,

	Mariusz
