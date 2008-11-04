Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYKDQ4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYKDQ4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbYKDQ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:56:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52158 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123AbYKDQ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:56:31 -0500
Date: Tue, 4 Nov 2008 18:05:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       heukelum@fastmail.fm, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104170501.GE29626@one.firstfloor.org>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104150729.GC21470@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> not taking into account the cost of cs reading (which I
> don't suspect to be that expensive apart from writting,

GDT accesses have an implied LOCK prefix. Especially
on some older CPUs that could be slow.

I don't know if it's a problem or not but it would need
some careful benchmarking on different systems to make sure interrupt 
latencies are not impacted.

Another reason I would be also careful with this patch is that
it will likely trigger slow paths in JITs like qemu/vmware/etc.

Also code segment switching is likely not something that
current and future micro architectures will spend a lot of time optimizing.

I'm not sure that risk is worth the small improvement in code
size.

An alternative BTW to having all the stubs in the executable
would be to just dynamically generate them when the interrupt
is set up. Then you would only have the stubs around for the 
interrupts which are actually used.

-Andi
