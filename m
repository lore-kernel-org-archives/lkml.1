Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXHXQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXHXQad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbXHXQaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:30:24 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1076 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbXHXQaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:30:23 -0400
Message-ID: <46CF079C.7010304@xs4all.nl>
Date: Fri, 24 Aug 2007 18:30:20 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: possible BUG while doing gpg --gen-key
X-Enigmail-Version: 0.95.3
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While doing gpg --gen-key I can reproduce quite well some sort of
crash/bug/etc:
# gpg --gen-key
gpg (GnuPG) 1.4.7; Copyright (C) 2006 Free Software Foundation, Inc.
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions. See the file COPYING for details.

Please select what kind of key you want:
   (1) DSA and Elgamal (default)
   (2) DSA (sign only)
   (5) RSA (sign only)
Your selection? 1
DSA keypair will have 1024 bits.
ELG-E keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048)
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y

You need a user ID to identify your key; the software constructs the user ID
from the Real Name, Comment and Email Address in this form:
    "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

Real name: root
Name must be at least 5 characters long
Real name: root!
Email address: root@localhost
Comment:
You selected this USER-ID:
    "root! <root@localhost>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
You need a Passphrase to protect your secret key.

We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
+++++++++++++++++++++++++.++++++++++++++++++++.+++++.+++++.++++++++++.++++++++++++++

 ++++++++++++++++.++++++++++++++++++++++++++++++++++++++++>...+++++......+++++
Segmentation fault
(...)
# dmesg
(...)
BUG: unable to handle kernel paging request at virtual address a5773b04
 printing eip:
a5773b04
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: nls_utf8 cifs pwc sch_tbf ipt_recent xt_string
xt_MARK xt_length xt_tcpmss xt_mac xt_mark w83627hf hwmon_vid eeprom sit
tunnel4 nf_nat_h323 nf_conntrack_h323 nf_nat_ftp nf_conntrack_ftp
ipt_tos ipt_REDIRECT nf_nat_irc nf_conntrack_irc ipt_owner ipt_ttl ipv6
ipt_MASQUERADE iptable_nat nf_nat xt_NOTRACK iptable_raw ipt_TOS
iptable_mangle ipt_LOG xt_TCPMSS xt_limit xt_state ipt_TARPIT ipt_REJECT
iptable_filter binfmt_misc nvram snd_via82xx snd_ac97_codec ac97_bus
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss
snd_mixer_oss snd_pcm compat_ioctl32 videodev snd_timer snd_page_alloc
parport_pc v4l2_common snd_mpu401_uart v4l1_compat snd_rawmidi parport
snd_seq_device snd usblp i2c_viapro uhci_hcd
CPU:    0
EIP:    0060:[<a5773b04>]    Not tainted VLI
EFLAGS: 00010292   (2.6.22.2 #4)
EIP is at 0xa5773b04
eax: 00000000   ebx: 32b79617   ecx: 00000000   edx: 00000000
esi: 15997020   edi: 184a7dfa   ebp: d861266a   esp: dbe0ff18
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process gpg (pid: 22121, ti=dbe0e000 task=d0a84a50 task.ti=dbe0e000)
Stack: cfc26544 b3546f92 f00ab86f a7815764 b1000d9d 7e024d7b ef89803b
3a816173
       db38f9a3 4d18a9b1 de997ad3 bee35cf6 6a3b6724 43e1382b 13e8dabb
1c129e64
       81cc5ec8 e3073404 706dc511 90ba38c5 5a8912dc 67e387e7 63e76d1b
54f7bf10
Call Trace:
 [<c0103b75>] show_trace_log_lvl+0x1a/0x2f
 [<c0103c27>] show_stack_log_lvl+0x9d/0xa5
 [<c0103dfc>] show_registers+0x1cd/0x2e3
 [<c0104010>] die+0xfe/0x200
 [<c010fb77>] do_page_fault+0x43c/0x511
 [<c030220a>] error_code+0x6a/0x70
 =======================
Code:  Bad EIP value.
EIP: [<a5773b04>] 0xa5773b04 SS:ESP 0068:dbe0ff18


FWIW: I run audio-entropyd and use netdev-random. Both pieces of
sofwtare don't interfere as far as I know.

strace shows:

write(2, ".", 1.)                        = 1
write(2, ".", 1.)                        = 1
write(2, ".", 1.)                        = 1
write(2, ".", 1.)                        = 1
write(2, ".", 1.)                        = 1
write(2, ".", 1.)                        = 1
write(2, "+", 1+)                        = 1
gettimeofday({1187972883, 742452}, NULL) = 0
getrusage(RUSAGE_SELF, {ru_utime={3, 228201}, ru_stime={0, 40002}, ...}) = 0
time(NULL)                              = 1187972883
times({tms_utime=322, tms_stime=4, tms_cutime=0, tms_cstime=0}) = 1812850434
write(2, "+", 1+)                        = 1
gettimeofday({1187972883, 821360}, NULL) = 0
getrusage(RUSAGE_SELF, {ru_utime={3, 304206}, ru_stime={0, 40002}, ...}) = 0
time(NULL)                              = 1187972883
times({tms_utime=330, tms_stime=4, tms_cutime=0, tms_cstime=0}) = 1812850442
write(2, "+", 1+)                        = 1
gettimeofday({1187972883, 900190}, NULL) = 0
getrusage(RUSAGE_SELF, {ru_utime={3, 380211}, ru_stime={0, 44002}, ...}) = 0
time(NULL)                              = 1187972883
times({tms_utime=338, tms_stime=4, tms_cutime=0, tms_cstime=0}) = 1812850450
write(2, "+", 1+)                        = 1
gettimeofday({1187972883, 976463}, NULL) = 0
getrusage(RUSAGE_SELF, {ru_utime={3, 456216}, ru_stime={0, 44002}, ...}) = 0
time(NULL)                              = 1187972883
times({tms_utime=345, tms_stime=4, tms_cutime=0, tms_cstime=0}) = 1812850458
write(2, "+", 1+)                        = 1
write(2, "\n", 1
)                       = 1
open("/dev/random", O_RDONLY|O_LARGEFILE) = 5
fstat64(5, {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 8), ...}) = 0
select(6, [5], NULL, NULL, {3, 0})      = 1 (in [5], left {3, 0})
read(5,
"x\250v\340\342\212\2614\"\242\273i\201}\355\30\361\262a\272\230\226\2\32\352d\307\350#\324R\343"...,
300) = 128
select(6, [5], NULL, NULL, {3, 0})      = 1 (in [5], left {3, 0})
read(5,  <unfinished ...>
+++ killed by SIGSEGV +++


This is on a VIA Epia EK8000 again.

Udo
