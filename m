Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbXK2Mik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbXK2Mik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbXK2Mib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:38:31 -0500
Received: from rossini.marcant.net ([217.14.160.69]:42358 "EHLO
	admins.marcant.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754561AbXK2Mia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:38:30 -0500
X-Greylist: delayed 1684 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 07:38:29 EST
Date: Thu, 29 Nov 2007 13:10:23 +0100
From: Dirk Nehring <dnehring@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: IPSec ESP kernel crash
Message-ID: <20071129121023.GA17728@marcant.net>
Reply-To: linux-kernel@vger.kernel.org, dnehring@gmx.net
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

[please set me on Cc: since I am not on linux-kernel]

we reproduce random kernel crashes with CentOS5 or RHEL5 kernels
(2.6.18-x). ESP_input produces an error (see attachment). We set up VPN
connections to netscreen firewalls or the Cisco PIX, the crashes occurs
only after some time (20min up to 3days!), so it is not easy to
reproduce. I attach a stacktrace (this one was captured in a VM, but it
also happens on physical machines). We assume it is a bug in 2.6.18, I
haven't check if it is fixed in newer versions.

Can anyone help us?

Dirk

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ari-fw-bug.txt"
Content-Transfer-Encoding: quoted-printable

root@firewall:~# ------------[ cut here ]------------
kernel BUG at include/linux/skbuff.h:887!
invalid opcode: 0000 [#1]
SMP
last sysfs file: /class/net/lo/type
Modules linked in: i2c_dev(U) i2c_core(U) iptable_raw(U) xt_comment(U) xt_p=
olicy(U) ipt_ULOG(U) ipt_TTL(U) ipt_ttl(U) ipt_TOS(U) ipt_tos(U) ipt_TCPMSS=
(U) ipt_SAME(U) ipt_REJECT(U) ipt_REDIRECT(U) ipt_recent(U) ipt_owner(U) ip=
t_NETMAP(U) ipt_MASQUERADE(U) ipt_LOG(U) ipt_iprange(U) ipt_hashlimit(U) ip=
t_ECN(U) ipt_ecn(U) ipt_DSCP(U) ipt_dscp(U) ipt_CLUSTERIP(U) ipt_ah(U) ipt_=
addrtype(U) ip_nat_tftp(U) ip_nat_snmp_basic(U) ip_nat_sip(U) ip_nat_pptp(U=
) ip_nat_irc(U) ip_nat_h323(U) ip_nat_ftp(U) ip_nat_amanda(U) ip_conntrack_=
tftp(U) ip_conntrack_sip(U) ip_conntrack_pptp(U) ip_conntrack_netbios_ns(U)=
 ip_conntrack_irc(U) ip_conntrack_h323(U) ip_conntrack_ftp(U) ts_kmp(U) ip_=
conntrack_amanda(U) xt_tcpmss(U) xt_pkttype(U) xt_physdev(U) bridge(U) xt_N=
FQUEUE(U) xt_multiport(U) xt_MARK(U) xt_mark(U) xt_mac(U) xt_limit(U) xt_le=
ngth(U) xt_helper(U) xt_dccp(U) xt_conntrack(U) xt_CONNMARK(U) xt_connmark(=
U) xt_CLASSIFY(U) xt_tcpudp(U) xt_state(U) xfrm4_mode_tunnel(U) esp4(U) ipt=
able_nat(U) ip_nat(U) ip_conntrack(U) iptable_mangle(U) nfnetlink(U) iptabl=
e_filter(U) ip_tables(U) x_tables(U) tun(U) deflate(U) zlib_deflate(U) twof=
ish(U) serpent(U) aes(U) blowfish(U) des(U) sha256(U) md5(U) crypto_null(U)=
 af_key(U) xennet(U) ext3(U) jbd(U) xenblk(U)
CPU:    0
EIP:    0061:[<c91737ef>]    Not tainted VLI
EFLAGS: 00010293   (2.6.18-8.1.8.el5.0.1.0xen #1)
EIP is at esp_input+0x2c1/0x2f8 [esp4]
eax: 000005a0   ebx: c54e8180   ecx: 000005a8   edx: 00000018
esi: c0c94c80   edi: c550e820   ebp: c06fbe88   esp: c06fbe3c
ds: 007b   es: 007b   ss: 0069
Process swapper (pid: 0, ti=3Dc06fb000 task=3Dc0653940 task.ti=3Dc06c7000)
Stack: c06fbe00 c06fbe3c c60c8600 00000010 c0c94c80 0000000c 000005b0 00000=
002
       00000014 0000000e c06844d0 00000000 00000032 c05e6a9c c5560780 040e8=
180
       c60c8600 00000000 00000002 00000000 c05e380f c06fbe9c c54e8180 80000=
000
Call Trace:
 [<c05e6a9c>] xfrm_state_lookup+0x43/0x52
 [<c05e380f>] xfrm4_rcv_encap+0xf3/0x3a8
 [<c05b6c28>] ip_local_deliver+0x159/0x205
 [<c05b6a95>] ip_rcv+0x3ef/0x429
 [<c059c509>] netif_receive_skb+0x2dd/0x355
 [<c901fd01>] netif_poll+0x8e5/0xa52 [xennet]
 [<c059df0f>] net_rx_action+0x96/0x185
 [<c041ffd3>] __do_softirq+0x5e/0xc3
 [<c040679c>] do_softirq+0x56/0xae
 [<c040673d>] do_IRQ+0xa5/0xae
 [<c053a155>] evtchn_do_upcall+0x64/0x9b
 [<c0404ec5>] hypervisor_callback+0x3d/0x48
 [<c0407fd1>] raw_safe_halt+0x8c/0xaf
 [<c0402bca>] xen_idle+0x22/0x2e
 [<c0402ce9>] cpu_idle+0x91/0xab
 [<c06cc799>] start_kernel+0x381/0x388
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: ef 51 42 f7 eb 0f 89 43 60 03 83 a0 00 00 00 89 83 a4 00 00 00 8b 75 =
c4 8b 43 60 8b 56 6c 83 c2 08 29 d0 3b 43 64 89 43 60 73 08 <0f> 0b 77 03 4=
b 3b 17 c9 89 d0 03 83 a0 00 00 00 89 83 a0 00 00
EIP: [<c91737ef>] esp_input+0x2c1/0x2f8 [esp4] SS:ESP 0069:c06fbe3c
 <0>Kernel panic - not syncing: Fatal exception in interrupt
=0C
root@firewall:~# ------------[ cut here ]------------
kernel BUG at include/linux/skbuff.h:887!
invalid opcode: 0000 [#1]
SMP
last sysfs file: /class/net/lo/type
Modules linked in: xfrm4_mode_tunnel(U) esp4(U) i2c_dev(U) i2c_core(U) ipta=
ble_raw(U) xt_comment(U) xt_policy(U) ipt_ULOG(U) ipt_TTL(U) ipt_ttl(U) ipt=
_TOS(U) ipt_tos(U) ipt_TCPMSS(U) ipt_SAME(U) ipt_REJECT(U) ipt_REDIRECT(U) =
ipt_recent(U) ipt_owner(U) ipt_NETMAP(U) ipt_MASQUERADE(U) ipt_LOG(U) ipt_i=
prange(U) ipt_hashlimit(U) ipt_ECN(U) ipt_ecn(U) ipt_DSCP(U) ipt_dscp(U) ip=
t_CLUSTERIP(U) ipt_ah(U) ipt_addrtype(U) ip_nat_tftp(U) ip_nat_snmp_basic(U=
) ip_nat_sip(U) ip_nat_pptp(U) ip_nat_irc(U) ip_nat_h323(U) ip_nat_ftp(U) i=
p_nat_amanda(U) ip_conntrack_tftp(U) ip_conntrack_sip(U) ip_conntrack_pptp(=
U) ip_conntrack_netbios_ns(U) ip_conntrack_irc(U) ip_conntrack_h323(U) ip_c=
onntrack_ftp(U) ts_kmp(U) ip_conntrack_amanda(U) xt_tcpmss(U) xt_pkttype(U)=
 xt_physdev(U) bridge(U) xt_NFQUEUE(U) xt_multiport(U) xt_MARK(U) xt_mark(U=
) xt_mac(U) xt_limit(U) xt_length(U) xt_helper(U) xt_dccp(U) xt_conntrack(U=
) xt_CONNMARK(U) xt_connmark(U) xt_CLASSIFY(U) xt_tcpudp(U) xt_state(U) ipt=
able_nat(U) ip_nat(U) ip_conntrack(U) iptable_mangle(U) nfnetlink(U) iptabl=
e_filter(U) ip_tables(U) x_tables(U) tun(U) deflate(U) zlib_deflate(U) twof=
ish(U) serpent(U) aes(U) blowfish(U) des(U) sha256(U) md5(U) crypto_null(U)=
 af_key(U) xennet(U) ext3(U) jbd(U) xenblk(U)
CPU:    0
EIP:    0061:[<c90267ef>]    Not tainted VLI
EFLAGS: 00010293   (2.6.18-8.1.8.el5.0.1.0xen #1)
EIP is at esp_input+0x2c1/0x2f8 [esp4]
eax: 000005a0   ebx: c01949c0   ecx: 000005a8   edx: 00000018
esi: c3fdb580   edi: c4919020   ebp: c06fbe88   esp: c06fbe3c
ds: 007b   es: 007b   ss: 0069
Process swapper (pid: 0, ti=3Dc06fb000 task=3Dc0653940 task.ti=3Dc06c7000)
Stack: c06fbe00 c06fbe3c c0192e00 00000010 c3fdb580 0000000c 000005b0 00000=
002
       00000014 0000000e c06844d0 00000000 00000032 c05e6a9c c4f3bcc0 040e4=
9c0
       c0192e00 00000000 00000002 00000000 c05e380f c06fbe9c c01949c0 80000=
000
Call Trace:
 [<c05e6a9c>] xfrm_state_lookup+0x43/0x52
 [<c05e380f>] xfrm4_rcv_encap+0xf3/0x3a8
 [<c05b6c28>] ip_local_deliver+0x159/0x205
 [<c05b6a95>] ip_rcv+0x3ef/0x429
 [<c059c509>] netif_receive_skb+0x2dd/0x355
 [<c901fd01>] netif_poll+0x8e5/0xa52 [xennet]
 [<c059df0f>] net_rx_action+0x96/0x185
 [<c041ffd3>] __do_softirq+0x5e/0xc3
 [<c040679c>] do_softirq+0x56/0xae
 [<c040673d>] do_IRQ+0xa5/0xae
 [<c053a155>] evtchn_do_upcall+0x64/0x9b
 [<c0404ec5>] hypervisor_callback+0x3d/0x48
 [<c0407fd1>] raw_safe_halt+0x8c/0xaf
 [<c0402bca>] xen_idle+0x22/0x2e
 [<c0402ce9>] cpu_idle+0x91/0xab
 [<c06cc799>] start_kernel+0x381/0x388
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: ef 21 57 f7 eb 0f 89 43 60 03 83 a0 00 00 00 89 83 a4 00 00 00 8b 75 =
c4 8b 43 60 8b 56 6c 83 c2 08 29 d0 3b 43 64 89 43 60 73 08 <0f> 0b 77 03 4=
b 6b 02 c9 89 d0 03 83 a0 00 00 00 89 83 a0 00 00
EIP: [<c90267ef>] esp_input+0x2c1/0x2f8 [esp4] SS:ESP 0069:c06fbe3c
 <0>Kernel panic - not syncing: Fatal exception in interrupt
=0C
root@firewall:~# ------------[ cut here ]------------
kernel BUG at include/linux/skbuff.h:887!
invalid opcode: 0000 [#1]
SMP
last sysfs file: /class/net/lo/type
Modules linked in: xfrm4_mode_tunnel(U) esp4(U) i2c_dev(U) i2c_core(U) ipta=
ble_raw(U) xt_comment(U) xt_policy(U) ipt_ULOG(U) ipt_TTL(U) ipt_ttl(U) ipt=
_TOS(U) ipt_tos(U) ipt_TCPMSS(U) ipt_SAME(U) ipt_REJECT(U) ipt_REDIRECT(U) =
ipt_recent(U) ipt_owner(U) ipt_NETMAP(U) ipt_MASQUERADE(U) ipt_LOG(U) ipt_i=
prange(U) ipt_hashlimit(U) ipt_ECN(U) ipt_ecn(U) ipt_DSCP(U) ipt_dscp(U) ip=
t_CLUSTERIP(U) ipt_ah(U) ipt_addrtype(U) ip_nat_tftp(U) ip_nat_snmp_basic(U=
) ip_nat_sip(U) ip_nat_pptp(U) ip_nat_irc(U) ip_nat_h323(U) ip_nat_ftp(U) i=
p_nat_amanda(U) ip_conntrack_tftp(U) ip_conntrack_sip(U) ip_conntrack_pptp(=
U) ip_conntrack_netbios_ns(U) ip_conntrack_irc(U) ip_conntrack_h323(U) ip_c=
onntrack_ftp(U) ts_kmp(U) ip_conntrack_amanda(U) xt_tcpmss(U) xt_pkttype(U)=
 xt_physdev(U) bridge(U) xt_NFQUEUE(U) xt_multiport(U) xt_MARK(U) xt_mark(U=
) xt_mac(U) xt_limit(U) xt_length(U) xt_helper(U) xt_dccp(U) xt_conntrack(U=
) xt_CONNMARK(U) xt_connmark(U) xt_CLASSIFY(U) xt_tcpudp(U) xt_state(U) ipt=
able_nat(U) ip_nat(U) ip_conntrack(U) iptable_mangle(U) nfnetlink(U) iptabl=
e_filter(U) ip_tables(U) x_tables(U) tun(U) deflate(U) zlib_deflate(U) twof=
ish(U) serpent(U) aes(U) blowfish(U) des(U) sha256(U) md5(U) crypto_null(U)=
 af_key(U) xennet(U) ext3(U) jbd(U) xenblk(U)
CPU:    0
EIP:    0061:[<c90267ef>]    Not tainted VLI
EFLAGS: 00010293   (2.6.18-8.1.8.el5.0.1.0xen #1)
EIP is at esp_input+0x2c1/0x2f8 [esp4]
eax: 000005a0   ebx: c13ad0c0   ecx: 000005a8   edx: 00000018
esi: c088b480   edi: c56d8020   ebp: c06fbe88   esp: c06fbe3c
ds: 007b   es: 007b   ss: 0069
Process swapper (pid: 0, ti=3Dc06fb000 task=3Dc0653940 task.ti=3Dc06c7000)
Stack: c06fbe00 c06fbe3c c5804800 00000010 c088b480 0000000c 000005b0 00000=
002
       00000014 0000000e c06844d0 00000000 00000032 c05e6a9c c4d05e40 040ed=
0c0
       c5804800 00000000 00000002 00000000 c05e380f c06fbe9c c13ad0c0 80000=
000
Call Trace:
 [<c05e6a9c>] xfrm_state_lookup+0x43/0x52
 [<c05e380f>] xfrm4_rcv_encap+0xf3/0x3a8
 [<c05b6c28>] ip_local_deliver+0x159/0x205
 [<c05b6a95>] ip_rcv+0x3ef/0x429
 [<c059c509>] netif_receive_skb+0x2dd/0x355
 [<c901fd01>] netif_poll+0x8e5/0xa52 [xennet]
 [<c059df0f>] net_rx_action+0x96/0x185
 [<c041ffd3>] __do_softirq+0x5e/0xc3
 [<c040679c>] do_softirq+0x56/0xae
 [<c040673d>] do_IRQ+0xa5/0xae
 [<c053a155>] evtchn_do_upcall+0x64/0x9b
 [<c0404ec5>] hypervisor_callback+0x3d/0x48
 [<c0407fd1>] raw_safe_halt+0x8c/0xaf
 [<c0402bca>] xen_idle+0x22/0x2e
 [<c0402ce9>] cpu_idle+0x91/0xab
 [<c06cc799>] start_kernel+0x381/0x388
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: ef 21 57 f7 eb 0f 89 43 60 03 83 a0 00 00 00 89 83 a4 00 00 00 8b 75 =
c4 8b 43 60 8b 56 6c 83 c2 08 29 d0 3b 43 64 89 43 60 73 08 <0f> 0b 77 03 4=
b 6b 02 c9 89 d0 03 83 a0 00 00 00 89 83 a0 00 00
EIP: [<c90267ef>] esp_input+0x2c1/0x2f8 [esp4] SS:ESP 0069:c06fbe3c
 <0>Kernel panic - not syncing: Fatal exception in interrupt

--Nq2Wo0NMKNjxTN9z--
