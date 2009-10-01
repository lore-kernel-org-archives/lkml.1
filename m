Return-Path: <linux-kernel-owner+w=401wt.eu-S932161AbZJALIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbZJALIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 07:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbZJALIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 07:08:09 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:41849 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbZJALII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 07:08:08 -0400
Date: Thu, 1 Oct 2009 13:08:08 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31: WARNING: at net/ipv4/af_inet.c:154
 inet_sock_destruct+0x164/0x1c0()
Message-ID: <20091001110807.GB11780@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20090930122441.GB17974@charite.de>
 <4AC350C0.4040605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AC350C0.4040605@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We believe following patch should fix this problem.
> 
> http://lkml.org/lkml/2009/9/29/62

Nope. I applied the patch to 2.6.31.1, rebooted. And now I'm seeing:

Oct  1 13:05:41 vpn-gw-int kernel: [79964.507696] ------------[ cut here ]------------
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507696] ------------[ cut here ]------------
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507706] WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct+0x164/0x1c0()
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507706] WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct+0x164/0x1c0()
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507709] Hardware name: ProLiant DL360 G4p
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507709] Hardware name: ProLiant DL360 G4p
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507711] Modules linked in: ipt_REJECT ipt_LOG xt_multiport tun xt_tcpudp xt_state iptable_nat
nf_nat iptable_filter ip_tables x_tables nf_conntrack_ipv4 nf_defrag_ipv4 ipv6 psmouse nf_conntrack_ftp nf_conntrack tg3 libphy
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507711] Modules linked in: ipt_REJECT ipt_LOG xt_multiport tun xt_tcpudp xt_state iptable_nat
nf_nat iptable_filter ip_tables x_tables nf_conntrack_ipv4 nf_defrag_ipv4 ipv6 psmouse nf_conntrack_ftp nf_conntrack tg3 libphy
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507734] Pid: 15083, comm: openvpn Not tainted 2.6.31.1 #1
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507734] Pid: 15083, comm: openvpn Not tainted 2.6.31.1 #1
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507736] Call Trace: Oct  1 13:05:41 vpn-gw-int kernel: [79964.507736] Call Trace:
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507742]  [<c126d2b4>] ? inet_sock_destruct+0x164/0x1c0
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507742]  [<c126d2b4>] ? inet_sock_destruct+0x164/0x1c0
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507748]  [<c103270b>] ? warn_slowpath_common+0x6f/0xcd
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507748]  [<c103270b>] ? warn_slowpath_common+0x6f/0xcd
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507752]  [<c126d2b4>] ? inet_sock_destruct+0x164/0x1c0
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507752]  [<c126d2b4>] ? inet_sock_destruct+0x164/0x1c0
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507756]  [<c1032789>] ? warn_slowpath_null+0x20/0x3c
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507756]  [<c1032789>] ? warn_slowpath_null+0x20/0x3c
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507760]  [<c126d2b4>] ? inet_sock_destruct+0x164/0x1c0
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507760]  [<c126d2b4>] ? inet_sock_destruct+0x164/0x1c0
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507764]  [<c128bf1b>] ? _spin_lock_bh+0x16/0x40
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507764]  [<c128bf1b>] ? _spin_lock_bh+0x16/0x40
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507768]  [<c128bf1b>] ? _spin_lock_bh+0x16/0x40
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507768]  [<c128bf1b>] ? _spin_lock_bh+0x16/0x40
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507773]  [<c121bdc8>] ? __sk_free+0x21/0xd6
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507773]  [<c121bdc8>] ? __sk_free+0x21/0xd6
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507777]  [<c121bf9c>] ? sk_common_release+0x5b/0x97
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507777]  [<c121bf9c>] ? sk_common_release+0x5b/0x97
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507780]  [<c126cd65>] ? inet_release+0x39/0x66
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507780]  [<c126cd65>] ? inet_release+0x39/0x66
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507784]  [<c1218ffa>] ? sock_release+0x22/0x8d
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507784]  [<c1218ffa>] ? sock_release+0x22/0x8d
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507787]  [<c1219081>] ? sock_close+0x1c/0x42
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507787]  [<c1219081>] ? sock_close+0x1c/0x42
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507792]  [<c10a132c>] ? __fput+0xd6/0x1e0
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507792]  [<c10a132c>] ? __fput+0xd6/0x1e0
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507796]  [<c109de04>] ? filp_close+0x41/0x72
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507796]  [<c109de04>] ? filp_close+0x41/0x72
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507799]  [<c109deaa>] ? sys_close+0x75/0xc0
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507799]  [<c109deaa>] ? sys_close+0x75/0xc0
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507804]  [<c1002ecf>] ? sysenter_do_call+0x12/0x26
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507804]  [<c1002ecf>] ? sysenter_do_call+0x12/0x26
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507807] ---[ end trace 37b30e0c4f46add6 ]---
Oct  1 13:05:41 vpn-gw-int kernel: [79964.507807] ---[ end trace 37b30e0c4f46add6 ]---

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12203 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  ralf.hildebrandt@charite.de | http://www.charite.de
	    
