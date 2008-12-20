Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYLTU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYLTU6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 15:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYLTU6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 15:58:12 -0500
Received: from 8bytes.org ([88.198.83.132]:47365 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbYLTU6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 15:58:11 -0500
Date: Sat, 20 Dec 2008 21:58:08 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20081220205808.GA4465@8bytes.org>
References: <20081220134353.GA16399@elte.hu> <alpine.LFD.2.00.0812201112210.14014@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812201112210.14014@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 11:16:01AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 20 Dec 2008, Ingo Molnar wrote:
> > 
> > Joerg Roedel (3):
> >       AMD IOMMU: panic if completion wait loop fails
> 
> What's the advantage to this, especially this late in the game?
> 
> Now, I tried to google for the message (while ignoring the patches), and 
> as far as I can tell, it has never happened that google has noticed. But 
> still, why was this pushed as a "fix"?

Google won't tell because the hardware is not yet for sale. The story
behind this patch is, it happened that the completion wait loop failed in
my tests.

And when it fails then for sure because some error occured and the AMD
IOMMU stopped fetching commands from the command buffer (the reason why
it stopped fetching commands for me is also fixed with another patch in
this pull request, but there may be other reasons like internal errors).
But it is important that the IOMMU fetches commands because they are
needed to flush the IOTLB. If we can't flush the IOTLB we get data
corruption sooner or later. So I decided its better to panic in this
situation.

There is another way to handle this by resetting the command buffer. But
that is more code (basically code to flush the IOMMU cache for
everything we have under control with the IOMMU). Too much for inclusion
that late in the release cycle. I will prepare that for one of the
future merge windows.

For now, the best 'fix' in this situation is to panic before data
corruption can happen.

Joerg
