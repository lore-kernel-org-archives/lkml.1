Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbXEHGQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbXEHGQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbXEHGQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:16:24 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:38084 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbXEHGQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:16:23 -0400
Date: Tue, 8 May 2007 07:16:21 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] drm tree with driver changes for 2.6.22-rc1
Message-ID: <Pine.LNX.4.64.0705080714560.5546@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1471283169-1178604981=:5546"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1471283169-1178604981=:5546
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-patches' branch from
git://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

This contains updates to the radeon and via drm drivers and cleans up the
ati pcigart code in order to add support for the integrated rs480 chipsets.

It also pulls in some fixes for via and radeon drivers from the DRI teams.

Hopefully I got the diffstat correct..

Dave.

  drivers/char/drm/ati_pcigart.c  |   84 ++++++++++++++++--------------
  drivers/char/drm/drmP.h         |    7 ++-
  drivers/char/drm/drm_drv.c      |   10 ++--
  drivers/char/drm/drm_os_linux.h |    3 -
  drivers/char/drm/drm_pciids.h   |    1 +
  drivers/char/drm/r128_cce.c     |    3 +-
  drivers/char/drm/r128_drv.h     |    2 +
  drivers/char/drm/radeon_cp.c    |   71 +++++++++++++++++++++++--
  drivers/char/drm/radeon_drm.h   |    1 +
  drivers/char/drm/radeon_drv.h   |   24 ++++++++-
  drivers/char/drm/radeon_state.c |   52 +++++++++---------
  drivers/char/drm/via_dma.c      |  111 ++++++++++++++++-----------------------
  drivers/char/drm/via_drv.h      |    5 +-
  13 files changed, 222 insertions(+), 152 deletions(-)

commit ef68d295508d52e792abf70d4f84461104d33b9d
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Tue May 8 15:48:39 2007 +1000

     via: Make sure we flush write-combining using a follow-up read.

     Signed-off-by: Dave Airlie <airlied@linux.ie>


commit a0a6dd0b221260be1e3da725e6b49797e5fa7429
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Tue May 8 15:47:41 2007 +1000

     via: Try to improve command-buffer chaining.

     Bump driver date and patchlevel.

     Signed-off-by: Dave Airlie <airlied@linux.ie>


commit bc07dc7f07a2f2d4d0aa4ffb9597413ad9137d44
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue May 8 15:32:35 2007 +1000

     drm: remove old taskqueue remnant

     Signed-off-by: Dave Airlie <airlied@linux.ie>


commit 0515b93c0ea89eb2120b0ec1d148359da01ad2e5
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue May 8 15:28:15 2007 +1000

     drm: rename badly named define and cleanup ioctl code spacing

     Signed-off-by: Dave Airlie <airlied@linux.ie>


commit 453ff94ca502d0a7441912823f20ed130f685429
Author: Michel Dänzer <michel@tungstengraphics.com>
Date:   Tue May 8 15:21:14 2007 +1000

     radeon: Don't mess up page flipping when a file descriptor is closed.

     There can still be other contexts that may use page flipping later on, so do
     just unilaterally 'clean it up', which could lead to the wrong page being
     displayed, e.g. when running 3D apps with a GLX compositing manager such as
     compiz using page flipping.

     Signed-off-by: Dave Airlie <airlied@linux.ie>


commit f2b04cd219e5c0f1214c0eeeec814ddd08a12c1b
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue May 8 15:19:23 2007 +1000

     drm/radeon: upgrade to 1.27 - make PCI GART more flexible

     radeon: make PCI GART aperture size variable, but making table size variable
         This is precursor to getting a TTM backend for this stuff, and also
         allows the PCI table to be allocated at fb 0
     radeon: add support for reverse engineered xpress200m

         The IGPGART setup code was traced using mmio-trace on fglrx by myself
         and Phillip Ezolt <phillipezolt@gmail.com> on dri-devel.

         This code doesn't let the 3D driver work properly as the card has no
         vertex shader support.

         Thanks to Matthew Garrett + Ubuntu for providing me some hardware to do this
         work on.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

--29444707-1471283169-1178604981=:5546--
