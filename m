Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbYDGOQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbYDGOQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 10:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbYDGOQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 10:16:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:11704 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163AbYDGOQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 10:16:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=I/61r+JmurC/qSFTqa8kDYnk9rf4yVp5jnK/V0psYfxbx+ufZpatEnHoWX7+32Ao7S+JWQD50Kdza4mGmq1PWDpxKymADElK++UbgSwzrlpYbZCo8Zh3g+2iCxrDDbZQJ+GM/mIVvk1fFZc/ATkvfrFiKQDEDwOo3WktAy9hzbE=
Message-ID: <94a0ccbc0804070716o152040fdo1fcff740a0719971@mail.gmail.com>
Date: Mon, 7 Apr 2008 18:16:36 +0400
From: "Oleg Strikov" <oleg.strikov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc8 PHY Davicom DM9161AEP driver: incorrect mii_bus:phy_addr & irq detecting [AT91SAM9260-EK board]
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found that the latest kernel PHY Davicom DM9161A driver
(linux/drivers/net/phy/davicom.c) does not work correctly with Davicom
DM9161AEP PHY controller on Atmel AT91SAM9260-EK board.
During init stage i get incorrect driver output:

>eth0: Atmel MACB at 0xfffc4000 irq 21 (00:00:00:00:00:00)
>eth0: attached PHY driver [Davicom DM9161A]
(mii_bus:phy_addr=ffffffff:00, irq=-1)

It seems that MACB initialization pass O.K.
&
PHY driver does not get correct phy_addr & irq values.

MB DM9161AEP controller cannot be handled by DM9161A driver, but it
tries to catch it based in the same ID?
