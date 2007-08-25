Return-Path: <linux-kernel-owner+w=401wt.eu-S964881AbXHYJMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881AbXHYJMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXHYJMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:12:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41822 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214AbXHYJMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:12:12 -0400
X-Greylist: delayed 2322 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2007 05:12:12 EDT
Date: Sat, 25 Aug 2007 09:33:29 +0100 (IST)
From: Dave Airlie <airlied@skynet.ie>
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] agp patches for 2.6.23-rc4
Message-ID: <Pine.LNX.4.64.0708250932070.778@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-patches' branch from
git://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-patches

actually this patch is a pci id, ioremap checks and a coverity fix... the 
drm patch has no pci id change..

Dave.

  drivers/char/agp/amd-k7-agp.c   |    2 ++
  drivers/char/agp/ati-agp.c      |    3 +++
  drivers/char/agp/efficeon-agp.c |    2 ++
  drivers/char/agp/hp-agp.c       |    1 +
  drivers/char/agp/i460-agp.c     |    4 ++++
  drivers/char/agp/intel-agp.c    |   14 +++++++++-----
  drivers/char/agp/nvidia-agp.c   |    3 +++
  drivers/char/agp/via-agp.c      |    5 +++++
  include/linux/pci_ids.h         |    1 +
  9 files changed, 30 insertions(+), 5 deletions(-)

commit 5bdbc7dc2c07d507b41bffdadc2c8cc13b2d4326
Author: Scott Thompson <postfail at hushmail.com>
Date:   Sat Aug 25 18:14:00 2007 +1000

     agp: balance ioremap checks

     patchset against 2.6.23-rc3.
     corrects missing ioremap return checks and balancing on iounmap calls, integrated changes per list
     recommendations on the original set of patches..

     Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 32ddef98f232585f20bc8bdb891029a6a5f633d0
Author: Xavier Bachelot <xavier@bachelot.org>
Date:   Sat Aug 25 18:10:52 2007 +1000

     agp: Add device id for P4M900 to via-agp module

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit db7f3ded8d42c60b0d0a4f71d621e105790b872b
Author: Jesper Juhl <jesper.juhl@gmail.com>
Date:   Sat Aug 4 20:30:58 2007 +0200

     efficeon-agp leaks 'struct agp_bridge_data' in error paths of agp_efficeon_probe()

     (This is a resend of a patch originally submitted on 24-Jul-2007 00:14)

     Ok, this is something the coverity checker found (CID: 1813).
     I'm not at all intimate with this code, so I'm not sure if this
     attempt at a fix is correct (but at least it compiles).

     Please look it over and NACK if bad or merge if good ;-)

     Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
     Signed-off-by: Dave Airlie <airlied@linux.ie>
