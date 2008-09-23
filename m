Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYIWTcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYIWTcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYIWTco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:32:44 -0400
Received: from main.gmane.org ([80.91.229.2]:58318 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbYIWTco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:32:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [kmemcheck] read from uninitialized memory by netlink_broadcast?
Date: Tue, 23 Sep 2008 20:32:41 +0100
Message-ID: <48D94459.7010501@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: vegard.nossum@gmail.com
X-Gmane-NNTP-Posting-Host: 87.112.14.28.plusnet.ptn-ag1.dyn.plus.net
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing today's linux-tip I received a kmemcheck warning. Is this 
a spurious or already known report?

[   14.183601] kmemcheck: Caught 32-bit read from uninitialized memory 
(f7021f14)
[   14.183601] 
0100000000000000000000000000000000000000000000000000000000000000
[   14.185062]  i i i i i i i i i i i i i i i i i i i i u u u u u u u u 
u u u u
[   14.186453]                                          ^
[   14.186528]
[   14.186595] Pid: 3, comm: ksoftirqd/0 Not tainted 
(2.6.27-rc7-tipskw-00756-g6522eab #6) 900
[   14.186701] EIP: 0060:[<c034ca1f>] EFLAGS: 00000282 CPU: 0
[   14.186787] EIP is at pskb_expand_head+0x9f/0x160
[   14.186861] EAX: 00000080 EBX: f72c96c0 ECX: 00000036 EDX: f727f200
[   14.186927] ESI: f7021f14 EDI: f727f294 EBP: f7099eb4 ESP: c0543a88
[   14.187006]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   14.187083] CR0: 8005003b CR2: f7305700 CR3: 00534000 CR4: 000006d0
[   14.187162] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   14.187241] DR6: ffff4ff0 DR7: 00000400
[   14.187312]  [<c0362ea8>] netlink_broadcast+0x68/0x370
[   14.187432]  [<c0365a4f>] genl_ctrl_event+0x30f/0x330
[   14.187548]  [<c0365fb6>] genl_register_mc_group+0xe6/0x140
[   14.187666]  [<c0515fdf>] genl_init+0x9f/0xe0
[   14.187781]  [<c010102f>] _stext+0x2f/0x160
[   14.187893]  [<c04f48e3>] kernel_init+0xc3/0x1a0
[   14.187997]  [<c010403b>] kernel_thread_helper+0x7/0x10
[   14.188114]  [<ffffffff>] 0xffffffff


-- 
Sitsofe | http://sucs.org/~sits/

