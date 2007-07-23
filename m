Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbXGWB0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbXGWB0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762691AbXGWB0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:26:19 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41550 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755640AbXGWB0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:26:18 -0400
Date: Mon, 23 Jul 2007 03:25:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Ville Tervo <ville.tervo@nokia.com>, Marcel Holtmann <marcel@holtmann.org>,
       maxk@qualcomm.com
Cc: bluez-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: net/bluetooth/rfcomm/tty.c: use-after-free
Message-ID: <20070723012543.GW26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8de0a15483b357d0f0b821330ec84d1660cadc4e added the following 
use-after-free in net/bluetooth/rfcomm/tty.c:

<--  snip  -->

...
static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
{
...
        if (IS_ERR(dev->tty_dev)) {
                list_del(&dev->list);
                kfree(dev);
                return PTR_ERR(dev->tty_dev);
        }
...

<--  snip  -->

Spotted by the Coverity checker.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

