Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbXISXZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbXISXZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXISXY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:24:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbXISXY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:24:58 -0400
Date: Wed, 19 Sep 2007 16:24:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: 2.6.23-rc6-mm1
Message-Id: <20070919162438.7264f06c.akpm@linux-foundation.org>
In-Reply-To: <46F1AA6E.1030708@imap.cc>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<46F1AA6E.1030708@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 01:02:06 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> I get several "duplicate file name" messages.
> Hope Greg's the right one to cc on these.
> 
> <4>[   21.211942] Duplicate file names "rtc" detected. [dump_trace+100/498] dump_trace+0x64/0x1f2
> <4>[   21.216801]  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
> <4>[   21.221639]  [show_trace+18/20] show_trace+0x12/0x14
> <4>[   21.226307]  [dump_stack+22/24] dump_stack+0x16/0x18
> <4>[   21.231063]  [proc_register+315/332] proc_register+0x13b/0x14c
> <4>[   21.235814]  [create_proc_entry+114/135] create_proc_entry+0x72/0x87
> <4>[   21.240562]  [<faa1d123>] rtc_proc_add_device+0x1d/0x39 [rtc_core]
> <4>[   21.245304]  [<faa1c1f9>] rtc_device_register+0x170/0x207 [rtc_core]
> <4>[   21.250077]  [<faa3c5db>] cmos_do_probe+0x8d/0x1ee [rtc_cmos]
> <4>[   21.254715]  [<faa3c77d>] cmos_pnp_probe+0x41/0x44 [rtc_cmos]
> <4>[   21.259477]  [pnp_device_probe+102/135] pnp_device_probe+0x66/0x87
> <4>[   21.264206]  [driver_probe_device+233/362] driver_probe_device+0xe9/0x16a
> <4>[   21.268738]  [__driver_attach+108/165] __driver_attach+0x6c/0xa5
> <4>[   21.273387]  [bus_for_each_dev+54/91] bus_for_each_dev+0x36/0x5b
> <4>[   21.277975]  [driver_attach+25/27] driver_attach+0x19/0x1b
> <4>[   21.282501]  [bus_add_driver+115/429] bus_add_driver+0x73/0x1ad
> <4>[   21.286984]  [driver_register+103/108] driver_register+0x67/0x6c
> <4>[   21.291269]  [pnp_register_driver+23/25] pnp_register_driver+0x17/0x19
> <4>[   21.295661]  [<faa4000d>] cmos_init+0xd/0xf [rtc_cmos]
> <4>[   21.300044]  [sys_init_module+5544/5953] sys_init_module+0x15a8/0x1741
> <4>[   21.304406]  [sysenter_past_esp+107/181] sysenter_past_esp+0x6b/0xb5
> <4>[   21.308749]  [phys_startup_32+3085673488/3221225472] 0xb7fba410
> <4>[   21.313108]  =======================

Nah, that's an rtc-specific problem.

I think David says that it's actually not a problem, but I didn't
really understand how this can be?

Perhaps I'll need to drop that debugging patch.  Which would be a shame,
because it can detect real bugs.  Perhaps it needs a strcmp("rtc") to
filter out the (surprising) false positive.
