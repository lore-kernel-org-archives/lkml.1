Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996Ab0A3RSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab0A3RSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 12:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745Ab0A3RSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 12:18:24 -0500
Received: from mail-qy0-f182.google.com ([209.85.221.182]:51337 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab0A3RSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 12:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jd98l5mD7gC2PFvt8s9s9V40wLkQF+QOT+YcwfmPCtaBFG/4PJ+tkzN+1/v4TSWOa1
         mOx7tJI4WvEfgW0//pVCbRcTV7/uA4S9K+Wjos1SlxW5HpvQ/a2m3eqHwJ2245ohdACx
         QCntzqDbL8rdsHAXg3ce0fDGzTh+DOBgeqEJo=
Subject: Radeon KMS regression still present in 2.6.33-rc6
From: Kevin Winchester <kjwinchester@gmail.com>
To: torvalds@linux-foundation.org
Cc: Dave Airlie <airlied@linux.ie>, dri-devel <dri-devel@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 13:18:19 -0400
Message-ID: <1264871899.1533.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not quite sure if this can be called a regression, since radeon KMS
is still in staging as far as I know, but it was working quite well for
me up until about -rc3, and now it causes a panic on every boot.  If I
pass radeon.modeset=0 on the command line, everything works.

I took a picture of the crash details:

http://picasaweb.google.ca/kjwinchester/LinuxKernelPanic#5432580230065271634

I was hoping that the last pull of DRM fixes would correct the issue,
but unfortunately they had no effect.

In case it helps, here is the gdb listing for the problem address:

(gdb) l *(radeon_agp_init+0x1d)
0xffffffff811c1592 is in radeon_agp_init (drivers/gpu/drm/radeon/radeon_agp.c:136).
131		uint32_t agp_status;
132		int default_mode;
133		bool is_v3;
134		int ret;
135	
136		if (rdev->ddev->agp->agp_info.aper_size < 32) {
137			dev_warn(rdev->dev, "AGP aperture to small (%dM) "
138				"need at least 32M, disabling AGP\n",
139				rdev->ddev->agp->agp_info.aper_size);
140			return -EINVAL;

Is there any other info I can provide?

Thanks,

-- 
Kevin Winchester


