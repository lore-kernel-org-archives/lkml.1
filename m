Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbXHCN4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbXHCN4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761695AbXHCNz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:55:57 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:13579 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761236AbXHCNzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kaEhBtxbmQrKahEPPDS9lzrewQq8Al9Cj1OpwzymTLJACBDGYmm2+Ip8FZ6W4nk2mrHex+tOcKN+tPXNnGGV29dlHHz9y6wmrtUAE65D2K8Oviq60kttVWKRzozefdGauV+cD8l0jEBXTspHlryEshnr+DZkYTWnqxKoTjJ6LNA=
Message-ID: <a44ae5cd0708030655q3c55e40j1718eb564ab4f368@mail.gmail.com>
Date: Fri, 3 Aug 2007 09:55:55 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc1-mm2 + cpufreq patch -- another "inconsistent {in-hardirq-W} -> {hardirq-on-W} usage."
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I ran "modprobe -r ipw2200" I got:

=================================
[ INFO: inconsistent lock state ]
2.6.23-rc1-mm2 #21
---------------------------------
inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
modprobe/6888 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&priv->irq_lock){++..}, at: [<f8ce9b1c>] ipw_isr+0x1c/0xa9 [ipw2200]
{in-hardirq-W} state was registered at:
  [<c0144837>] __lock_acquire+0x430/0xbca
  [<c0145047>] lock_acquire+0x76/0x9d
  [<c031ffe0>] _spin_lock+0x23/0x32
  [<f8ce9b1c>] ipw_isr+0x1c/0xa9 [ipw2200]
  [<c0154b44>] handle_IRQ_event+0x1a/0x4f
  [<c0155c6c>] handle_fasteoi_irq+0x7d/0xb6
  [<c0109a5a>] do_IRQ+0xaf/0xd9
  [<ffffffff>] 0xffffffff
irq event stamp: 136973
hardirqs last  enabled at (136973): [<c0173232>] kfree+0xc7/0xdb
hardirqs last disabled at (136972): [<c01731d2>] kfree+0x67/0xdb
softirqs last  enabled at (136286): [<c012d8a1>] __do_softirq+0xf5/0xfb
softirqs last disabled at (136277): [<c0109932>] do_softirq+0x74/0xed

other info that might help us debug this:
no locks held by modprobe/6888.

stack backtrace:
 [<c01080ab>] show_trace_log_lvl+0x12/0x25
 [<c0108a9e>] show_trace+0xd/0x10
 [<c0108bac>] dump_stack+0x16/0x18
 [<c0143374>] print_usage_bug+0x107/0x114
 [<c0143bdd>] mark_lock+0x1e9/0x400
 [<c01448ab>] __lock_acquire+0x4a4/0xbca
 [<c0145047>] lock_acquire+0x76/0x9d
 [<c031ffe0>] _spin_lock+0x23/0x32
 [<f8ce9b1c>] ipw_isr+0x1c/0xa9 [ipw2200]
 [<c015506f>] free_irq+0xc9/0xf2
 [<f8cea09c>] ipw_pci_remove+0x189/0x1c9 [ipw2200]
 [<c0206dec>] pci_device_remove+0x19/0x39
 [<c026a23a>] __device_release_driver+0x74/0x90
 [<c026a6b6>] driver_detach+0xa2/0xe0
 [<c0269dc5>] bus_remove_driver+0x5d/0x79
 [<c026a71b>] driver_unregister+0x8/0xa
 [<c0206f56>] pci_unregister_driver+0x13/0x55
 [<f8cead75>] ipw_exit+0x1c/0x1e [ipw2200]
 [<c014c85f>] sys_delete_module+0x1c6/0x237
 [<c0106f02>] sysenter_past_esp+0x6b/0xb5
 =======================
