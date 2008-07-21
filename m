Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYGUQOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYGUQOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYGUQO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:14:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:19651 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYGUQO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=iFp3ymr/4LOlPgj0iNZ28qmg5DaGwjdfd6ak9VxETOSKmIlblzr0VL1m5uX0eeYZo+
         439KHfnkg2HK281J09OQIqv36QpJUVih7cP/gvCKlBR1w2Rapzln1DSjMUPt8p0gXFgb
         PeSXelzXc0TWR6GOi9U6IpuHYgdl71VwNJB04=
Message-ID: <d4b984a30807210914nd4d0db5yb7b93ca5143ff0d5@mail.gmail.com>
Date: Mon, 21 Jul 2008 18:14:28 +0200
From: "Alessandro Guido" <ag@alessandroguido.name>
To: linux-kernel@vger.kernel.org
Subject: [BUG] kernel BUG at net/core/dev.c:1328!
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: c6dceef83af3a958
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is what I get when try to det up a wireless connection with
current git (v2.6.26-5253-g14b395e):


kernel BUG at net/core/dev.c:1328!
invalid opcode: 0000 [#1] PREEMPT
Modules linked in: ipw2200

Pid: 5, comm: events/0 Not tainted (2.6.26-05253-g14b395e #1)
EIP: 0060:[<c02e58ca>] EFLAGS: 00010246 CPU: 0
EIP is at __netif_schedule+0x3a/0x40
EAX: c043d380 EBX: eed84b40 ECX: c043d380 EDX: ffffffff
ESI: eed84b44 EDI: ef808140 EBP: ef82bf64 ESP: ef82bf60
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process events/0 (pid: 5, ti=ef82b000 task=ef82cd40 task.ti=ef82b000)
Stack: eed84b40 ef82bf80 f0939850 ef808140 ef82bf78 c02ef6c2 eed8584c ef808140
       ef82bfa8 c012b02f ef82ce9c ee24fc00 ef82ce9c ffff007b f09396f0 ef808148
       ef808140 ef82bfb0 ef82bfd0 c012b53f 00000000 ef82cd40 c012eaf0 ef82bfbc
Call Trace:
 [<f0939850>] ? ipw_bg_link_up+0x160/0x1f0 [ipw2200]
 [<c02ef6c2>] ? rtnl_unlock+0x12/0x20
 [<c012b02f>] ? run_workqueue+0x6f/0x160
 [<f09396f0>] ? ipw_bg_link_up+0x0/0x1f0 [ipw2200]
 [<c012b53f>] ? worker_thread+0x7f/0xe0
 [<c012eaf0>] ? autoremove_wake_function+0x0/0x50
 [<c012b4c0>] ? worker_thread+0x0/0xe0
 [<c012e67a>] ? kthread+0x3a/0x70
 [<c012e640>] ? kthread+0x0/0x70
 [<c0103c8f>] ? kernel_thread_helper+0x7/0x18
 =======================
Code: 24 0f ba 28 01 19 d2 85 d2 75 1d 9c 5b fa a1 c0 11 4a c0 89 41
3c b8 02 00 00 00 89 0d c0 11 4a c0 e8 4b ab e3 ff 53 9d 5b 5d c3 <0f>
0b eb fe 66 90 55 89 e5 53 89 c3 8d 40 2c 0f ba 28 01 19 d2
EIP: [<c02e58ca>] __netif_schedule+0x3a/0x40 SS:ESP 0068:ef82bf60
