Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbXHKIxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbXHKIxb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 04:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbXHKIxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 04:53:09 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3128 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbXHKIxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 04:53:05 -0400
X-Greylist: delayed 705 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Aug 2007 04:53:05 EDT
Message-ID: <46BD762F.4060801@xs4all.nl>
Date: Sat, 11 Aug 2007 10:41:19 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: possible BUG while using CUPS
X-Enigmail-Version: 0.95.3
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Using Cups 1.2.12 on Linux 2.6.22.1.
Managing a printer from a Win2K workstation via the http interface.
I am at: http://box:631/printers
I click Set as default.
I see:
426 Upgrade Required

You must access this page using the URL
https://box:631/admin/?op=set-as-default&printer_name=HP_DESKJET_3820_USB_1.

I clikc that link and hear the ping-ping of the BUG:

BUG: unable to handle kernel paging request at virtual address 730ca542
 printing eip:
730ca542
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: pwc nls_utf8 cifs sch_tbf ipt_recent xt_string
xt_MARK xt_length xt_tcpmss xt_mac xt_mark w83627hf hwmon_vid eeprom sit
tunnel4 nf_nat_h323 nf_conntrack_h323 nf_nat_ftp nf_conntrack_ftp
ipt_tos ipt_REDIRECT nf_nat_irc nf_conntrack_irc ipt_owner ipt_ttl ipv6
ipt_MASQUERADE iptable_nat nf_nat xt_NOTRACK iptable_raw ipt_TOS
iptable_mangle ipt_LOG xt_TCPMSS xt_limit xt_state ipt_TARPIT ipt_REJECT
iptable_filter binfmt_misc lp nvram loop snd_via82xx snd_ac97_codec
ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_pcm_oss snd_mixer_oss snd_pcm compat_ioctl32 videodev snd_timer
snd_page_alloc snd_mpu401_uart snd_rawmidi v4l2_common snd_seq_device
v4l1_compat parport_pc parport snd usblp i2c_viapro uhci_hcd
CPU:    0
EIP:    0060:[<730ca542>]    Not tainted VLI
EFLAGS: 00010292   (2.6.22.1 #2)
EIP is at 0x730ca542
eax: 00000000   ebx: a69845a0   ecx: 00000000   edx: 00000000
esi: 1057e3db   edi: 67c88dd0   ebp: 898c1ad5   esp: d9f97f18
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process cupsd (pid: 2220, ti=d9f96000 task=db549420 task.ti=d9f96000)
Stack: b717a69a 240c98ab c2e35cdc 2f6eea16 64cf0972 c0a5a2b1 ba2d3d30
f026206d
       3301069b 39222156 d15922e5 eb1da2a4 656caba4 023f7970 33d43992
cc0c5c41
       63ed81fc 5c760bf7 fe3db5c3 7cdbd9fc ba114508 0ff827b8 b51f3690
9e64614f
Call Trace:
 [<c0103aa5>] show_trace_log_lvl+0x1a/0x2f
 [<c0103b57>] show_stack_log_lvl+0x9d/0xa5
 [<c0103d2c>] show_registers+0x1cd/0x2e3
 [<c0103f40>] die+0xfe/0x200
 [<c010f899>] do_page_fault+0x432/0x505
 [<c02ff72a>] error_code+0x6a/0x70
 =======================
Code:  Bad EIP value.
EIP: [<730ca542>] 0x730ca542 SS:ESP 0068:d9f97f18


This is on a VIA Epia EK8000. ksymoops did not really help me, this is
all output I got.

Ideas?
