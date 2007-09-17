Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbXIQJbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbXIQJbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXIQJbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:31:06 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:45834 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbXIQJbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:31:05 -0400
Date: Mon, 17 Sep 2007 13:31:06 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <gregkh@suse.de>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070917133106.B21399@jurassic.park.msu.ru>
References: <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no> <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no> <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca> <20070914151401.A5586@jurassic.park.msu.ru> <46EA9B23.7030709@shaw.ca> <20070914192913.A6668@jurassic.park.msu.ru> <46EB1F16.8060209@shaw.ca> <20070916151355.A18508@jurassic.park.msu.ru> <20070916195258.GC28350@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20070916195258.GC28350@parisc-linux.org>; from matthew@wil.cx on Sun, Sep 16, 2007 at 01:52:59PM -0600
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 01:52:59PM -0600, Matthew Wilcox wrote:
> I don't think it would be that complicated.  We could just delay probing
> for mmconfig until after the pci bus probes are done.  No changes to
> other architectures needed.

Indeed. Seems like it's a way to go.

> I'm really disappointed with mmconfig.  Here was a great chance to get
> rid of all the sucky performance problems of the past, and BIOS writers
> and chipset designers have fucked up the implementation so much that
> it's now the ugliest method for getting to pci config space.  And it's
> the *only* method of getting to extended config space.

Same feeling...

Fortunately, it seems that we don't access the extended config space
during bus probe.

Ivan.
