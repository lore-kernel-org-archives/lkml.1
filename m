Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZLQXcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZLQXcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZLQXcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:32:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:49455 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbZLQXcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:32:18 -0500
Subject: Re: [GIT PULL] PM updates for 2.6.33
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zhang Rui <rui.zhang@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0912062204431.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org>
	 <1260158279.27069.181.camel@rzhang1-desktop>
	 <alpine.LFD.2.00.0912062122460.3560@localhost.localdomain>
	 <alpine.LFD.2.00.0912062204431.3560@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 10:28:19 +1100
Message-ID: <1261092499.6682.44.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 22:15 -0800, Linus Torvalds wrote:
> 
> The same is true of the prepare_suspend/suspend split I'm proposing:
> I 
> suspect that for something like USB, it would make most sense to just
> do 
> normal node suspend in prepare_suspend, which would do everything 
> asynchronously. Only USB hub devices would get involved at the later 
> 'suspend()' phase.

Wasn't part of the goal with prepare_suspend() vs. suspend() to handle
the problem of backing store vs the VM ?

IE. Once any device potentially in the VM path is suspended, things like
kmalloc() or gfp() can potentially stall until resume or did we address
that recently ?

Iirc, part of the idea behind prepare_* is that it's safe vs. the above.
Now if you start suspending USB devices at prepare() then you break that
assumption since those could be mass storage with dirty mmap'ed pages on
them.

Now, I'm all for fixing it at the VM/allocator level (if we didn't
already) turning pretty much everything into NO_IO once we start
suspending devices but that's a whole different matter :-)

Cheers,
Ben.


