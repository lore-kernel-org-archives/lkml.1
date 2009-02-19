Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZBSTRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZBSTRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZBSTRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:17:41 -0500
Received: from sargon.lncsa.com ([212.99.8.251]:55371 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbZBSTRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:40 -0500
Message-ID: <499DB04A.20301@lncsa.com>
Date: Thu, 19 Feb 2009 20:17:30 +0100
From: Laurent CARON <lcaron@lncsa.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Strange skbuff.c bug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm experiencing a strange bug while using heartbeat while it is sending 
ARPs:

Feb 19 20:14:30 lyon kernel: WARNING: at net/core/skbuff.c:150 
skb_truesize_bug+0x2e/0x33()
Feb 19 20:14:30 lyon kernel: SKB BUG: Invalid truesize (304) len=182, 
sizeof(sk_buff)=176
Feb 19 20:14:30 lyon kernel: Modules linked in: xt_TCPMSS ctr camellia 
xcbc rmd160 dm_snapshot ipmi_poweroff ipmi_devintf ipmi_si 
ipmi_msghandler iTCO_wdt
Feb 19 20:14:30 lyon kernel: Pid: 9920, comm: send_arp Tainted: G 
  W  2.6.28.6-sc4xx-ml150 #1
Feb 19 20:14:30 lyon kernel: Call Trace:
Feb 19 20:14:30 lyon kernel: [<c011f14c>] warn_slowpath+0x61/0x78
Feb 19 20:14:30 lyon kernel: [<c011817e>] update_curr+0x5c/0x95
Feb 19 20:14:30 lyon kernel: [<c052999d>] schedule+0x58c/0x5dc
Feb 19 20:14:30 lyon kernel: [<c0529aca>] schedule_timeout+0x13/0x86
Feb 19 20:14:30 lyon kernel: [<c01579fd>] slab_destroy+0x2b/0x40
Feb 19 20:14:30 lyon kernel: [<c0157aca>] free_block+0xb8/0xf4
Feb 19 20:14:30 lyon kernel: [<c0469256>] skb_truesize_bug+0x2e/0x33
Feb 19 20:14:30 lyon kernel: [<c0465f24>] sock_rfree+0x1e/0x43
Feb 19 20:14:30 lyon kernel: [<c04688cb>] skb_release_head_state+0x4d/0x9a
Feb 19 20:14:30 lyon kernel: [<c0468ed4>] skb_release_all+0x8/0x10
Feb 19 20:14:30 lyon kernel: [<c04687e5>] __kfree_skb+0x8/0x63
Feb 19 20:14:30 lyon kernel: [<c0468871>] skb_queue_purge+0xa/0x17
Feb 19 20:14:30 lyon kernel: [<c04e238c>] packet_release+0x137/0x153
Feb 19 20:14:30 lyon kernel: [<c046429d>] sock_release+0x11/0x59
Feb 19 20:14:30 lyon kernel: [<c0464657>] sock_close+0x19/0x1c
Feb 19 20:14:30 lyon kernel: [<c015b2c3>] __fput+0xa6/0x14a
Feb 19 20:14:30 lyon kernel: [<c01590dd>] filp_close+0x4d/0x53
Feb 19 20:14:30 lyon kernel: [<c01205dd>] put_files_struct+0x5f/0xa7
Feb 19 20:14:30 lyon kernel: [<c0121580>] do_exit+0x172/0x654
Feb 19 20:14:30 lyon kernel: [<c011341b>] do_page_fault+0x239/0x546
Feb 19 20:14:30 lyon kernel: [<c0121abc>] do_group_exit+0x5a/0x83
Feb 19 20:14:30 lyon kernel: [<c0121af2>] sys_exit_group+0xd/0x10
Feb 19 20:14:30 lyon kernel: [<c0102be5>] sysenter_do_call+0x12/0x25
Feb 19 20:14:30 lyon kernel: ---[ end trace 173ef0824595f8e2 ]---


Do anyone have a clue about it ?

Thanks
