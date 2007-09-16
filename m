Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbXIPTxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbXIPTxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbXIPTxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:53:01 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52855 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXIPTxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:53:00 -0400
Date: Sun, 16 Sep 2007 13:52:59 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <gregkh@suse.de>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070916195258.GC28350@parisc-linux.org>
References: <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no> <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no> <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no> <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca> <20070914151401.A5586@jurassic.park.msu.ru> <46EA9B23.7030709@shaw.ca> <20070914192913.A6668@jurassic.park.msu.ru> <46EB1F16.8060209@shaw.ca> <20070916151355.A18508@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916151355.A18508@jurassic.park.msu.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 03:13:55PM +0400, Ivan Kokshaysky wrote:
> Another possible solution is not to use mmconfig for bar sizing at all,
> if it's *that* broken. It would be more complicated though, since it
> probably requires changes to all architectures.

I don't think it would be that complicated.  We could just delay probing
for mmconfig until after the pci bus probes are done.  No changes to
other architectures needed.

I'm really disappointed with mmconfig.  Here was a great chance to get
rid of all the sucky performance problems of the past, and BIOS writers
and chipset designers have fucked up the implementation so much that
it's now the ugliest method for getting to pci config space.  And it's
the *only* method of getting to extended config space.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
