Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYELMTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYELMTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 08:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYELMTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 08:19:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:46210 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYELMTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 08:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MiBhDOEG5KnbuSKs2gVPL+A37UoHhtOhg5gGZYimsutb4ECoJpMlSp2au5OjpHEtMnAKr2Iq3bQwzV62JvUXeOZ43FXZbo+P8h2ZfHVvvwknu43xWjzoCvJllwgG/sIwbQTb8uZS/BxHmepOMt9+YOEbKde+GvPkToi3WkRt10U=
Message-ID: <19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>
Date: Mon, 12 May 2008 14:19:32 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Gianni Tedesco" <gxt@cs.nott.ac.uk>
Subject: Re: oprofile BUG() in current kernel.
Cc: oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Mike Travis" <travis@sgi.com>
In-Reply-To: <1210593756.3708.7.camel@dao.KWGR614>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210593756.3708.7.camel@dao.KWGR614>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 12, 2008 at 2:02 PM, Gianni Tedesco <gxt@cs.nott.ac.uk> wrote:
> This is from Linus' git tree, pulled this morning. To reproduce simply
>  opcontrol --start
>
>  oprofile: using NMI interrupt.
>  BUG: unable to handle kernel paging request at eff86d58
>  IP: [<eeb9d508>] :oprofile:alloc_cpu_buffers+0x42/0xd6
>  *pde = 00000000
>  Oops: 0002 [#1] SMP
>  Modules linked in: oprofile af_packet i915 drm binfmt_misc kvm_intel kvm cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_ondemand cpufreq_conservative sbs fan sbshc iptable_filter ip_tables x_tables ipcomp authenc esp4 aead ah4 xfrm4_mode_transport deflate zlib_deflate zlib_inflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_i586 aes_generic xcbc sha256_generic sha1_generic md5 hmac crypto_hash crypto_null af_key sierra usbserial snd_usb_audio snd_usb_lib snd_hwdep fuse arc4 ecb crypto_blkcipher cryptomgr crypto_algapi snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq yenta_socket iwl3945 mac80211 rsrc_nonstatic ehci_hcd snd_timer snd_seq_device uhci_hcd cfg80211 snd pcmcia_core usbcore soundcore snd_page_alloc battery ac thinkpad_acpi backlight button led_class thermal evdev nvram
>
>  Pid: 4589, comm: oprofiled Not tainted (2.6.26-rc2 #37)
>  EIP: 0060:[<eeb9d508>] EFLAGS: 00010286 CPU: 1
>  EIP is at alloc_cpu_buffers+0x42/0xd6 [oprofile]
>  EAX: eeba5000 EBX: eff86d40 ECX: eeb9d506 EDX: 00000000
>  ESI: 00000000 EDI: eeba2d40 EBP: 00002000 ESP: e6824e94
>   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  Process oprofiled (pid: 4589, ti=e6824000 task=ed109560 task.ti=e6824000)
>  Stack: 00010000 ffffffea d04eaec0 e6824f14 eeb9dcc5 eeb9d114 ffffffea d04eaec0
>        eeb9dcfe d04eaec0 d0d7fcf4 b0158a50 ec9379c0 d0ddbc6c e6824f14 d04eaec0
>        e6824f14 00000001 b0158b55 d04eaec0 00000000 00000000 e6824f14 b01628fd
>  Call Trace:
>   [<eeb9dcc5>] event_buffer_open+0x0/0x55 [oprofile]
>   [<eeb9d114>] oprofile_setup+0x11/0x85 [oprofile]
>   [<eeb9dcfe>] event_buffer_open+0x39/0x55 [oprofile]
>   [<b0158a50>] __dentry_open+0xfd/0x1e6
>   [<b0158b55>] nameidata_to_filp+0x1c/0x2c
>   [<b01628fd>] do_filp_open+0x31c/0x676
>   [<b014a4cc>] handle_mm_fault+0x1c6/0x48d
>   [<b0158875>] do_sys_open+0x3d/0xb5
>   [<b0111723>] do_page_fault+0x206/0x523
>   [<b0158931>] sys_open+0x1e/0x23
>   [<b0102a79>] sysenter_past_esp+0x6a/0x91
>   [<b02e0000>] lock_kernel+0x2f/0x31
>   =======================
>  Code: e8 db 77 63 c1 89 c6 8d 04 ed 00 00 00 00 89 04 24 e9 8b 00 00 00 8b 04 24 31 d2 89 fb 03 1c b5 80 de 39 b0 e8 9d 28 5b c1 85 c0 <89> 43 18 74 7e 8d 43 34 c7 43 04 00 00 00 00 89 73 2c 89 43 34
>  EIP: [<eeb9d508>] alloc_cpu_buffers+0x42/0xd6 [oprofile] SS:ESP
>  0068:e6824e94
>  ---[ end trace dda7923c8b798701 ]---

This looks similar to:

http://www.uwsg.iu.edu/hypermail/linux/kernel/0805.0/2845.html

Does reverting 608dfddd845da5ab6accef70154c8910529699f7 fix it for you too?

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
