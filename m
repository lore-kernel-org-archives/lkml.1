Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbXGNXCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbXGNXCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbXGNXCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:02:01 -0400
Received: from hu-out-0506.google.com ([72.14.214.228]:43775 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbXGNXB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=pgcqdTXTXfyg00SJ2Hf4bZ3/kXETTNgPFdB9gly1DI0u3wz3k08ujwiFnKFAtlfE6ggUwALaMxRmdwznYiBfCY48wJvwgWuetCZ2ojnOpYOjUxEdl+fecVD192VqJdQqr0agnKcFxrDjJKjjuUH5MgjJcw41qD1lduDubr02pao=
Date: Sun, 15 Jul 2007 01:01:54 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Doug Thompson <norsk5@xmission.com>
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [2.6.22] edac: sleeping function called from invalid context
Message-ID: <20070714230154.GA22439@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
as soon as I enable parity check on PCI bus (with polling - EDAC_POLL),
the following warning is triggered:

EDAC MC: Ver: 2.0.1 Jul 13 2007
BUG: sleeping function called from invalid context at /home/kronos/src/linux-2.6.git/kernel/rwsem.c:20
in_atomic():0, irqs_disabled():1
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<00000000>] 0x0
hardirqs last disabled at (0): [<c0120063>] copy_process+0x363/0x11e8
softirqs last  enabled at (0): [<c0120063>] copy_process+0x363/0x11e8
softirqs last disabled at (0): [<00000000>] 0x0
 [<c0134fb2>] down_read+0x15/0x49
 [<c02f4669>] schedule_timeout+0x79/0x8d
 [<c01deef0>] pci_get_subsys+0x68/0xea
 [<c01298a4>] process_timeout+0x0/0x5
 [<c01def88>] pci_get_device+0x16/0x19
 [<fa4b98cd>] edac_kernel_thread+0x94/0x10c [edac_mc]
 [<fa4b9839>] edac_kernel_thread+0x0/0x10c [edac_mc]
 [<c0132264>] kthread+0x38/0x60
 [<c013222c>] kthread+0x0/0x60
 [<c0104ae7>] kernel_thread_helper+0x7/0x10
 =======================

The warning is caused by the fact that do_pci_parity_check() calls
edac_pci_dev_parity_iterator() with interrupts disabled and
pci_get_device acquires pci_bus_sem (via pci_get_subsys).


Luca
-- 
"La mia teoria scientifica preferita e` quella secondo la quale gli 
 anelli di Saturno sarebbero interamente composti dai bagagli andati 
 persi nei viaggi aerei." -- Mark Russel
