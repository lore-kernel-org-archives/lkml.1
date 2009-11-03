Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbZKCOqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbZKCOqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZKCOqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:46:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZKCOqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:46:53 -0500
Date: Tue, 3 Nov 2009 12:46:38 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>,
       nikola.ciprich@linuxbox.cz, KVM list <kvm@vger.kernel.org>
Subject: Re: 2.6.31.4 panic: CRED: put_cred_rcu() sees ffff880204e58c00
	with usage 82150912
Message-ID: <20091103144638.GE10084@amt.cnet>
References: <20091030110632.GC6416@develbox.linuxbox.cz> <20091030111534.GD6416@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091030111534.GD6416@develbox.linuxbox.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 12:15:34PM +0100, Nikola Ciprich wrote:
> Ouch, typo in subject, it's 2.6.31.1 of course. sorry about that.
> also CCing kvm.
> n.
> 
> On Fri, Oct 30, 2009 at 12:06:32PM +0100, Nikola Ciprich wrote:
> > Hi,
> > some time ago, I updated my KVM hosting machine to 2.6.31.1 and it just died horribly:

Nikola,

Upgraded from what? Did you see experience the crash again?

> > Oct 30 10:45:17 vbox [706369.133516] Kernel panic - not syncing: CRED: put_cred_rcu() sees ffff880204e58c00 with usage 82150912
> > Oct 30 10:45:17 vbox [706369.133519]
> > Oct 30 10:45:17 vbox [706369.144990] Pid: 19, comm: ksoftirqd/5 Not tainted 2.6.31lb.02 #1
> > Oct 30 10:45:17 vbox [706369.151554] Call Trace:
> > Oct 30 10:45:17 vbox [706369.154332]  <IRQ>
> > Oct 30 10:45:17 vbox [<ffffffff8104c1fa>] panic+0xaa/0x180
> > Oct 30 10:45:17 vbox [706369.160280]  [<ffffffff81322b90>] ? _spin_unlock+0x30/0x60
> > Oct 30 10:45:17 vbox [706369.166256]  [<ffffffff810f5671>] ? add_partial+0x21/0x90
> > Oct 30 10:45:17 vbox [706369.172155]  [<ffffffff810f6a92>] ? __slab_free+0x92/0x3c0
> > Oct 30 10:45:17 vbox [706369.178127]  [<ffffffff81102317>] ? file_free_rcu+0x37/0x50
> > Oct 30 10:45:17 vbox [706369.184198]  [<ffffffff8106c655>] put_cred_rcu+0x75/0x80
> > Oct 30 10:45:17 vbox [706369.190008]  [<ffffffff810a2525>] __rcu_process_callbacks+0x125/0x250
> > Oct 30 10:45:17 vbox [706369.197020]  [<ffffffff810a2689>] rcu_process_callbacks+0x39/0x60
> > Oct 30 10:45:17 vbox [706369.203624]  [<ffffffff81052a61>] __do_softirq+0xc1/0x250
> > Oct 30 10:45:17 vbox [706369.209506]  [<ffffffff81053860>] ? ksoftirqd+0x0/0x1a0
> > Oct 30 10:45:17 vbox [706369.215182]  [<ffffffff8100c4dc>] call_softirq+0x1c/0x30
> > Oct 30 10:45:17 vbox [706369.220986]  [<ffffffff8100e46d>] do_softirq+0x3d/0x80
> > Oct 30 10:45:17 vbox [706369.227317]  [<ffffffff81053860>] ? ksoftirqd+0x0/0x1a0
> > Oct 30 10:45:17 vbox [706369.233020]  [<ffffffff810538e4>] ksoftirqd+0x84/0x1a0
> > Oct 30 10:45:17 vbox [706369.238622]  [<ffffffff81066686>] kthread+0xa6/0xb0
> > Oct 30 10:45:17 vbox [706369.243956]  [<ffffffff8100c3da>] child_rip+0xa/0x20
> > Oct 30 10:45:17 vbox [706369.249390]  [<ffffffff810665e0>] ? kthread+0x0/0xb0
> > Oct 30 10:45:17 vbox [706369.254806]  [<ffffffff8100c3d0>] ? child_rip+0x0/0x20
> > Oct 30 10:45:17 vbox [706369.260454] Rebooting in 10 seconds..
> > (trace is obtained from netconsole, so hopefully it's not mangled).
> > The machine was running ~30 KVM guests, it's 8CPU 16GB x86_64, when it crashed, it was only
> > moderately loaded. Never had this (or any other) kind of crash on it before.
> > I know there's 2.6.31.5 already out, but I'm not sure if some related problem has been
> > reported/fixed and I'm obviously not able to quicky test/reproduce it with latest kernel,
> > so I'm rather reporting.
> > Should more information/testing/etc be required, I'll be glad to help
> > regards
> > nik

