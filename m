Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbYBRSyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbYBRSyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbYBRSxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:53:51 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:15828 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078AbYBRSxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:53:50 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
X-Message-Flag: Warning: May contain useful information
References: <200802171025.30590.elendil@planet.nl>
	<20080217124650.576990ce@laptopd505.fenrus.org>
	<p73mypyxx6z.fsf@bingen.suse.de>
	<20080218085018.05f3190a@laptopd505.fenrus.org>
	<20080218171159.GA24090@basil.nowhere.org>
	<20080218093215.5cf611a8@laptopd505.fenrus.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 18 Feb 2008 10:53:42 -0800
In-Reply-To: <20080218093215.5cf611a8@laptopd505.fenrus.org> (Arjan van de Ven's message of "Mon, 18 Feb 2008 09:32:15 -0800")
Message-ID: <adalk5ijdu1.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Feb 2008 18:53:43.0375 (UTC) FILETIME=[95620DF0:01C8725F]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I've yet to see a user who wants WC. Lets face it, WC *sucks*. This is why
 > the folks who care about performance (the graphics guys) stopped using it.
 > WC is slow, and on modern cpus leads to really bad performance. I'm really
 > half tempted to just ignore WC entirely and suggest that we don't even implement
 > it in the kernel. Yes it's really that bad.

I know of one case at least where WC is very useful.  Some InfiniBand
adapters allow small messages to be written directly into the
adapter's PCI space BAR to lower latency (having the CPU write the
message avoids doing something like build descriptor, ring doorbell
register on adapter, adapter DMA message out of CPU memory).  And
mapping the PCI space with WC is a pretty big win -- for example for
mlx4 hardware it gets MPI latency from ~1.8 usec to ~1.3 usec which is
a big deal.  I think most real users of mlx4 hardware are using a
hacky out-of-tree patch to allow using PAT to set WC.

AFAIK mapping PCI memory WB is not allowed, so WC is really our only choice.

 - R.
