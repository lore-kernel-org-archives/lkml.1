Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbYCEIas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbYCEIas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYCEIak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:30:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:40898 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYCEIaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:30:39 -0500
Subject: Re: [BUG] 2.6.25-rc3-mm1 kernel panic while bootup on powerpc ()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Neuling <mikey@neuling.org>, Matthew Wilcox <willy@debian.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <20080304103350.12d26560.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	 <47CD4AB3.3080409@linux.vnet.ibm.com> <20778.1204641656@neuling.org>
	 <20080304103350.12d26560.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 19:23:40 +1100
Message-Id: <1204705420.21545.192.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 10:33 -0800, Andrew Morton wrote:
> > Are we somehow enabling interrupts before we've setup
> ppc_md.get_irq?
> > 
> 
> Yes, we are - it's the semaphore rewrite which is doing this in
> start_kernel().  It's being discussed.
> 
> Enabling interrupts too early on powerpc was discovered to be fatal on
> powerpc years ago.  It looks like that remains the case.

Yes, it is and will probably always be. All that semaphore mucking
around that hard-enables interrupts is just asking for trouble (and on
more than just powerpc... heh, how do you do if your main interrupt
controller hasn't even been initialized yet ?)

Ben.


