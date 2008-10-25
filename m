Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbYJYVek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbYJYVek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYJYVec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:34:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:54048 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbYJYVec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:34:32 -0400
Subject: Re: [PATCH] genirq: Set initial default irq affinity to just CPU0
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: galak@kernel.crashing.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, torvalds@osdl.org, maxk@qualcomm.com,
       tglx@linutronix.de
In-Reply-To: <20081024.161813.193686281.davem@davemloft.net>
References: <1224863858-7933-1-git-send-email-galak@kernel.crashing.org>
	 <20081024.161813.193686281.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 26 Oct 2008 08:33:09 +1100
Message-Id: <1224970389.7654.473.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 16:18 -0700, David Miller wrote:
> From: Kumar Gala <galak@kernel.crashing.org>
> Date: Fri, 24 Oct 2008 10:57:38 -0500
> 
> > Commit 18404756765c713a0be4eb1082920c04822ce588 introduced a regression
> > on a subset of SMP based PPC systems whose interrupt controller only
> > allow setting an irq to a single processor.  The previous behavior
> > was only CPU0 was initially setup to get interrupts.  Revert back
> > to that behavior.
> > 
> > Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> 
> I really don't remember getting all of my interrupts only on cpu 0
> on sparc64 before any of these changes.  I therefore find all of
> this quite mysterious. :-)

Well, I don't know how you do it but on powerpc, we explicitely fill the
affinity masks at boot time when we can spread interrupts... Maybe we
should change it the other way around and limit the mask when we can't ?
It's hard to tell for sure at this stage.

Ben.


