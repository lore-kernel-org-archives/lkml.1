Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbXJUWRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbXJUWRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 18:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbXJUWRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 18:17:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:53649 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbXJUWRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 18:17:35 -0400
Subject: Re: Interaction between Xen and XFS: stray RW mappings
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?ISO-8859-1?Q?B=C3=B8geskov?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
In-Reply-To: <20071015110735.GA11748@one.firstfloor.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com>
	 <p731wbw4t3h.fsf@bingen.suse.de>
	 <200710160056.47458.nickpiggin@yahoo.com.au>
	 <20071015110735.GA11748@one.firstfloor.org>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 08:16:01 +1000
Message-Id: <1193004961.6745.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-15 at 13:07 +0200, Andi Kleen wrote:
> On Tue, Oct 16, 2007 at 12:56:46AM +1000, Nick Piggin wrote:
> > Is this true even if you don't write through those old mappings?
> 
> I think it happened for reads too.  It is a little counter intuitive
> because in theory the CPU doesn't need to write back non dirty lines,
> but in the one case which took so long to debug exactly this happened
> somehow.

The problem exist also on ppc, and afaik, is due to the line being in
the cache at all (either dirty (write) or not (read)), thus causing the
snoop logic to hit, that is what's causing the problem vs. non cached
accesses.

Also, on some processors, the simple fact of having the page mapped can
cause the CPU to prefetch from it even if it's not actually accessed
(speculative prefetch can cross page boundaries if things are mapped).

Ben.


