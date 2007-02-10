Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbXBJKDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbXBJKDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 05:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbXBJKDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 05:03:45 -0500
Received: from rubidium.solidboot.com ([81.22.244.175]:34623 "EHLO
	mail.solidboot.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbXBJKDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 05:03:45 -0500
Date: Sat, 10 Feb 2007 12:03:40 +0200
From: Imre Deak <imre.deak@solidboot.com>
To: rmk@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DEV: zero: use correct pgprot for zeromapping
Message-ID: <20070210100340.GA7519@bitbox.mine.nu>
References: <20070210091521.GA7350@bitbox.mine.nu> <20070210093954.GA29145@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210093954.GA29145@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 09:39:54AM +0000, Russell King wrote:
> On Sat, Feb 10, 2007 at 11:15:21AM +0200, Imre Deak wrote:
> > Instead of PAGE_COPY use the pgprot bits established already at
> > original mapping time of the VMA. This will also include any
> > architecture specific bits setup through protection_map.
> > zeromap_page_range will take care of COW'ing the passed pgprot.
> 
> NAK.  What if PAGE_COPY is used elsewhere and ends up accidentally
> allowing write access?

Or rather, result in the bogus global mapping. True.

> 
> I think the right solution is to make PAGE_COPY a variable in the same
> way that PAGE_KERNEL is, and adjust it as appropriate.

Ok, and also at least PAGE_SHARED and PAGE_READONLY I assume.

--Imre
