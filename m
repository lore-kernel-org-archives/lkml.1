Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbXDZNcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbXDZNcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXDZNcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:32:13 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44871 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbXDZNcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:32:11 -0400
Date: Thu, 26 Apr 2007 15:30:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426133054.GZ3640@kernel.dk>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <20070426142846.45ee23af@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426142846.45ee23af@the-village.bc.nu>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26 2007, Alan Cox wrote:
> > > Oh we have scores of these hacks around. Look at the dvd/cd layer. The 
> > > point is to get rid of those.
> > 
> > Perhaps this is just a matter of cleaning them up so they are no
> > longer hacks?
> 
> CD and DVD media support various non power-of-two block sizes. Supporting
> more block sizes would also be useful as we could then read older smart
> media (256byte/sector) without the SCSI layer objecting and the like.

I think Christoph is referring to the packet writing stuff, where we use
32kb or 64kb block sizes. Those aren't implemented as page cache hacks
currently though, the issue is worked around at the block layer level by
doing software RMW.

Supporting larger page cache blocks would allow pktcdvd to be reduced to
almost nothing.

-- 
Jens Axboe

