Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXDZGzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXDZGzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbXDZGzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:55:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8531 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbXDZGzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qGzVIvjA3rpMX+sdeIbJJtql0VaPxXI1T0XQPk1HaFyuoIJs5wrDwR8RJNX1MgvTSxpoggF4kvbWdLky9uYdTauWuS0dONFEM2iVgB7htxtD1GhyZSFjjvJt+DrgqUT2+UBuy+HCFdJgtiCROxYzfEGcxHs0kX/qNncrgP+pCKA=
Message-ID: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
Date: Thu, 26 Apr 2007 16:55:14 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH] DRM TTM Memory Manager patch
Cc: "=?ISO-8859-1?Q?Thomas_Hellstr=F6m?=" <thomas@tungstengraphics.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric Anholt" <eric@anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch is too big to fit on the list and I've no idea how we could
break it down further, it just happens to be a lot of new code..

http://people.freedesktop.org/~airlied/ttm/0001-drm-Implement-TTM-Memory-manager-core-functionality.txt

The patch header and diffstat are below,

This isn't for integration yet but we'd like an initial review by
anyone with the spare time and inclination, there is a lot stuff
relying on getting this code bet into shape and into the kernel but
any cleanups people can suggest now especially to the user interfaces
would be appreciated as once we set that stuff in stone it'll be a
pain to change... also it doesn't have any driver side code, this is
just the generic pieces. I'll post the intel 915 side code later but
there isn't that much to it..

It applies on top of my drm-2.6 git tree drm-mm branch....

-----------------------------------------------------------------------------------------------------

This patch brings in the TTM (Translation Table Maps) memory management
system from Thomas Hellstrom at Tungsten Graphics.

This patch only covers the core functionality and changes to the drm core.

The TTM memory manager enables dynamic mapping of memory objects in and
out of the graphic card accessible memory (e.g. AGP), this implements
the AGP backend for TTM to be used by the i915 driver.


 drivers/char/drm/Makefile         |    3 +-
 drivers/char/drm/drm.h            |  238 ++++-
 drivers/char/drm/drmP.h           |  153 +++-
 drivers/char/drm/drm_agpsupport.c |  160 +++
 drivers/char/drm/drm_bo.c         | 2329 ++++++++++++++++++++++++++++++++++++
 drivers/char/drm/drm_bo_move.c    |  395 +++++++
 drivers/char/drm/drm_bufs.c       |    2 +
 drivers/char/drm/drm_drv.c        |   46 +-
 drivers/char/drm/drm_fence.c      |  661 +++++++++++
 drivers/char/drm/drm_fops.c       |   75 ++-
 drivers/char/drm/drm_memory.c     |   69 ++
 drivers/char/drm/drm_mm.c         |   13 +-
 drivers/char/drm/drm_object.c     |  293 +++++
 drivers/char/drm/drm_objects.h    |  464 ++++++++
 drivers/char/drm/drm_proc.c       |   90 ++
 drivers/char/drm/drm_stub.c       |   24 +-
 drivers/char/drm/drm_ttm.c        |  337 ++++++
 drivers/char/drm/drm_vm.c         |  193 +++-
 18 files changed, 5503 insertions(+), 42 deletions(-)
