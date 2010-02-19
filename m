Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0BSXXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 18:23:18 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:36103 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab0BSXXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 18:23:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TuOueD5eCcDgqkP6crUhIYTHhCTRqE6Kam8tGtP1Eeuf54JA+SlmsmR6/Z1+WFOwT+
         qA+ElrzyrpvCffMmO7ShDSkLLp8hbYixvGVFedJhKUDFka9O/N83xOiOHYU/NFS5M+VX
         sIj61RMzX8W++NxBaTY/XQ5PktgztGI9Pv1ZE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002192143130.22461@skynet.skynet.ie>
References: <alpine.DEB.2.00.1002192143130.22461@skynet.skynet.ie>
Date: Sat, 20 Feb 2010 09:23:11 +1000
Message-ID: <21d7e9971002191523l34549860j9f54ad49f60fa40d@mail.gmail.com>
Subject: Re: [git pull] drm regression final fixes
From: Dave Airlie <airlied@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Linus
>
> hope you get this before release, if not stable life, the main fix is a
> major regression on AGP/no-pat systems where pages ended up in uncached,
>
> a further fix to the vgaarb fix, and a fix to make rv740 gpus just work
> for now (they have some tile/backend quirk that AMD haven't tracked down
> yet, so we'll do the proper fix in .34, this is a minimal workaround for
> now).

Alex suggested we bump UMS version number for the rv740 fix.

635f1a31292087a2e99568bf4451c10ee287adaa
drm/radeon: bump the UMS driver version number to indicate rv740 fix

    This lets UMS userspace know the rv740 fix is in. For KMS we can
    consider the kernel release to be the v2.0.0 release so we don't need the
    bump there.

    Signed-off-by: Dave Airlie <airlied@redhat.com>

Is on to of the tree now.

Dave.

>
> Dave.
>
> The following changes since commit 6b15835282f9c6a023e2625455bfdb822bb9cc64:
>  Dave Airlie (1):
>        Merge branch 'for-airlied' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-linus
>
> are available in the git repository at:
>
>  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>
> Alex Deucher (3):
>      drm/radeon/kms/rs600: add connector quirk
>      drm/radeon/kms: fix shared ddc detection
>      drm/radeon/rv740: fix backend setup
>
> Francisco Jerez (1):
>      drm/ttm: fix caching problem on non-PAT systems.
>
> Jerome Glisse (1):
>      drm/radeon/kms: free fence IB if it wasn't emited at IB free time
>
> Kyle McMartin (1):
>      vgaarb: fix "target=default" passing
>
>  drivers/gpu/drm/radeon/r600_cp.c           |    9 ++++++---
>  drivers/gpu/drm/radeon/radeon_atombios.c   |    9 +++++++++
>  drivers/gpu/drm/radeon/radeon_connectors.c |    5 ++---
>  drivers/gpu/drm/radeon/radeon_ring.c       |    2 ++
>  drivers/gpu/drm/radeon/rv770.c             |    9 ++++++---
>  drivers/gpu/drm/ttm/ttm_tt.c               |   18 +++++++++++-------
>  drivers/gpu/vga/vgaarb.c                   |    2 +-
>  7 files changed, 37 insertions(+), 17 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
