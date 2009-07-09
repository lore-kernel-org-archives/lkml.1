Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbZGIMOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbZGIMOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbZGIMO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:14:26 -0400
Received: from gw3.lbox.cz ([62.245.111.133]:54779 "EHLO develbox.linuxbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756229AbZGIMOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:14:25 -0400
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2009 08:14:24 EDT
Date: Thu, 9 Jul 2009 14:07:59 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Linux kernel list <linux-kernel@vger.kernel.org>
Cc: nikola.ciprich@linuxbox.cz, netfilter-devel@lists.netfilter.org
Subject: 2.6.30.1: BUG: sleeping function called from invalid context at
	include/linux/kernel.h
Message-ID: <20090709120759.GB683@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HHi,
on one of my testing machines running 2.6.30.1, I noticed following:

[43601.016119] BUG: sleeping function called from invalid context at include/linux/kernel.h:155
[43601.016123] in_atomic(): 1, irqs_disabled(): 0, pid: 2197, name: zip
[43601.016126] 1 lock held by zip/2197:
[43601.016128]  #0:  (rcu_read_lock){......}, at: [<ffffffff804770e0>] nf_log_proc_dostring+0x90/0x180
[43601.016141] Pid: 2197, comm: zip Not tainted 2.6.30lb.00_01_PRE16 #1
[43601.016144] Call Trace:
[43601.016150]  [<ffffffff802674f5>] ? __debug_show_held_locks+0x15/0x30
[43601.016156]  [<ffffffff80234031>] __might_sleep+0x101/0x130
[43601.016160]  [<ffffffff802488cd>] proc_dostring+0x15d/0x180
[43601.016165]  [<ffffffff80477140>] nf_log_proc_dostring+0xf0/0x180
[43601.016169]  [<ffffffff804770e0>] ? nf_log_proc_dostring+0x90/0x180
[43601.016175]  [<ffffffff80339da0>] proc_sys_call_handler+0xc0/0xd0
[43601.016179]  [<ffffffff80339ddc>] proc_sys_read+0xc/0x10
[43601.016184]  [<ffffffff802dffd4>] vfs_read+0xc4/0x180
[43601.016188]  [<ffffffff802e04a0>] sys_read+0x50/0x90
[43601.016193]  [<ffffffff8020b36b>] system_call_fastpath+0x16/0x1b

Apparently, there is something wrong in the nf_log code...

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
