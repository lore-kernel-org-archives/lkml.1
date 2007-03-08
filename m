Return-Path: <linux-kernel-owner+w=401wt.eu-S1030841AbXCHWyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030841AbXCHWyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030847AbXCHWyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:54:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030841AbXCHWyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:54:40 -0500
Date: Thu, 8 Mar 2007 17:54:36 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: samuel@sortiz.org
Subject: irda rmmod lockdep trace.
Message-ID: <20070308225436.GA25184@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, samuel@sortiz.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

modprobe irda ; rmmod irda in 2.6.21rc3 gets me the spew below..

	Dave

NET: Registered protocol family 23
NET: Unregistered protocol family 23

=============================================
[ INFO: possible recursive locking detected ]
2.6.20-1.2966.fc7 #1
---------------------------------------------
rmmod/16712 is trying to acquire lock:
 (&hashbin->hb_spinlock){....}, at: [<ffffffff884bf476>] hashbin_delete+0x29/0x94 [irda]

but task is already holding lock:
 (&hashbin->hb_spinlock){....}, at: [<ffffffff884bf476>] hashbin_delete+0x29/0x94 [irda]

other info that might help us debug this:
1 lock held by rmmod/16712:
 #0:  (&hashbin->hb_spinlock){....}, at: [<ffffffff884bf476>] hashbin_delete+0x29/0x94 [irda]

stack backtrace:

Call Trace:
 [<ffffffff802a303b>] __lock_acquire+0x151/0xbc4
 [<ffffffff884c1517>] :irda:__irias_delete_attrib+0x0/0x31
 [<ffffffff802a3ea4>] lock_acquire+0x4c/0x65
 [<ffffffff884bf476>] :irda:hashbin_delete+0x29/0x94
 [<ffffffff80264011>] _spin_lock_irqsave+0x2c/0x3c
 [<ffffffff884bf476>] :irda:hashbin_delete+0x29/0x94
 [<ffffffff884c1918>] :irda:__irias_delete_object+0x0/0x39
 [<ffffffff884c193d>] :irda:__irias_delete_object+0x25/0x39
 [<ffffffff884bf48d>] :irda:hashbin_delete+0x40/0x94
 [<ffffffff884c5e3a>] :irda:iriap_cleanup+0x36/0x38
 [<ffffffff884c5fd6>] :irda:irda_cleanup+0x29/0x3a
 [<ffffffff802aa1e1>] sys_delete_module+0x199/0x1ca
 [<ffffffff8026ce36>] syscall_trace_enter+0x9a/0x9f
 [<ffffffff8025c2b5>] tracesys+0xdc/0xe1


-- 
http://www.codemonkey.org.uk
