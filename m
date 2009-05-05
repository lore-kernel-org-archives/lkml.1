Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZEETxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZEETxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZEETw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:52:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17132 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbZEETw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:52:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BQjqCdC5AdzjA7MR1aFdk8JX6bQfnoDOAB98bUdr5njYrHYeaIIOPYtMp6+qcX1yQ
	U7kfmFEN8M15bu/VKKlRQ==
Date: Tue, 5 May 2009 12:52:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jack Steiner <steiner@sgi.com>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, alex.shi@intel.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix early panic issue on machines with memless node
In-Reply-To: <20090505163608.GA20385@sgi.com>
Message-ID: <alpine.DEB.2.00.0905051250510.20021@chino.kir.corp.google.com>
References: <1241493327.27664.17.camel@ymzhang> <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com> <20090505163608.GA20385@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Jack Steiner wrote:

> I was able to duplicate your original problem. Your patch below solves the
> problem. AFAICT, it causes no new reqgressions to the various configurations
> that I'm testing. (I'll add the "mem=2G" to my configs that I test).
> 

Great, it would be helpful to catch these problems before 2.6.30 is 
released.  I've passed my patch along to Ingo.

> However, I see a new regression that was not present a couple of weeks ago.
> Configurations that have nodes with cpus and no memory panic during
> boot. This occurs both with and without your patch and is not related to "mem=".
> 
> I need to isolate the problem but here is the stack trace. :
> 	Pid: 0, comm: swapper Not tainted 2.6.30-rc4-next-20090505-medusa #12
> 	Call Trace:
> 	 [<ffffffff806b919e>] early_idt_handler+0x5e/0x71
> 	 [<ffffffff802920fe>] ? build_zonelists_node+0x4c/0x8d
> 	 [<ffffffff8029333f>] __build_all_zonelists+0x1ae/0x55a
> 	 [<ffffffff80293932>] build_all_zonelists+0x1b5/0x263
> 	 [<ffffffff806b9b6e>] start_kernel+0x17a/0x3c5
> 	 [<ffffffff806b9140>] ? early_idt_handler+0x0/0x71
> 	 [<ffffffff806b92a7>] x86_64_start_reservations+0xae/0xb2
> 	 [<ffffffff806b93fd>] x86_64_start_kernel+0x152/0x161
> 

Please post your .config since it apparently differs from x86_64 defconfig 
judging by my debugging symbols and also the full output of the panic.
