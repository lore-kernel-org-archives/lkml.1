Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbXHBRyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbXHBRyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbXHBRyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:54:05 -0400
Received: from lazybastard.de ([212.112.238.170]:41325 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbXHBRyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:54:03 -0400
Date: Thu, 2 Aug 2007 19:50:09 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, hch@infradead.org
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070802175008.GA12627@lazybastard.org>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <20070731170012.GN5101@hasse.suse.de> <20070731171159.GA27234@filer.fsl.cs.sunysb.edu> <1185981810.18007.14.camel@kleikamp.austin.ibm.com> <20070801184405.GA18405@filer.fsl.cs.sunysb.edu> <1185995431.18007.24.camel@kleikamp.austin.ibm.com> <20070801193330.GA20928@filer.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070801193330.GA20928@filer.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 August 2007 15:33:30 -0400, Josef Sipek wrote:
>  
> This brings up an very interesting (but painful) question...which makes more
> sense? Allowing the modifications in only the top-most branch, or any branch
> (given the user allows it at mount-time)?
> 
> This is really question to the community at large, not just you, Dave :)

Only write to top-most layer.

There are two reasons for this.  First it allows users to create a union
mount, test something (e.g. update the distribution) and remove every
trace from the test by umounting the top-most layer.  Such a thing can
be quite valuable.

The second reason is simplicity.  I personally couldn't even start to
describe the semantics.  If the user does a rename, which layer will the
change end up in?  What if source or target exist in multiple layers?
How to rename a directory in a lower layer containing a new file in an
upper layer?

Finding new and interesting corner cases for such a beast can be quite
entertaining.  And until someone has properly documented the semantics
for _all_ the corner cases, my enthusiasm is below freezing point.  Does
such a documentation exist?

Jörn

-- 
A surrounded army must be given a way out.
-- Sun Tzu
