Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbYFJQ7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbYFJQ7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFJQ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:59:39 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51977 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753315AbYFJQ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:59:38 -0400
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
From: Catalin Marinas <catalin.marinas@arm.com>
To: paulmck@linux.vnet.ibm.com
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu,
       Russell King <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <20080610154716.GF15481@linux.vnet.ibm.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
	 <1212051504-12561-2-git-send-email-jens.axboe@oracle.com>
	 <1213109485.24701.107.camel@pc1117.cambridge.arm.com>
	 <20080610154716.GF15481@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 10 Jun 2008 17:53:08 +0100
Message-Id: <1213116788.24701.133.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2008 16:53:09.0288 (UTC) FILETIME=[7635BA80:01C8CB1A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 08:47 -0700, Paul E. McKenney wrote:
> On Tue, Jun 10, 2008 at 03:51:25PM +0100, Catalin Marinas wrote:
> > I was thinking whether this condition can be removed and allow the
> > smp_call_function*() to be called with IRQs disabled. At a quick look,
> > it seems to be possible if the csd_flag_wait() function calls the IPI
> > handlers directly when the IRQs are disabled (see the patch below).
[...]
> There were objections last month:  http://lkml.org/lkml/2008/5/3/167

Thanks, I missed this discussion.

> The issue was that this permits some interrupts to arrive despite
> interrupts being disabled.  There seemed to be less resistance to
> doing this in the wait==1 case, however.

The "(wait == 1) && irqs_disabled()" case is what I would be interested
in. In the patch you proposed, this doesn't seem to be allowed (at least
from the use of WARN_ON). However, from your post in May:

> 5.	If you call smp_call_function() with irqs disabled, then you
> 	are guaranteed that no other CPU's smp_call_function() handler
> 	will be invoked while smp_call_function() is executing.

this would be possible but no one need this functionality yet.

Would one use-case (ARM SMP and DMA cache maintenance) be enough to
implement this or I should add it to the ARM-specific code?

Thanks.

-- 
Catalin

