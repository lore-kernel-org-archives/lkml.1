Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZEEU1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZEEU1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZEEU1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:27:33 -0400
Received: from relay3.sgi.com ([192.48.156.57]:37897 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753187AbZEEU1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:27:33 -0400
Date: Tue, 5 May 2009 15:27:30 -0500
From: Jack Steiner <steiner@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, alex.shi@intel.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix early panic issue on machines with memless node
Message-ID: <20090505202730.GA9831@sgi.com>
References: <1241493327.27664.17.camel@ymzhang> <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com> <20090505163608.GA20385@sgi.com> <alpine.DEB.2.00.0905051250510.20021@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905051250510.20021@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 12:52:54PM -0700, David Rientjes wrote:
> On Tue, 5 May 2009, Jack Steiner wrote:
> 
> > I was able to duplicate your original problem. Your patch below solves the
> > problem. AFAICT, it causes no new reqgressions to the various configurations
> > that I'm testing. (I'll add the "mem=2G" to my configs that I test).
> > 
> 
> Great, it would be helpful to catch these problems before 2.6.30 is 
> released.  I've passed my patch along to Ingo.
> 
> > However, I see a new regression that was not present a couple of weeks ago.
> > Configurations that have nodes with cpus and no memory panic during
> > boot. This occurs both with and without your patch and is not related to "mem=".
> > 
> > I need to isolate the problem but here is the stack trace. :
> > 	Pid: 0, comm: swapper Not tainted 2.6.30-rc4-next-20090505-medusa #12
> > 	Call Trace:
> > 	 [<ffffffff806b919e>] early_idt_handler+0x5e/0x71
> > 	 [<ffffffff802920fe>] ? build_zonelists_node+0x4c/0x8d
> > 	 [<ffffffff8029333f>] __build_all_zonelists+0x1ae/0x55a
> > 	 [<ffffffff80293932>] build_all_zonelists+0x1b5/0x263
> > 	 [<ffffffff806b9b6e>] start_kernel+0x17a/0x3c5
> > 	 [<ffffffff806b9140>] ? early_idt_handler+0x0/0x71
> > 	 [<ffffffff806b92a7>] x86_64_start_reservations+0xae/0xb2
> > 	 [<ffffffff806b93fd>] x86_64_start_kernel+0x152/0x161
> > 
> 
> Please post your .config since it apparently differs from x86_64 defconfig 
> judging by my debugging symbols and also the full output of the panic.

I suspect I mislead you when I mentioned "configurations". I did not mean
the .config file. I use a more-or-less standard .config file.

I do much of my testing on a system simulator. Using a simulator config file,
I specify the system configuration such as number of nodes, sockets per node,
cpus per socket, memory per socket, address map, boot options, etc. This
makes it easy to quickly test a lot of strange (but real) configurations.

The configuration above that is failing is a 2-socket Nehelem blade that has no
memory on socket 0. All memory is located on socket 1.  The panic is caused by a
null dereference of NODE_DATA(0).

Still looking....




--- jack

