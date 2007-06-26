Return-Path: <linux-kernel-owner+w=401wt.eu-S1763048AbXFZXbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763048AbXFZXbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762417AbXFZX1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:27:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57443 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762507AbXFZX1Q (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:27:16 -0400
Date: Wed, 27 Jun 2007 09:26:49 +1000
From: David Chinner <dgc@sgi.com>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com,
       xfs@oss.sgi.com
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070626232649.GR31489@sgi.com>
References: <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625215239.GK5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625215239.GK5181@schatzie.adilger.int>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 03:52:39PM -0600, Andreas Dilger wrote:
> On Jun 25, 2007  19:15 +0530, Amit K. Arora wrote:
> > +#define FA_FL_DEALLOC	0x01 /* default is allocate */
> > +#define FA_FL_KEEP_SIZE	0x02 /* default is extend/shrink size */
> > +#define FA_FL_DEL_DATA	0x04 /* default is keep written data on DEALLOC */
> 
> In XFS one of the (many) ALLOC modes is to zero existing data on allocate.

No, none of the XFS allocation modes do that.

XFS_IOC_ALLOCSP, which does write zeros to disk, only allocates and
writes zeros in the range between the old file size and the new file size.
XFS_IOC_RESVSP, which alocates unwritten extents, only allocates
where extents do not currently exist. It does not zero existing
extents.

IOWs, you can't overwrite existing data with XFS preallocation.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
