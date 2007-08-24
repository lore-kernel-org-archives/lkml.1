Return-Path: <linux-kernel-owner+w=401wt.eu-S1761441AbXHXVcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbXHXVcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbXHXVcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:32:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34748
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbXHXVcV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:32:21 -0400
Date: Fri, 24 Aug 2007 14:32:20 -0700 (PDT)
Message-Id: <20070824.143220.55503163.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <200708241559.17055.ossthema@de.ibm.com>
References: <200708241559.17055.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Fri, 24 Aug 2007 15:59:16 +0200

>    It would be nice if it is possible to schedule queues to other CPU's, or
>    at least to use interrupts to put the queue to another cpu (not nice for 
>    as you never know which one you will hit). 
>    I'm not sure how bad the tradeoff would be.

Once the per-cpu NAPI poll queues start needing locks, much of the
gain will be lost.  This is strictly what we want to avoid.

We need real facilities for IRQ distribution policies.  With that none
of this is an issue.

This is also a platform specific problem with IRQ behavior, the IRQ
distibution scheme you mention would never occur on sparc64 for
example.  We use a fixed round-robin distribution of interrupts to
CPUS there, they don't move.

Each scheme has it's advantages, but you want a difference scheme here
than what is implemented and the fix is therefore not in the
networking :-)

Furthermore, most cards that will be using multi-queue will be
using hashes on the packet headers to choose the MSI-X interrupt
and thus the cpu to be targetted.  Those cards will want fixed
instead of dynamic interrupt to cpu distribution schemes as well,
so your problem is not unique and they'll need the same fix as
you do.
