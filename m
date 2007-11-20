Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbXKTEEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbXKTEEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 23:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXKTEEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 23:04:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36015
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752862AbXKTEEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 23:04:42 -0500
Date: Mon, 19 Nov 2007 20:04:41 -0800 (PST)
Message-Id: <20071119.200441.161851942.davem@davemloft.net>
To: ak@suse.de
Cc: clameter@sgi.com, akpm@linux-foundation.org, travis@sgi.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [rfc 00/45] [RFC] CPU ops and a rework of per cpu data
 handling on x86_64
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711200425.34849.ak@suse.de>
References: <20071120011132.143632442@sgi.com>
	<20071119.175116.55102316.davem@davemloft.net>
	<200711200425.34849.ak@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@suse.de>
Date: Tue, 20 Nov 2007 04:25:34 +0100

> 
> > Although we have a per-cpu area base in a fixed global register
> > for addressing, the above isn't beneficial on sparc64 because
> > the atomic is much slower than doing a:
> >
> > 	local_irq_disable();
> > 	nonatomic_percpu_memory_op();
> > 	local_irq_enable();
> 
> Again might be pointing out the obvious, but you 
> need of course save_flags()/restore_flags(), not disable/enable().

Right, but the cost is the same for that on sparc64 unlike
x86 et al.
