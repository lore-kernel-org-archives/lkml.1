Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYABF3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYABF3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 00:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYABF3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 00:29:33 -0500
Received: from main.gmane.org ([80.91.229.2]:42424 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYABF3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 00:29:32 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kalin KOZHUHAROV <kalin@thinrope.net>
Subject: [2.6.23.12] consistent "invalid opcode: 0000"
Date: Wed, 02 Jan 2008 14:28:56 +0900
Message-ID: <flf7fd$39l$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s175249.ppp.asahi-net.or.jp
User-Agent: Thunderbird 2.0.0.9 (X11/20071205)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

And Happy New Year! May 2008 bring us less bugs :-)

Please Cc me, as I am not subscribed anymore.

I recently upgraded the kernel of one of my servers to a vanilla*
2.6.23.12 and had it running for a few days (vanilla*, 'cause I change
the Makefile to use distcc).

After some time I got "invalid opcode: 0000" MSG and as this was just in
time for some AC maintenance, I rebooted the machine, ignoring it. Now I
got exactly the same error again, so I decided to post here.

tr2 ~ # uname -a
Linux tr2 2.6.23.12-K01_AthlonXP_server #1 Sun Dec 23 15:00:54 JST 2007 i686 AMD Athlon(TM) XP 1700+ AuthenticAMD GNU/Linux

tr2 ~ # uprecords |head -n5
     #               Uptime | System                                     Boot up
----------------------------+---------------------------------------------------
     1     5 days, 20:51:50 | Linux 2.6.23.12-K01_Athl  Wed Dec 26 23:03:58 2007
     2     3 days, 01:01:31 | Linux 2.6.23.12-K01_Athl  Sun Dec 23 22:01:53 2007
->   3     0 days, 17:53:10 | Linux 2.6.23.12-K01_Athl  Tue Jan  1 19:56:22 2008

tr2 ~ # grep "invalid opcode:" -A19 /var/log/syslog-ng/misc/kernel+debug 
[393854.538495] invalid opcode: 0000 [#1]
[393854.538541] Modules linked in: w83l785ts asb100 hwmon_vid hwmon i2c_nforce2 pppoe pppox ipt_REJECT xt_state ipt_LOG xt_limit xt_tcpudp iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_mangle ip_tables x_tables ppp_generic slhc ipv6 via_rhine tulip bitrev crc32 uhci_hcd usbcore 8250_pnp 8250 serial_core i2c_viapro ide_cd floppy pcspkr
[393854.538783] CPU:    0
[393854.538785] EIP:    0060:[<c01588be>]    Not tainted VLI
[393854.538787] EFLAGS: 00010282   (2.6.23.12-K01_AthlonXP_server #1)
[393854.538902] EIP is at __d_path+0x27/0x14a
[393854.538938] eax: df13508c   ebx: 00000fff   ecx: dfe23d30   edx: 00001000
[393854.538978] esi: d1831590   edi: dfe23d30   ebp: d1831590   esp: c3ee3f68
[393854.539019] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
[393854.539059] Process sh (pid: 4834, ti=c3ee2000 task=def5faa0 task.ti=c3ee2000)
[393854.539100] Stack: dfe23d30 dffef920 000200d0 00000000 080ee1e0 d1831590 dfe23d30 dffef220 
[393854.539188]        c0159965 dffef220 df134000 00001000 df134000 fffffffe dffef920 080ee1e0 
[393854.539275]        00000000 00001000 c3ee2000 c010237e 080ee1e0 00001000 b7e9fff4 00000000 
[393854.539360] Call Trace:
[393854.539426]  [<c0159965>] sys_getcwd+0xc2/0x159
[393854.539473]  [<c010237e>] sysenter_past_esp+0x5f/0x85
[393854.539523]  =======================
[393854.539559] Code: 5e 5f 5d c3 55 89 c5 57 56 53 83 ec 10 89 54 24 04 8b 54 24 2c 8b 44 24 28 89 0c 24 8d 5a ff 01 d0 c6 40 ff 00 89 5c 24 0c 8d 48 <ff> 3b 6d 14 74 21 f6 45 04 10 74 1b 83 ea 0b 89 54 24 0c 0f 88 
[393854.539762] EIP: [<c01588be>] __d_path+0x27/0x14a SS:ESP 0068:c3ee3f68
[    0.000000] Linux version 2.6.23.12-K01_AthlonXP_server (root@dorf) (gcc version 4.1.2 (Gentoo 4.1.2)) #1 Sun Dec 23 15:00:54 JST 2007
--
[17929.575016] invalid opcode: 0000 [#1]
[17929.575056] Modules linked in: w83l785ts asb100 hwmon_vid hwmon i2c_nforce2 pppoe pppox ipt_REJECT xt_state ipt_LOG xt_limit xt_tcpudp iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_mangle ip_tables x_tables ppp_generic slhc ipv6 via_rhine tulip bitrev crc32 uhci_hcd 8250_pnp ehci_hcd 8250 serial_core usbcore floppy pcspkr ide_cd i2c_viapro
[17929.575289] CPU:    0
[17929.575290] EIP:    0060:[<c01588be>]    Not tainted VLI
[17929.575292] EFLAGS: 00010282   (2.6.23.12-K01_AthlonXP_server #1)
[17929.575395] EIP is at __d_path+0x27/0x14a
[17929.575429] eax: c8dc808c   ebx: 00000fff   ecx: dfe23d30   edx: 00001000
[17929.575468] esi: d4284114   edi: dfe23d30   ebp: d4284114   esp: c1f5df68
[17929.575512] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
[17929.575554] Process sh (pid: 21675, ti=c1f5c000 task=dba13550 task.ti=c1f5c000)
[17929.575597] Stack: dfe23d30 dffef920 000200d0 00000000 080ee1c0 d4284114 dfe23d30 dffef220 
[17929.575683]        c0159965 dffef220 c8dc7000 00001000 c8dc7000 fffffffe dffef920 080ee1c0 
[17929.575770]        00000000 00001000 c1f5c000 c010237e 080ee1c0 00001000 b7e9fff4 00000000 
[17929.575856] Call Trace:
[17929.575923]  [<c0159965>] sys_getcwd+0xc2/0x159
[17929.575970]  [<c010237e>] sysenter_past_esp+0x5f/0x85
[17929.576018]  =======================
[17929.576056] Code: 5e 5f 5d c3 55 89 c5 57 56 53 83 ec 10 89 54 24 04 8b 54 24 2c 8b 44 24 28 89 0c 24 8d 5a ff 01 d0 c6 40 ff 00 89 5c 24 0c 8d 48 <ff> 3b 6d 14 74 21 f6 45 04 10 74 1b 83 ea 0b 89 54 24 0c 0f 88 
[17929.576259] EIP: [<c01588be>] __d_path+0x27/0x14a SS:ESP 0068:c1f5df68

tr2 ~ # ps -A | grep 21675

:-( there are lots of sh processes, so I have no idea how to trace it. I
grepped through all the logs in that window, but nothing unusual popped
up.

Can anyone suggest a good way to trace that?
I had a look at the code [1], but that was beyond my asm skills :-|

[1]	http://lxr.linux.no/linux/arch/i386/kernel/entry.S#L291

Cheers,

Kalin.

-- 
|[ ~~~~~~~~~~~~~~~~~~~~~~ ]|
+-> http://ThinRope.net/ <-+
|[ ______________________ ]|

