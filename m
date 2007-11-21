Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbXKUHmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbXKUHmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 02:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXKUHmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 02:42:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40462 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755434AbXKUHmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:42:44 -0500
Date: Tue, 20 Nov 2007 23:42:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Airlie" <airlied@gmail.com>
Cc: "Dave Airlie" <airlied@linux.ie>, linux-kernel@vger.kernel.org
Subject: Re: Prospects of DRM TTM making it into 2.6.24?
Message-Id: <20071120234231.251a5b8f.akpm@linux-foundation.org>
In-Reply-To: <21d7e9970711202336m2e4f998fgc13df8a3a74101e4@mail.gmail.com>
References: <alpine.DEB.0.82.0711192151010.1284@skynet.skynet.ie>
	<20071119141554.649b590e.akpm@linux-foundation.org>
	<21d7e9970711202336m2e4f998fgc13df8a3a74101e4@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 17:36:33 +1000 "Dave Airlie" <airlied@gmail.com> wrote:

> > >
> > > I also have a few AGP changes I need to line up to support the chipset
> > > flushing work I've done to support TTM properly..
> > >
> >
> > Did anything happen with that null-pointer deref I was hitting?
> >
> 
> I've rebased the patches in my tree along with a chunk I missed which
> should make your patch unnecessary.

ok..

> Do you pull my agp-mm tree into -mm?
> 
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6 agp-mm
> if not..

I pull
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git#agp-mm
and
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git#drm-mm

the agp tree was empty when I last pulled it, ~12 hours ago.

<looks>

There's stuff there now:

GIT d9b38a24bdbeeb38c03de7172a30769333452d10 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git#agp-mm

commit d9b38a24bdbeeb38c03de7172a30769333452d10
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Nov 21 16:36:31 2007 +1000

    agp/intel: Add chipset flushing support for i8xx chipsets.
    
    This is a bit of a large hammer but it makes sure the chipset is flushed
    by writing out 1k of data to an uncached page. We may be able to get better
    information in the future on how to this better.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f5b8bc5801bc9676935cb7d2417a636a08e2e06d
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Oct 29 18:06:10 2007 +1000

    intel-agp: add chipset flushing support
    
    This adds support for flushing the chipsets on the 915, 945, 965 and G33
    families of Intel chips.
    
    The BIOS doesn't seem to always allocate the BAR on the 965 chipsets
    so I have to use pci resource code to create a resource
    
    It adds an export for pcibios_align_resource.

commit 5beaa1edf58ef2a477049f21842a8f12f28b8366
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Oct 29 15:14:03 2007 +1000

    agp: add chipset flushing support to AGP interface
    
    This bumps the AGP interface to 0.103.
    
    Certain Intel chipsets contains a global write buffer, and this can require
    flushing from the drm or X.org to make sure all data has hit RAM before
    initiating a GPU transfer, due to a lack of coherency with the integrated
    graphics device and this buffer.
    
    This just adds generic support to the AGP interfaces, a follow-on patch
    will add support to the Intel driver to use this interface.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
 arch/x86/pci/i386.c             |    2 +-
 drivers/char/agp/agp.h          |    3 +-
 drivers/char/agp/backend.c      |    2 +-
 drivers/char/agp/compat_ioctl.c |    4 +
 drivers/char/agp/compat_ioctl.h |    2 +
 drivers/char/agp/frontend.c     |   11 +++
 drivers/char/agp/generic.c      |    7 ++
 drivers/char/agp/intel-agp.c    |  150 +++++++++++++++++++++++++++++++++++++++
 include/linux/agp_backend.h     |    1 +
 include/linux/agpgart.h         |    1 +
 10 files changed, 180 insertions(+), 3 deletions(-)


