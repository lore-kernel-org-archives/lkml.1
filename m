Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbXDPFsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbXDPFsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 01:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXDPFsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 01:48:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:42191 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbXDPFsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 01:48:18 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Mon, 16 Apr 2007 15:47:21 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17955.3561.821387.134466@notabene.brown>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "J. Bruce Fields" <bfields@fieldses.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: message from Theodore Tso on Sunday April 15
References: <17947.65165.569482.976343@notabene.brown>
	<20070411144252.GB17778@thunk.org>
	<17949.25061.739035.688232@notabene.brown>
	<20070411232224.GF17778@thunk.org>
	<17949.36737.701327.104172@notabene.brown>
	<20070412023712.GA8175@lazybastard.org>
	<17949.51797.386833.917451@notabene.brown>
	<20070412122116.GD28148@thunk.org>
	<20070412171831.GD3028@fieldses.org>
	<461E6DF5.6040808@zytor.com>
	<20070416030511.GC27533@thunk.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday April 15, tytso@mit.edu wrote:
> On Thu, Apr 12, 2007 at 10:35:49AM -0700, H. Peter Anvin wrote:
> > 
> > Any fixed size is too small.  It should be a dynamic size.
> 
> Idally it should be dynamic, but my guess is that if the cookie were a
> fixed 256 bits, it would be sufficient for pretty much all filesystems.  
> 

"my guess", "pretty much" really bother me.

It sounds like "The largest anyone has asked for is 128bits, or let's
double it and hope that is enough until the next protocol revision".
Which was probably reasonable when NFSv2 was being developed and maybe
even when v3 was developed, but I kind of hoped we were beyond that.

If a filesystem wanted to order filenames lexically, it really needs
256 *bytes*.  And it is fairly silly having a cookie that big.

I still thinking that 
   filename + 64bits
is required and plenty (aka necessary and sufficient).  You would need
a truly enormous directory before that would be insufficient for an
off-set based scheme or a hash-plus-collision scheme, and it is
clearly enough for a lexically-ordered scheme.

I wouldn't argue against 128bits (64 for a search key and 64 to
guarantee uniqueness) but I really think 256 excessive with no value.
We we still need the last-filename in the READDIR key.

(Mind you, I'm still wondering why NFSv4 felt the need for 128 *byte*
 file handles so maybe I'm just small minded :-)

NeilBrown
