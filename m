Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbXJOXF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbXJOXF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXJOXFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:05:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49503 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751385AbXJOXFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:05:11 -0400
Date: Tue, 16 Oct 2007 09:04:33 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>, David Chinner <dgc@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       XFS masters <xfs-masters@oss.sgi.com>,
       Morten =?iso-8859-1?B?QsO4Z2Vza292?= 
	<xen-users@morten.bogeskov.dk>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: [PATCH 12/12] xfs: eagerly remove vmap mappings to avoid upsetting Xen
Message-ID: <20071015230432.GO995458@sgi.com>
References: <20071015204840.074767068@goop.org> <20071015210115.506967748@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015210115.506967748@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 01:48:52PM -0700, Jeremy Fitzhardinge wrote:
> XFS leaves stray mappings around when it vmaps memory to make it
> virtually contigious.  This upsets Xen if one of those pages is being
> recycled into a pagetable, since it finds an extra writable mapping of
> the page.
> 
> This patch solves the problem in a brute force way, by making XFS
> always eagerly unmap its mappings.  David Chinner says this shouldn't
> have any performance impact on filesystems with default block sizes;
> it will only affect filesystems with large block sizes.

Looks fine, Jeremy. I'll pull this into our dev tree and it should
get pushed with the .24 XFS merge (if someone doesn't pull these
patches directly).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
