Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbXHGIaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbXHGIaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbXHGIaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:30:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51223 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbXHGIaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:30:06 -0400
Date: Tue, 7 Aug 2007 10:30:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?C=E9dric?= Augonnet <cedric.augonnet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <andi@firstfloor.org>,
       loic@myri.com, brice@myri.com, cedric.augonnet@ens-lyon.org
Subject: Re: [PATCH 0/2] PAT support for i386 and x86_64
Message-ID: <20070807083004.GB30085@one.firstfloor.org>
References: <f56c1ba00708061903r29baea3dj6b57032be5820983@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f56c1ba00708061903r29baea3dj6b57032be5820983@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 10:03:15PM -0400, Cédric Augonnet wrote:
> Hi all,
> 
> For quite a while now, there as been numerous attempt to introduce support for
> Page Attribute Table (PAT) in the Linux kernel, whereas most other OS already
> have some support for this feature. Such a proposition popping up periodically,
> perhaps it would be an opportunity to fix that lack for once.

The trouble is you need to avoid conflicting attributes, otherwise
you risk cache corruption. This means the direct mapping needs to be fixed
up and the kernel needs to keep track of the ranges to prevent conflicts.

Also when there is already a MTRR it might not work due to the complicated
rules of MTRR<->PAT interaction.

Then there are old CPU errata that need to be handled etc.

There are also some other issues.

You didn't solve all that at all. If it was as simple as your patch
we would have long done it already.

-Andi

