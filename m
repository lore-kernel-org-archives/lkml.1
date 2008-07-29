Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYG2WrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYG2WrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYG2WrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:47:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbYG2WrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:47:15 -0400
Date: Tue, 29 Jul 2008 15:46:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: a.p.zijlstra@chello.nl, vatsa@linux.vnet.ibm.com, efault@gmx.de,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks
 PXA270 (at least)?
Message-Id: <20080729154605.d540cf6d.akpm@linux-foundation.org>
In-Reply-To: <20080729223105.GK10982@flint.arm.linux.org.uk>
References: <20080729223105.GK10982@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 23:31:05 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> But then some bright spark thought it would be a good idea to get
> rid of printk_clock().

<does git-log, searches for printk_clock>

  commit 86faf39d0fc04272b05fab1db6d683f3ac7199d1
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Fri Jan 25 21:07:59 2008 +0100
  
      sched: remove printk_clock references from ia64
      
      remove remaining printk_clock references from ia64.
      
      Signed-off-by: Ingo Molnar <mingo@elte.hu>
  
  commit b842271fbb9c8b5fd0e1c3e1895a3b67ba5bcc54
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Fri Jan 25 21:07:59 2008 +0100
  
      sched: remove printk_clock()
      
      printk_clock() is obsolete - it has been replaced with cpu_clock().
      
      Signed-off-by: Ingo Molnar <mingo@elte.hu>
  

That's it?  It rates a 0.5/10 for changelogging :(

Looking further on...

  commit e97126cd9056b3b42cdc862ace2ed66f8026f55b
  Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
  Date:   Mon Jan 8 19:49:12 2007 +0000
  
      [ARM] Provide basic printk_clock() implementation
      
      Current sched_clock() implementations on ARM cause unbootable kernels
      with PRINTK_TIME support enabled.  To avoid this, provide a basic
      printk_clock() implementation which avoids sched_clock() being called
      before the page tables have been set up.
  

which I assume is why arm is crashing again?


Really, I think arch-overrideable printk_clock() was a good idea. 
printk is just _special_.  It's called wildly early and it is called in
all conceivable contexts and it just must work no matter what.  It's
totally understandable that an architecture would need to override
printk's timestamp generator.


