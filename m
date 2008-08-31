Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYHaFbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYHaFbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 01:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYHaFbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 01:31:09 -0400
Received: from 175.212.DSNET ([203.110.175.212]:25552 "EHLO mail.atheros.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750802AbYHaFbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 01:31:08 -0400
From: Jie Yang <Jie.Yang@Atheros.com>
To: Matthew Wilcox <matthew@wil.cx>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>,
       "harn-solo@gmx.de" <harn-solo@gmx.de>,
       "jeff@garzik.org" <jeff@garzik.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 31 Aug 2008 13:31:02 +0800
Subject: RE: [PATCH]atl1e:fix bug [Bug 11454] New: atl1e - BUG: scheduling
 while atomic: modprobe/678/0x00000002
Thread-Topic: [PATCH]atl1e:fix bug [Bug 11454] New: atl1e - BUG: scheduling
 while atomic: modprobe/678/0x00000002
Thread-Index: AckLJ+NFMUJpDpg1QoipKHy6HWPkeQAAX2mw
Message-ID: <72981EBCFD196144B7C6999B9FC34A9A3EE62D7C3C@SHEXMB-01.global.atheros.com>
References: <12201583182726-git-send-email-jie.yang@atheros.com>
 <20080831050837.GK1239@parisc-linux.org>
In-Reply-To: <20080831050837.GK1239@parisc-linux.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 31, 2008 1:09 PM
Matthew Wilcox <matthew@wil.cx> wrote:
> How about taking my original patch, sent August 12th instead?
>  That has a good changelog and proper attribution.  The
> removal of the unnecessary casts can be a separate message.
>
> If you weren't cc'd on the patch (Jeff was), you can pick it
> up from netdev.
>
Yes, I do have the patch, should I resend with Signed-off-by: Matthew Wilcox <willy@linux.intel.com>.
for that patch may have conflicts now.

the origin patch:
diff --git a/drivers/net/atl1e/atl1e_main.c b/drivers/net/atl1e/atl1e_main.c index 82d7be1..ba22a51 100644
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -2389,9 +2389,7 @@ static int __devinit atl1e_probe(struct pci_dev *pdev,
        }

        /* Init GPHY as early as possible due to power saving issue  */
-       spin_lock(&adapter->mdio_lock);
        atl1e_phy_init(&adapter->hw);
-       spin_unlock(&adapter->mdio_lock);
        /* reset the controller to
         * put the device in a known good starting state */
        err = atl1e_reset_hw(&adapter->hw);

the new one:
diff --git a/drivers/net/atl1e/atl1e_main.c b/drivers/net/atl1e/atl1e_main.c
index 7685b99..9b60352 100644
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -2390,9 +2390,7 @@ static int __devinit atl1e_probe(struct pci_dev *pdev,
        }

        /* Init GPHY as early as possible due to power saving issue  */
-       spin_lock(&adapter->mdio_lock);
        atl1e_phy_init(&adapter->hw);
-       spin_unlock(&adapter->mdio_lock);
        /* reset the controller to
         * put the device in a known good starting state */
        err = atl1e_reset_hw(&adapter->hw);

the line num changed from 2389 to 2390.  :(

Best wishes
jie
