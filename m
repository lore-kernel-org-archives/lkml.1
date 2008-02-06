Return-Path: <linux-kernel-owner+w=401wt.eu-S1763248AbYBFXIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763248AbYBFXIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762093AbYBFXFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:05:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:20974 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761144AbYBFXFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:05:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G2nTgYUpxq8rhJpF61GiJItuCMT21wpUijKiA3CyyKwGIS9diSJplBLuKoHInoxHknvjnp1Yj7Zp0+WyUvTMBIWZ3Ru8LYttIhxdvo+zjixL0KBWVm7agGWUEM+kKCkhDQD+BDl6Y9BKDBtcd8HAs5BYZGLyFS0JoKZPsvtdAEc=
Message-ID: <6101e8c40802061505u45a0cca7gc14f9398c5631258@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:05:46 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {10/17} - via-velocity-dont-oops-on-mtu-change-1 - series for stable kernel #2
In-Reply-To: <6101e8c40802011734v57f59e99o18c66db3bc7a15e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011734v57f59e99o18c66db3bc7a15e0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Thu, 15 Nov 2007 03:47:27 +0000 (-0800)
Subject: [VIA_VELOCITY]: Don't oops on MTU change.
Patch-mainline: v2.6.24-rc3
References: 341537

[VIA_VELOCITY]: Don't oops on MTU change.

Simple mtu change when device is down.
Fix http://bugzilla.kernel.org/show_bug.cgi?id=9382.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/net/via-velocity.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/via-velocity.c	2008-01-03 15:18:35.000000000 -0500
+++ b/drivers/net/via-velocity.c	2008-01-03 15:18:50.000000000 -0500
@@ -1798,6 +1798,11 @@ static int velocity_change_mtu(struct ne
 		return -EINVAL;
 	}

+	if (!netif_running(dev)) {
+		dev->mtu = new_mtu;
+		return 0;
+	}
+
 	if (new_mtu != oldmtu) {
 		spin_lock_irqsave(&vptr->lock, flags);



On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: bd7b3f34198071d8bec05180530c362f1800ba46
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
