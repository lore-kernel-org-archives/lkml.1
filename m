Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZFEDbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZFEDbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZFEDbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:31:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281AbZFEDbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:31:37 -0400
Date: Thu, 4 Jun 2009 20:29:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: only a single core (out of 8) initialized
Message-Id: <20090604202933.d7c24c3d.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906041949030.7953@asgard>
References: <alpine.DEB.1.10.0906041949030.7953@asgard>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 19:52:36 -0700 (PDT) david@lang.hm wrote:

> this is 2.6.30-rc7

Were any earlier kernels OK?

>  with a patch added to debug a nv sata driver 
> incompatibility with the Intel SSDs on a tyan motherboard
> 
> on one system it sees all 8 cores, on the other system it only initializes 
> one core.
> 
> can anyone help me spot what's going wrong in the one that's only seeing a 
> single core? If I'm reading things correctly it's seeing both sockets for 
> the NUMA setup, but then only initializing one core on the first socket.

good:
	SMP: Allowing 8 CPUs, 4 hotplug CPUs

bad:	
	SMP: Allowing 1 CPUs, 0 hotplug CPUs

perhaps due to
	ACPI: No APIC-table, disabling MPS

You could have a poke around in arch/x86/kernel/smpboot.c() and find
out what happened here.  I'd be suspecting this code triggered:

        /* no processor from mptable or madt */
        if (!num_processors)
                num_processors = 1;

because ACPI doesn't like that board.

Did you look into updating the BIOS?

