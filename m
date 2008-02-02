Return-Path: <linux-kernel-owner+w=401wt.eu-S1764445AbYBBPoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764445AbYBBPoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 10:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYBBPoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 10:44:04 -0500
Received: from marge.padd.com ([66.127.62.138]:38089 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbYBBPoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 10:44:03 -0500
Date: Sat, 2 Feb 2008 10:32:31 -0500
From: Pete Wyckoff <pw@osc.edu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Integration of SCST in the mainstream Linux kernel
Message-ID: <20080202153231.GA5601@osc.edu>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com> <1201639331.3069.58.camel@localhost.localdomain> <adazluoe2t3.fsf@cisco.com> <20080130083239E.fujita.tomonori@lab.ntt.co.jp> <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com> <1201710871.3292.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201710871.3292.22.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James.Bottomley@HansenPartnership.com wrote on Wed, 30 Jan 2008 10:34 -0600:
> On Wed, 2008-01-30 at 09:38 +0100, Bart Van Assche wrote:
> > On Jan 30, 2008 12:32 AM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > >
> > > iSER has parameters to limit the maximum size of RDMA (it needs to
> > > repeat RDMA with a poor configuration)?
> > 
> > Please specify which parameters you are referring to. As you know I
> > had already repeated my tests with ridiculously high values for the
> > following iSER parameters: FirstBurstLength, MaxBurstLength and
> > MaxRecvDataSegmentLength (16 MB, which is more than the 1 MB block
> > size specified to dd).
> 
> the 1Mb block size is a bit of a red herring.  Unless you've
> specifically increased the max_sector_size and are using an sg_chain
> converted driver, on x86 the maximum possible transfer accumulation is
> 0.5MB.
> 
> I certainly don't rule out that increasing the transfer size up from
> 0.5MB might be the way to improve STGT efficiency, since at an 1GB/s
> theoretical peak, that's roughly 2000 context switches per I/O; however,
> It doesn't look like you've done anything that will overcome the block
> layer limitations.

The MRDSL parameter has no effect on iSER, as the RFC describes.
How to transfer data to satisfy a command is solely up to the
target.  So you would need both big requests from the client, then
look at how the target will send the data.

I've only used 512 kB for the RDMA transfer size from the target, as
it matches the default client size and was enough to get good
performance out of my IB gear and minimizes resource consumption on
the target.  It's currently hard-coded as a #define.  There is no
provision in the protocol for the client to dictate the value.

If others want to spend some effort trying to tune stgt for iSER,
there are a fair number of comments in the code, including a big one
that explains this RDMA transfer size issue.  And I'll answer
informed questions as I can.  But I'm not particularly interested in
arguing about which implementation is best, or trying to interpret
bandwidth comparison numbers from poorly designed tests.  It takes
work to understand these issues.

		-- Pete
