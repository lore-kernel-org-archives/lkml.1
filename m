Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbYLDImT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbYLDImT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYLDImF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:42:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:52851 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYLDImC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:42:02 -0500
Subject: Re: Page alloc failures under network/disk IO load
From: Peter Zijlstra <peterz@infradead.org>
To: Dan =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1228378983.5092.7.camel@twins>
References: <20081203222750.391e8890@tuna>  <1228378983.5092.7.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 04 Dec 2008 09:42:08 +0100
Message-Id: <1228380128.5092.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-04 at 09:23 +0100, Peter Zijlstra wrote:
> On Wed, 2008-12-03 at 22:27 -0500, Dan Noé wrote:
> > This is on Linux 2.6.28-rc7, on a Core 2 Duo.  The system has plenty of
> > memory:
> > 
> >              total       used       free     shared    buffers
> > cached
> > Mem:          1893       1822         70          0          0
> 
> filled to the brim with data
> 
> > 1573
> > -/+ buffers/cache:        249       1644
> > Swap:         1906         37       1868
> > 
> > I am using rsync to transfer data onto this system.  The filesystem is
> > XFS, and the target drive is a 1TB Western Digital on ata_piix.  The
> > system files are on a RAID 1 (Linux md, also on ata_piix).
> > 
> > Periodically I get page allocation failures, from __netdev_alloc_skb.
> > I suppose this causes the driver to drop packets and thus hurts
> > performance.
> 
> There isn't much we can do about that, memory is filled and your network
> card tries to allocate memory in a mode that doesn't allow freeing some.
> 
> Looking at the timestamps its not very frequent, so it doesn't hurt
> performance much if anything. If you're really bothered with this, you
> could quiet it by sticking in a __GFP_NOWARN in __netdev_alloc_skb() or
> something..

Another thing you can do is increase /proc/sys/vm/min_free_kbytes
