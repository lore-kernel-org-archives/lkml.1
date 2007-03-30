Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbXC3OcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbXC3OcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 10:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXC3OcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 10:32:04 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:45940 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXC3OcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 10:32:03 -0400
Date: Fri, 30 Mar 2007 16:25:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Vitaly Bordug <vbordug@ru.mvista.com>
Subject: Re: [bug] fixed_init(): BUG: at drivers/base/core.c:120 device_release(), was: "2.6.21-rc5: known regressions"
Message-ID: <20070330142514.GA15327@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu> <20070330120657.GA21271@elte.hu> <20070330141856.GB10387@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330141856.GB10387@suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> > Device 'fixed@10:1' does not have a release() function, it is broken and must be fixed.
> > BUG: at drivers/base/core.c:120 device_release()
> >  [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
> >  [<c01063e2>] show_trace+0x12/0x14
> >  [<c01063f8>] dump_stack+0x14/0x16
> >  [<c063cddf>] device_release+0x7c/0x7e
> >  [<c0476c32>] kobject_cleanup+0x44/0x5e
> >  [<c0476c57>] kobject_release+0xb/0xd
> >  [<c04773ef>] kref_put+0x63/0x71
> >  [<c0476757>] kobject_put+0x14/0x16
> >  [<c063ceef>] put_device+0x11/0x13
> >  [<c063d943>] device_unregister+0x12/0x15
> >  [<c07337d1>] fixed_mdio_register_device+0x210/0x23b
> >  [<c1b6d6c1>] fixed_init+0x2f/0x33
> >  [<c1b31a2d>] init+0x15d/0x2bd
> >  [<c0105bc3>] kernel_thread_helper+0x7/0x10
> 
> That means that whatever driver has fixed_mdio_register_device() in it 
> is broken and needs to be fixed.

that would be drivers/net/phy/fixed.c.

> It is independant from your previous question about unregistering the 
> device from within module_init().

(yes - hence the different subject line, etc.)

	Ingo
