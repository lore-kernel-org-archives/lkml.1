Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0CJPpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:45:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:44735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab0CJPps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:45:48 -0500
Subject: Re: [PATCH 1/3] lockdep: Move lock events under lockdep recursion
 protection
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20100310000533.GF5058@nowhere>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
	 <1267599302-2886-2-git-send-regression-fweisbec@gmail.com>
	 <20100309083410.GD5768@kernel.dk> <20100309083536.GE5768@kernel.dk>
	 <20100310000533.GF5058@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Mar 2010 16:45:25 +0100
Message-ID: <1268235925.5279.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 01:05 +0100, Frederic Weisbecker wrote:
> On Tue, Mar 09, 2010 at 09:35:37AM +0100, Jens Axboe wrote:
> > Which, btw, throws a new lockdep warning fest:
> > 
> > [   42.247718] scsi7 : ioc0: LSISAS1068E B3, FwRev=011b0300h,
> Ports=1, MaxQ=483, IRQ=26
> > [   42.281125] BUG: key ffff880c7cb75250 not in .data!
> > [   42.288346] ------------[ cut here ]------------
> > [   42.294490] WARNING: at kernel/lockdep.c:2706 lockdep_init_map
> +0x545/0x5f0()
> > [   42.304013] Hardware name: QSSC-S4R
> > [   42.309674] Modules linked in: hid_apple usbhid ehci_hcd uhci_hcd
> usbcore nls_base mptsas(+) mptscsih mptbase scsi_transport_sas igb sg
> sr_mod cdrom
> > [   42.332072] Pid: 5197, comm: modprobe Not tainted 2.6.34-rc1 #176
> > [   42.340597] Call Trace:
> > [   42.345335]  [<ffffffff8107fb8d>] ? is_module_address+0x2d/0x60
> > [   42.353670]  [<ffffffff81074aa5>] ? lockdep_init_map+0x545/0x5f0
> > [   42.362154]  [<ffffffff81044648>] warn_slowpath_common+0x78/0xd0
> > [   42.371913]  [<ffffffff810446af>] warn_slowpath_null+0xf/0x20
> > [   42.380109]  [<ffffffff81074aa5>] lockdep_init_map+0x545/0x5f0
> 
> 
> 
> This doesn't look related to my patch, it also happen in -rc1 right?


The per-cpu changes broke lockdep, Tejun already posted patches for
this:

http://lkml.org/lkml/2010/3/10/76
http://lkml.org/lkml/2010/3/10/79


