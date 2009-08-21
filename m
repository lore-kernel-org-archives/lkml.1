Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZHUJdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZHUJdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 05:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZHUJdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 05:33:46 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:59764 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbZHUJdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 05:33:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qzq+LkFyzKH1b78misHFhYxmVTI6cz7XgDo2norSEi+/22npxHTV7SNUtqUgkzJe8W
         n3VmVZkjUy8Zk/4PN6cEfzeOFRJNkxR/kZCN8Q+TBK9pEg0Jm86Np2wyxI1WStzUJs9z
         5/e2W0WNFSQ4KFxTvEQ3/LTrfWeKrvliBLRyg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0908210155390.18106@skynet.skynet.ie>
References: <alpine.DEB.2.00.0908210155390.18106@skynet.skynet.ie>
Date: Fri, 21 Aug 2009 19:33:45 +1000
Message-ID: <21d7e9970908210233g2a7951b6i1c1a6e4e1761c2b3@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 10:57 AM, Dave Airlie<airlied@linux.ie> wrote:
>
> Hi Linus,
>
> Please pull the 'drm-fixes' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes
>
> One bad use of sysfs devices could cause possible oops on all KMS,
> along with a patch to report some more card specific info for certain
> rv530s, and a couple of radeon-kms specific patches.

The last commit got changed to f779b3e513478218cbaaaa0a506d7801cab6fd14
something managed to mangle my CONFIG_STAGING and avoid building things.

Same commits otherwise.

Dave.

>
> Dave.
>
>  drivers/gpu/drm/drm_sysfs.c           |   51 ++++++++++++++++++--------------
>  drivers/gpu/drm/radeon/r100.c         |   10 ++++++
>  drivers/gpu/drm/radeon/r300.c         |    4 ++-
>  drivers/gpu/drm/radeon/r420.c         |   13 ++++++++-
>  drivers/gpu/drm/radeon/r520.c         |    1 -
>  drivers/gpu/drm/radeon/radeon.h       |    1 +
>  drivers/gpu/drm/radeon/radeon_cp.c    |    9 ++++++
>  drivers/gpu/drm/radeon/radeon_drv.h   |    5 ++-
>  drivers/gpu/drm/radeon/radeon_gem.c   |    2 +-
>  drivers/gpu/drm/radeon/radeon_kms.c   |    4 ++
>  drivers/gpu/drm/radeon/radeon_reg.h   |    3 ++
>  drivers/gpu/drm/radeon/radeon_state.c |    3 ++
>  include/drm/radeon_drm.h              |    4 ++
>  13 files changed, 83 insertions(+), 27 deletions(-)
>
> commit ddd5a5b91e3f25d2e216225ea2216a72ca9477fc
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Wed Aug 19 19:11:39 2009 -0400
>
>    drm/radeon: add GET_PARAM/INFO support for Z pipes
>
>    Needed for occlusion queries on rv530 chips.
>
>    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 17782d99502851dc7e48114ee9c5a6d6741cba18
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Fri Aug 21 10:07:54 2009 +1000
>
>    drm/radeon/kms: add r100/r200 OQ support.
>
>    This adds the relocation necessary for OQ support on the r100/r200
>    chipsets.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 08e4d534743f4e9af3602aebbc1cca9372762028
> Author: Thomas Hellstrom <thellstrom@vmware.com>
> Date:   Thu Aug 20 19:02:31 2009 +1000
>
>    drm: Fix sysfs device confusion.
>
>    The drm sysfs class suspend / resume methods could not distinguish
>    between different device types wich could lead to illegal type casts.
>
>    Use struct device_type and make sure the class suspend / resume callbacks
>    are aware of those. There is no per device-type suspend / resume. Only
>    new-style PM.
>
>    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
>    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit e3b2415e281a97ade36d88404094a90cfea838c0
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Fri Aug 21 09:47:45 2009 +1000
>
>    drm/radeon/kms: implement the bo busy ioctl properly.
>
>    The previous patch assumes the ioctl already existed, when
>    it actually didn't.
>
>    It also didn't return the correct error code.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
