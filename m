Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbXFQQWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbXFQQWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXFQQWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:22:38 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:8346 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbXFQQWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:22:37 -0400
Date: Sun, 17 Jun 2007 18:22:35 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Cc: eric@anholt.net, zhenyu.z.wang@intel.com
Subject: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070617162235.GA5486@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614011506.GA30566@alinoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 03:15:06AM +0200, Carlo Wood wrote:
> Hi Dave, I have an amd64 box for which every kernel
> after 2.6.18 hangs during boot, so I have no dmesg :(
> 
> I used git bisect to find out where the problem patch is,
> and assuming bisect works (imho it jumped between versions
> very weirdly: closing in on the last 6 revisions, it
> jumped from 2.6.18 to 2.6.18-rc2 to 2.6.18-rc6), the problem
> is a patch in intel-agp.c, where support for the intel 965G
> is added (which I have).
> 
> I mailed the author of the patch, including the git Id
> of that patch... but he didn't reply... and I didn't keep the
> mail :/ So, I am afraid I can't give much details.
> 
> I'd still like to have it sorted out. If you give me the
> green light (in the sense that you are willing to help
> a kernel-newbie when needed) then I'll have another
> attempt at getting more information.

Dave, I have no idea why you never replied to this -- don't
you care that kernels 2.6.19 through 2.6.21 lockup on boot? --
here is a follow up on this matter.

I am not sure which patch it was exactly that broke things, but
I think it was:

    [AGPGART] Intel 965 Express support.
        
	    From: Alan Hourihane <alanh@tungstengraphics.com>
	    From: Eric Anholt <eric@anholt.net>
	    Signed-off-by: Dave Jones <davej@redhat.com>

65c25aadfa4e917060e99fe459f33a6a07db53cc

which was supplied after 2.6.18 and before 2.6.19-rc1.

If I remember that correctly, then Alan should have a mail
from me with the exact git Id (he never replied either).

The patch causes my machine to lock up and/or crash
in various ways (depending on the exact version of the kernel),
very shortly after printing: agpgart: Detected an Intel 965G Chipset.

The first kernel version that stops doing that is 2.6.22-rc5.
I used git bisect once more to find the patch that fixes this bug:

commit 9614ece14f23f2ce54a076c471aec9c91e51e79c
Author: Wang Zhenyu <zhenyu.z.wang@intel.com>
Date:   Wed May 30 09:45:58 2007 +0800

    [AGPGART] intel_agp: use table for device probe

    Fixed issues noted by Christoph Hellwig, and I changed device table
    scan a bit to allow the case that some models of graphics chips may
    have same host bridge type. This type of chip will be added in the future.

    This patch cleans up device probe function. Eric Anholt was the original aut hor.

    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

:040000 040000 625da154215c98f9016e14b952131a0c1ec8597b cddcf0b42d3632d20d7ee863 91d6ae6d258632e2 M      drivers

I am mailing this mostly because the comment doesn't seem to indicate
that the author is aware that this patch fixes an existing regression
(it worked fine for me with 2.6.18).

Anyway, thanks for fixing this Wang Zhenyu.

If anyone wants to know more (like what hardware I'm using), please
show me that you're actually alive / reading my mails.

-- 
Carlo Wood <carlo@alinoe.com>
