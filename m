Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbXFGNF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbXFGNF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbXFGNFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:05:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43884 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751661AbXFGNFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:05:19 -0400
Date: Thu, 7 Jun 2007 23:05:05 +1000
From: David Chinner <dgc@sgi.com>
To: Marco Berizzi <pupilla@hotmail.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Message-ID: <20070607130505.GE85884050@sgi.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl> <20070316195951.GB5743@melbourne.sgi.com> <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl> <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl> <20070320064632.GO32602149@melbourne.sgi.com> <BAY103-DAV7076D9B4230E07680B724B2260@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV7076D9B4230E07680B724B2260@phx.gbl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 09:44:51AM +0200, Marco Berizzi wrote:
> Hi David.
> Three months ago I wrote the message below.
> I had built various 2.6.20.x and 2.6.21.x
> vanilla kernel with all the debug options
> enabled and linux had never crashed.
> On june 4, I have builded linux 2.6.21.3 without
> any debugging options and after 2 days linux
> has starting print these errors:
> 
> Jun  6 09:47:09 Pleiadi kernel:  =======================
> Jun  6 09:47:09 Pleiadi kernel: 0x0: 28 f1 45 d4 22 53 35 11 09 80 37 5a
> 47 8a 22 ee
> Jun  6 09:47:09 Pleiadi kernel: Filesystem "sda8": XFS internal error
> xfs_da_do_buf(2) at line 2086 of file fs/xfs/xfs_da_btree.c.  Caller
> 0xc01b2301
> Jun  6 09:47:09 Pleiadi kernel:  [<c01b21f7>] xfs_da_do_buf+0x70c/0x7b1
> Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>] xfs_da_read_buf+0x30/0x35
> Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>] xfs_da_read_buf+0x30/0x35

These above stack trace is the sign of a corrupted directory.

Chopping out the rest of the top posting (please don't do that)
we get down to 3 months ago:

> > On Mon, Mar 19, 2007 at 11:32:27AM +0100, Marco Berizzi wrote:
> > > Marco Berizzi wrote:
> > > Here is the relevant results:
> > >
> > > Phase 2 - found root inode chunk
> > > Phase 3 - ...
> > >             agno = 0
> > >             ...
> > >             agno = 12
> > > LEAFN node level is 1 inode 1610612918 bno = 8388608
> >
> > Hmmm - single bit error in the bno - that reminds of this:
> >
> > http://oss.sgi.com/projects/xfs/faq.html#dir2
> >
> > So I'd definitely make sure that is repaired....

Where we saw signs of on disk directory corruption. Have you run
xfs_repair successfully on the filesystem since you reported
this?

If you did clean up the error, does xfs_repair report the same sort
of error again?

Have you run a 2.6.16-rcX or 2.6.17.[0-6] kernel since you last
reported this problem?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
