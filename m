Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZJ3LLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZJ3LLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 07:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbZJ3LLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 07:11:17 -0400
Received: from gw3.lbox.cz ([62.245.111.133]:50291 "EHLO develbox.linuxbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751311AbZJ3LLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 07:11:17 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2009 07:11:16 EDT
Date: Fri, 30 Oct 2009 12:06:32 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Linux kernel list <linux-kernel@vger.kernel.org>
Cc: nikola.ciprich@linuxbox.cz
Subject: 2.6.31.4 panic: CRED: put_cred_rcu() sees ffff880204e58c00 with
	usage 82150912
Message-ID: <20091030110632.GC6416@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
some time ago, I updated my KVM hosting machine to 2.6.31.1 and it just died horribly:
Oct 30 10:45:17 vbox [706369.133516] Kernel panic - not syncing: CRED: put_cred_rcu() sees ffff880204e58c00 with usage 82150912
Oct 30 10:45:17 vbox [706369.133519]
Oct 30 10:45:17 vbox [706369.144990] Pid: 19, comm: ksoftirqd/5 Not tainted 2.6.31lb.02 #1
Oct 30 10:45:17 vbox [706369.151554] Call Trace:
Oct 30 10:45:17 vbox [706369.154332]  <IRQ>
Oct 30 10:45:17 vbox [<ffffffff8104c1fa>] panic+0xaa/0x180
Oct 30 10:45:17 vbox [706369.160280]  [<ffffffff81322b90>] ? _spin_unlock+0x30/0x60
Oct 30 10:45:17 vbox [706369.166256]  [<ffffffff810f5671>] ? add_partial+0x21/0x90
Oct 30 10:45:17 vbox [706369.172155]  [<ffffffff810f6a92>] ? __slab_free+0x92/0x3c0
Oct 30 10:45:17 vbox [706369.178127]  [<ffffffff81102317>] ? file_free_rcu+0x37/0x50
Oct 30 10:45:17 vbox [706369.184198]  [<ffffffff8106c655>] put_cred_rcu+0x75/0x80
Oct 30 10:45:17 vbox [706369.190008]  [<ffffffff810a2525>] __rcu_process_callbacks+0x125/0x250
Oct 30 10:45:17 vbox [706369.197020]  [<ffffffff810a2689>] rcu_process_callbacks+0x39/0x60
Oct 30 10:45:17 vbox [706369.203624]  [<ffffffff81052a61>] __do_softirq+0xc1/0x250
Oct 30 10:45:17 vbox [706369.209506]  [<ffffffff81053860>] ? ksoftirqd+0x0/0x1a0
Oct 30 10:45:17 vbox [706369.215182]  [<ffffffff8100c4dc>] call_softirq+0x1c/0x30
Oct 30 10:45:17 vbox [706369.220986]  [<ffffffff8100e46d>] do_softirq+0x3d/0x80
Oct 30 10:45:17 vbox [706369.227317]  [<ffffffff81053860>] ? ksoftirqd+0x0/0x1a0
Oct 30 10:45:17 vbox [706369.233020]  [<ffffffff810538e4>] ksoftirqd+0x84/0x1a0
Oct 30 10:45:17 vbox [706369.238622]  [<ffffffff81066686>] kthread+0xa6/0xb0
Oct 30 10:45:17 vbox [706369.243956]  [<ffffffff8100c3da>] child_rip+0xa/0x20
Oct 30 10:45:17 vbox [706369.249390]  [<ffffffff810665e0>] ? kthread+0x0/0xb0
Oct 30 10:45:17 vbox [706369.254806]  [<ffffffff8100c3d0>] ? child_rip+0x0/0x20
Oct 30 10:45:17 vbox [706369.260454] Rebooting in 10 seconds..
(trace is obtained from netconsole, so hopefully it's not mangled).
The machine was running ~30 KVM guests, it's 8CPU 16GB x86_64, when it crashed, it was only
moderately loaded. Never had this (or any other) kind of crash on it before.
I know there's 2.6.31.5 already out, but I'm not sure if some related problem has been
reported/fixed and I'm obviously not able to quicky test/reproduce it with latest kernel,
so I'm rather reporting.
Should more information/testing/etc be required, I'll be glad to help
regards
nik

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
