Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbZHVAYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbZHVAYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 20:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbZHVAYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 20:24:16 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60632 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992AbZHVAYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 20:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version
         :content-type:message-id;
        b=jI28o0tdUi2rczqhCL/D+GIj9uhQd1c+q96oDql5ez/El02g1bgjuhtgfTPSuAzP4c
         CmGZRd1xwd9x3y/au1COaOgCAShL1K9aBlsj60M/zD4OgneOWJY8w2RVW9647KNhlDDB
         n6yCQlSMgeJsyLgLpFjXfFzurn490AO+uaAEc=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH] Convert MMC subsys drivers to dev_pm_ops
Date: Sat, 22 Aug 2009 02:23:50 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-1-amd64; KDE/4.3.0; x86_64; ; )
Cc: nicolas.ferre@atmel.com, mirq-linux@rere.qmqm.pl,
       linux-kernel@vger.kernel.org, manuel.lauss@gmail.com, ppisa@pikron.com,
       nico@cam.org, maen@marvell.com, s.hauer@pengutronix.de,
       tony@atomide.com, madhu.cr@ti.com, drzeus@drzeus.cx,
       ben-linux@fluff.org, avorontsov@ru.mvista.com, pierre@ossman.eu,
       sdhci-devel@lists.ossman.eu, saschasommer@freenet.de, oakad@yahoo.com,
       ian@mnementh.co.uk, HaraldWelte@viatech.com, JosephChan@via.com.tw
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WqzjKW574GHb21w"
Message-Id: <200908220223.50588.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_WqzjKW574GHb21w
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This converts most of the drivers found in drivers/mmc/host to dev_pm_ops.
Also, it contains some fixes for the probe/remove functions in some cases.

This needs testing, so I'd be very glad if the affected maintainers expressed 
their opinion on this.

Cheers!

--Boundary-00=_WqzjKW574GHb21w
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-Convert-MMC-subsys-drivers-to-dev_pm_ops.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Convert-MMC-subsys-drivers-to-dev_pm_ops.patch"

=46rom 66978eef1d2bd64222901f0b6c6d9c35dcca044e Mon Sep 17 00:00:00 2001
=46rom: Marek Vasut <marek.vasut@gmail.com>
Date: Sat, 22 Aug 2009 02:10:27 +0200
Subject: [PATCH] Convert MMC subsys drivers to dev_pm_ops

This converts most of the drivers found in drivers/mmc/host to dev_pm_ops.
Also, it contains some fixes for the probe/remove functions in some cases.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
=2D--
 drivers/mmc/core/core.c       |    3 +-
 drivers/mmc/host/at91_mci.c   |   28 ++++++++++++++----------
 drivers/mmc/host/au1xmmc.c    |   29 ++++++++++++++-----------
 drivers/mmc/host/cb710-mmc.c  |   26 ++++++++++++++---------
 drivers/mmc/host/imxmmc.c     |   34 +++++++++++++++++-------------
 drivers/mmc/host/mmci.c       |    2 +-
 drivers/mmc/host/mvsdio.c     |   33 +++++++++++++++++------------
 drivers/mmc/host/mxcmmc.c     |   29 ++++++++++++++-----------
 drivers/mmc/host/omap.c       |   26 ++++++++++++----------
 drivers/mmc/host/omap_hsmmc.c |   28 +++++++++++++-----------
 drivers/mmc/host/pxamci.c     |   28 +++++++++++++-----------
 drivers/mmc/host/s3cmci.c     |   46 +++++++++++++++++++++++--------------=
=2D--
 drivers/mmc/host/sdhci-of.c   |    2 +-
 drivers/mmc/host/sdhci.c      |    2 +-
 drivers/mmc/host/sdricoh_cs.c |    2 +-
 drivers/mmc/host/tifm_sd.c    |    2 +-
 drivers/mmc/host/tmio_mmc.c   |   41 +++++++++++++++++++-----------------
 drivers/mmc/host/via-sdmmc.c  |    2 +-
 drivers/mmc/host/wbsd.c       |    2 +-
 include/linux/mmc/host.h      |    2 +-
 20 files changed, 203 insertions(+), 164 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d84c880..d8be595 100644
=2D-- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -971,9 +971,8 @@ void mmc_stop_host(struct mmc_host *host)
 /**
  *	mmc_suspend_host - suspend a host
  *	@host: mmc host
=2D *	@state: suspend mode (PM_SUSPEND_xxx)
  */
=2Dint mmc_suspend_host(struct mmc_host *host, pm_message_t state)
+int mmc_suspend_host(struct mmc_host *host)
 {
 	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index e556d42..baece9d 100644
=2D-- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -982,7 +982,7 @@ static const struct mmc_host_ops at91_mci_ops =3D {
 /*
  * Probe for the device
  */
=2Dstatic int __init at91_mci_probe(struct platform_device *pdev)
+static int __devinit at91_mci_probe(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
 	struct at91mci_host *host;
@@ -1144,7 +1144,7 @@ fail6:
 /*
  * Remove a device
  */
=2Dstatic int __exit at91_mci_remove(struct platform_device *pdev)
+static int __devexit at91_mci_remove(struct platform_device *pdev)
 {
 	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	struct at91mci_host *host;
@@ -1187,8 +1187,9 @@ static int __exit at91_mci_remove(struct platform_dev=
ice *pdev)
 }
=20
 #ifdef CONFIG_PM
=2Dstatic int at91_mci_suspend(struct platform_device *pdev, pm_message_t s=
tate)
+static int at91_mci_suspend(struct device *dev)
 {
+	struct platform_device *pdev =3D to_platform_device(dev);
 	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	struct at91mci_host *host =3D mmc_priv(mmc);
 	int ret =3D 0;
@@ -1197,13 +1198,14 @@ static int at91_mci_suspend(struct platform_device =
*pdev, pm_message_t state)
 		enable_irq_wake(host->board->det_pin);
=20
 	if (mmc)
=2D		ret =3D mmc_suspend_host(mmc, state);
+		ret =3D mmc_suspend_host(mmc);
=20
 	return ret;
 }
=20
=2Dstatic int at91_mci_resume(struct platform_device *pdev)
+static int at91_mci_resume(struct device *dev)
 {
+	struct platform_device *pdev =3D to_platform_device(dev);
 	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	struct at91mci_host *host =3D mmc_priv(mmc);
 	int ret =3D 0;
@@ -1216,24 +1218,26 @@ static int at91_mci_resume(struct platform_device *=
pdev)
=20
 	return ret;
 }
=2D#else
=2D#define at91_mci_suspend	NULL
=2D#define at91_mci_resume		NULL
=2D#endif
=20
=2Dstatic struct platform_driver at91_mci_driver =3D {
=2D	.remove		=3D __exit_p(at91_mci_remove),
+static struct dev_pm_ops at91_mci_pm_ops =3D {
 	.suspend	=3D at91_mci_suspend,
 	.resume		=3D at91_mci_resume,
+};
+#endif
+
+static struct platform_driver at91_mci_driver =3D {
+	.probe		=3D at91_mci_probe,
+	.remove		=3D __devexit_p(at91_mci_remove),
 	.driver		=3D {
 		.name	=3D DRIVER_NAME,
 		.owner	=3D THIS_MODULE,
+		.pm	=3D &at91_mci_pm_ops,
 	},
 };
=20
 static int __init at91_mci_init(void)
 {
=2D	return platform_driver_probe(&at91_mci_driver, at91_mci_probe);
+	return platform_driver_register(&at91_mci_driver);
 }
=20
 static void __exit at91_mci_exit(void)
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index d3f5561..350c0b3 100644
=2D-- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1132,12 +1132,13 @@ static int __devexit au1xmmc_remove(struct platform=
_device *pdev)
 }
=20
 #ifdef CONFIG_PM
=2Dstatic int au1xmmc_suspend(struct platform_device *pdev, pm_message_t st=
ate)
+static int au1xmmc_suspend(struct device *dev)
 {
+	struct platform_device *pdev =3D to_platform_device(dev);
 	struct au1xmmc_host *host =3D platform_get_drvdata(pdev);
 	int ret;
=20
=2D	ret =3D mmc_suspend_host(host->mmc, state);
+	ret =3D mmc_suspend_host(host->mmc);
 	if (ret)
 		return ret;
=20
@@ -1150,27 +1151,29 @@ static int au1xmmc_suspend(struct platform_device *=
pdev, pm_message_t state)
 	return 0;
 }
=20
=2Dstatic int au1xmmc_resume(struct platform_device *pdev)
+static int au1xmmc_resume(struct device *dev)
 {
+	struct platform_device *pdev =3D to_platform_device(dev);
 	struct au1xmmc_host *host =3D platform_get_drvdata(pdev);
=20
 	au1xmmc_reset_controller(host);
=20
 	return mmc_resume_host(host->mmc);
 }
=2D#else
=2D#define au1xmmc_suspend NULL
=2D#define au1xmmc_resume NULL
=2D#endif
=20
=2Dstatic struct platform_driver au1xmmc_driver =3D {
=2D	.probe         =3D au1xmmc_probe,
=2D	.remove        =3D au1xmmc_remove,
+static struct dev_pm_ops au1xmmc_pm_ops =3D {
 	.suspend       =3D au1xmmc_suspend,
 	.resume        =3D au1xmmc_resume,
=2D	.driver        =3D {
=2D		.name  =3D DRIVER_NAME,
=2D		.owner =3D THIS_MODULE,
+};
+#endif
+
+static struct platform_driver au1xmmc_driver =3D {
+	.probe		=3D au1xmmc_probe,
+	.remove		=3D __devexit_p(au1xmmc_remove),
+	.driver		=3D {
+		.name	=3D DRIVER_NAME,
+		.owner	=3D THIS_MODULE,
+		.pm	=3D &au1xmmc_pm_ops,
 	},
 };
=20
diff --git a/drivers/mmc/host/cb710-mmc.c b/drivers/mmc/host/cb710-mmc.c
index 11efefb..b595297 100644
=2D-- a/drivers/mmc/host/cb710-mmc.c
+++ b/drivers/mmc/host/cb710-mmc.c
@@ -670,13 +670,14 @@ static const struct mmc_host_ops cb710_mmc_host =3D {
=20
 #ifdef CONFIG_PM
=20
=2Dstatic int cb710_mmc_suspend(struct platform_device *pdev, pm_message_t =
state)
+static int cb710_mmc_suspend(struct device *dev)
 {
+	struct platform_device *pdev =3D to_platform_device(dev);
 	struct cb710_slot *slot =3D cb710_pdev_to_slot(pdev);
 	struct mmc_host *mmc =3D cb710_slot_to_mmc(slot);
 	int err;
=20
=2D	err =3D mmc_suspend_host(mmc, state);
+	err =3D mmc_suspend_host(mmc);
 	if (err)
 		return err;
=20
@@ -684,8 +685,9 @@ static int cb710_mmc_suspend(struct platform_device *pd=
ev, pm_message_t state)
 	return 0;
 }
=20
=2Dstatic int cb710_mmc_resume(struct platform_device *pdev)
+static int cb710_mmc_resume(struct device *dev)
 {
+	struct platform_device *pdev =3D to_platform_device(dev);
 	struct cb710_slot *slot =3D cb710_pdev_to_slot(pdev);
 	struct mmc_host *mmc =3D cb710_slot_to_mmc(slot);
=20
@@ -694,6 +696,10 @@ static int cb710_mmc_resume(struct platform_device *pd=
ev)
 	return mmc_resume_host(mmc);
 }
=20
+static struct dev_pm_ops cm710_mmc_pm_ops =3D {
+	.suspend =3D cb710_mmc_suspend,
+	.resume =3D cb710_mmc_resume,
+};
 #endif /* CONFIG_PM */
=20
 static int __devinit cb710_mmc_init(struct platform_device *pdev)
@@ -776,13 +782,13 @@ static int __devexit cb710_mmc_exit(struct platform_d=
evice *pdev)
 }
=20
 static struct platform_driver cb710_mmc_driver =3D {
=2D	.driver.name =3D "cb710-mmc",
=2D	.probe =3D cb710_mmc_init,
=2D	.remove =3D __devexit_p(cb710_mmc_exit),
=2D#ifdef CONFIG_PM
=2D	.suspend =3D cb710_mmc_suspend,
=2D	.resume =3D cb710_mmc_resume,
=2D#endif
+	.driver	=3D {
+		.name	=3D "cb710-mmc",
+		.owner	=3D THIS_MODULE,
+		.pm	=3D &cb710_mmc_pm_ops,
+	},
+	.probe	=3D cb710_mmc_init,
+	.remove	=3D __devexit_p(cb710_mmc_exit),
 };
=20
 static int __init cb710_mmc_init_module(void)
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index e0be21a..02bf3af 100644
=2D-- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -933,7 +933,7 @@ static void imxmci_check_status(unsigned long data)
 	mod_timer(&host->timer, jiffies + (HZ>>1));
 }
=20
=2Dstatic int __init imxmci_probe(struct platform_device *pdev)
+static int __devinit imxmci_probe(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
 	struct imxmci_host *host =3D NULL;
@@ -1075,7 +1075,7 @@ out:
 	return ret;
 }
=20
=2Dstatic int __exit imxmci_remove(struct platform_device *pdev)
+static int __devexit imxmci_remove(struct platform_device *pdev)
 {
 	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
=20
@@ -1109,20 +1109,22 @@ static int __exit imxmci_remove(struct platform_dev=
ice *pdev)
 }
=20
 #ifdef CONFIG_PM
=2Dstatic int imxmci_suspend(struct platform_device *dev, pm_message_t stat=
e)
+static int imxmci_suspend(struct device *dev)
 {
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	int ret =3D 0;
=20
 	if (mmc)
=2D		ret =3D mmc_suspend_host(mmc, state);
+		ret =3D mmc_suspend_host(mmc);
=20
 	return ret;
 }
=20
=2Dstatic int imxmci_resume(struct platform_device *dev)
+static int imxmci_resume(struct device *dev)
 {
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	struct imxmci_host *host;
 	int ret =3D 0;
=20
@@ -1135,24 +1137,26 @@ static int imxmci_resume(struct platform_device *de=
v)
=20
 	return ret;
 }
=2D#else
=2D#define imxmci_suspend  NULL
=2D#define imxmci_resume   NULL
=2D#endif /* CONFIG_PM */
=20
=2Dstatic struct platform_driver imxmci_driver =3D {
=2D	.remove		=3D __exit_p(imxmci_remove),
+static struct dev_pm_ops imxmci_pm_ops =3D {
 	.suspend	=3D imxmci_suspend,
 	.resume		=3D imxmci_resume,
+};
+#endif /* CONFIG_PM */
+
+static struct platform_driver imxmci_driver =3D {
+	.probe		=3D imxmci_probe,
+	.remove		=3D __devexit_p(imxmci_remove),
 	.driver		=3D {
 		.name		=3D DRIVER_NAME,
 		.owner		=3D THIS_MODULE,
=2D	}
+		.pm		=3D &imxmci_pm_ops,
+	},
 };
=20
 static int __init imxmci_init(void)
 {
=2D	return platform_driver_probe(&imxmci_driver, imxmci_probe);
+	return platform_driver_register(&imxmci_driver);
 }
=20
 static void __exit imxmci_exit(void)
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index e1aa847..4567c1f 100644
=2D-- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -676,7 +676,7 @@ static int mmci_suspend(struct amba_device *dev, pm_mes=
sage_t state)
 	if (mmc) {
 		struct mmci_host *host =3D mmc_priv(mmc);
=20
=2D		ret =3D mmc_suspend_host(mmc, state);
+		ret =3D mmc_suspend_host(mmc);
 		if (ret =3D=3D 0)
 			writel(0, host->base + MMCIMASK0);
 	}
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index b56d72f..cff55d7 100644
=2D-- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -700,7 +700,7 @@ static void __init mv_conf_mbus_windows(struct mvsd_hos=
t *host,
 	}
 }
=20
=2Dstatic int __init mvsd_probe(struct platform_device *pdev)
+static int __devinit mvsd_probe(struct platform_device *pdev)
 {
 	struct mmc_host *mmc =3D NULL;
 	struct mvsd_host *host =3D NULL;
@@ -833,7 +833,7 @@ out:
 	return ret;
 }
=20
=2Dstatic int __exit mvsd_remove(struct platform_device *pdev)
+static int __devexit mvsd_remove(struct platform_device *pdev)
 {
 	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
=20
@@ -859,20 +859,22 @@ static int __exit mvsd_remove(struct platform_device =
*pdev)
 }
=20
 #ifdef CONFIG_PM
=2Dstatic int mvsd_suspend(struct platform_device *dev, pm_message_t state)
+static int mvsd_suspend(struct device *dev)
 {
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	int ret =3D 0;
=20
 	if (mmc)
=2D		ret =3D mmc_suspend_host(mmc, state);
+		ret =3D mmc_suspend_host(mmc);
=20
 	return ret;
 }
=20
=2Dstatic int mvsd_resume(struct platform_device *dev)
+static int mvsd_resume(struct device *dev)
 {
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	int ret =3D 0;
=20
 	if (mmc)
@@ -880,23 +882,26 @@ static int mvsd_resume(struct platform_device *dev)
=20
 	return ret;
 }
=2D#else
=2D#define mvsd_suspend	NULL
=2D#define mvsd_resume	NULL
=2D#endif
=20
=2Dstatic struct platform_driver mvsd_driver =3D {
=2D	.remove		=3D __exit_p(mvsd_remove),
+static struct dev_pm_ops mvsd_pm_ops =3D {
 	.suspend	=3D mvsd_suspend,
 	.resume		=3D mvsd_resume,
+};
+#endif
+
+static struct platform_driver mvsd_driver =3D {
+	.probe		=3D mvsd_probe,
+	.remove		=3D __devexit_p(mvsd_remove),
 	.driver		=3D {
 		.name	=3D DRIVER_NAME,
+		.owner	=3D THIS_DRIVER,
+		.pm	=3D &mvsd_pm_ops,
 	},
 };
=20
 static int __init mvsd_init(void)
 {
=2D	return platform_driver_probe(&mvsd_driver, mvsd_probe);
+	return platform_driver_register(&mvsd_driver);
 }
=20
 static void __exit mvsd_exit(void)
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index bc14bb1..676e40f 100644
=2D-- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -675,7 +675,7 @@ static const struct mmc_host_ops mxcmci_ops =3D {
 	.get_ro		=3D mxcmci_get_ro,
 };
=20
=2Dstatic int mxcmci_probe(struct platform_device *pdev)
+static int __devinit mxcmci_probe(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
 	struct mxcmci_host *host =3D NULL;
@@ -813,7 +813,7 @@ out_release_mem:
 	return ret;
 }
=20
=2Dstatic int mxcmci_remove(struct platform_device *pdev)
+static int __devexit mxcmci_remove(struct platform_device *pdev)
 {
 	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	struct mxcmci_host *host =3D mmc_priv(mmc);
@@ -842,20 +842,22 @@ static int mxcmci_remove(struct platform_device *pdev)
 }
=20
 #ifdef CONFIG_PM
=2Dstatic int mxcmci_suspend(struct platform_device *dev, pm_message_t stat=
e)
+static int mxcmci_suspend(struct device *dev)
 {
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	int ret =3D 0;
=20
 	if (mmc)
=2D		ret =3D mmc_suspend_host(mmc, state);
+		ret =3D mmc_suspend_host(mmc);
=20
 	return ret;
 }
=20
=2Dstatic int mxcmci_resume(struct platform_device *dev)
+static int mxcmci_resume(struct device *dev)
 {
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	struct mxcmci_host *host;
 	int ret =3D 0;
=20
@@ -866,19 +868,20 @@ static int mxcmci_resume(struct platform_device *dev)
=20
 	return ret;
 }
=2D#else
=2D#define mxcmci_suspend  NULL
=2D#define mxcmci_resume   NULL
+
+static struct dev_pm_ops mxcmci_pm_ops =3D {
+	.suspend	=3D mxcmci_suspend,
+	.resume		=3D mxcmci_resume,
+};
 #endif /* CONFIG_PM */
=20
 static struct platform_driver mxcmci_driver =3D {
 	.probe		=3D mxcmci_probe,
=2D	.remove		=3D mxcmci_remove,
=2D	.suspend	=3D mxcmci_suspend,
=2D	.resume		=3D mxcmci_resume,
+	.remove		=3D __devexit_p(mxcmci_remove),
 	.driver		=3D {
 		.name		=3D DRIVER_NAME,
 		.owner		=3D THIS_MODULE,
+		.pm		=3D &mxcmci_pm_ops,
 	}
 };
=20
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index e7a331d..2fc3bb8 100644
=2D-- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1392,7 +1392,7 @@ static void mmc_omap_remove_slot(struct mmc_omap_slot=
 *slot)
 	mmc_free_host(mmc);
 }
=20
=2Dstatic int __init mmc_omap_probe(struct platform_device *pdev)
+static int __devinit mmc_omap_probe(struct platform_device *pdev)
 {
 	struct omap_mmc_platform_data *pdata =3D pdev->dev.platform_data;
 	struct mmc_omap_host *host =3D NULL;
@@ -1513,7 +1513,7 @@ err_free_mem_region:
 	return ret;
 }
=20
=2Dstatic int mmc_omap_remove(struct platform_device *pdev)
+static int __devexit mmc_omap_remove(struct platform_device *pdev)
 {
 	struct mmc_omap_host *host =3D platform_get_drvdata(pdev);
 	int i;
@@ -1543,9 +1543,10 @@ static int mmc_omap_remove(struct platform_device *p=
dev)
 }
=20
 #ifdef CONFIG_PM
=2Dstatic int mmc_omap_suspend(struct platform_device *pdev, pm_message_t m=
esg)
+static int mmc_omap_suspend(struct device *dev)
 {
 	int i, ret =3D 0;
+	struct platform_device *pdev =3D to_platform_device(dev);
 	struct mmc_omap_host *host =3D platform_get_drvdata(pdev);
=20
 	if (host =3D=3D NULL || host->suspended)
@@ -1555,7 +1556,7 @@ static int mmc_omap_suspend(struct platform_device *p=
dev, pm_message_t mesg)
 		struct mmc_omap_slot *slot;
=20
 		slot =3D host->slots[i];
=2D		ret =3D mmc_suspend_host(slot->mmc, mesg);
+		ret =3D mmc_suspend_host(slot->mmc);
 		if (ret < 0) {
 			while (--i >=3D 0) {
 				slot =3D host->slots[i];
@@ -1568,9 +1569,10 @@ static int mmc_omap_suspend(struct platform_device *=
pdev, pm_message_t mesg)
 	return 0;
 }
=20
=2Dstatic int mmc_omap_resume(struct platform_device *pdev)
+static int mmc_omap_resume(struct device *dev)
 {
 	int i, ret =3D 0;
+	struct platform_device *pdev =3D to_platform_device(dev);
 	struct mmc_omap_host *host =3D platform_get_drvdata(pdev);
=20
 	if (host =3D=3D NULL || !host->suspended)
@@ -1587,15 +1589,15 @@ static int mmc_omap_resume(struct platform_device *=
pdev)
 	}
 	return 0;
 }
=2D#else
=2D#define mmc_omap_suspend	NULL
=2D#define mmc_omap_resume		NULL
+static struct dev_pm_ops mmc_omap_pm_ops =3D {
+	.suspend	=3D mmc_omap_suspend,
+	.resume		=3D mmc_omap_resume,
+};
 #endif
=20
 static struct platform_driver mmc_omap_driver =3D {
=2D	.remove		=3D mmc_omap_remove,
=2D	.suspend	=3D mmc_omap_suspend,
=2D	.resume		=3D mmc_omap_resume,
+	.probe		=3D mmc_omap_probe,
+	.remove		=3D __devexit_p(mmc_omap_remove),
 	.driver		=3D {
 		.name	=3D DRIVER_NAME,
 		.owner	=3D THIS_MODULE,
@@ -1604,7 +1606,7 @@ static struct platform_driver mmc_omap_driver =3D {
=20
 static int __init mmc_omap_init(void)
 {
=2D	return platform_driver_probe(&mmc_omap_driver, mmc_omap_probe);
+	return platform_driver_register(&mmc_omap_driver);
 }
=20
 static void __exit mmc_omap_exit(void)
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1cf9cfb..fd04f1e 100644
=2D-- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -967,7 +967,7 @@ static struct mmc_host_ops mmc_omap_ops =3D {
 	/* NYET -- enable_sdio_irq */
 };
=20
=2Dstatic int __init omap_mmc_probe(struct platform_device *pdev)
+static int __devinit omap_mmc_probe(struct platform_device *pdev)
 {
 	struct omap_mmc_platform_data *pdata =3D pdev->dev.platform_data;
 	struct mmc_host *mmc;
@@ -1180,7 +1180,7 @@ err:
 	return ret;
 }
=20
=2Dstatic int omap_mmc_remove(struct platform_device *pdev)
+static int __devexit omap_mmc_remove(struct platform_device *pdev)
 {
 	struct mmc_omap_host *host =3D platform_get_drvdata(pdev);
 	struct resource *res;
@@ -1216,16 +1216,17 @@ static int omap_mmc_remove(struct platform_device *=
pdev)
 }
=20
 #ifdef CONFIG_PM
=2Dstatic int omap_mmc_suspend(struct platform_device *pdev, pm_message_t s=
tate)
+static int omap_mmc_suspend(struct device *pdev)
 {
 	int ret =3D 0;
+	struct platform_device *pdev =3D to_platform_device(dev);
 	struct mmc_omap_host *host =3D platform_get_drvdata(pdev);
=20
 	if (host && host->suspended)
 		return 0;
=20
 	if (host) {
=2D		ret =3D mmc_suspend_host(host->mmc, state);
+		ret =3D mmc_suspend_host(host->mmc);
 		if (ret =3D=3D 0) {
 			host->suspended =3D 1;
=20
@@ -1253,9 +1254,10 @@ static int omap_mmc_suspend(struct platform_device *=
pdev, pm_message_t state)
 }
=20
 /* Routine to resume the MMC device */
=2Dstatic int omap_mmc_resume(struct platform_device *pdev)
+static int omap_mmc_resume(struct device *pdev)
 {
 	int ret =3D 0;
+	struct platform_device *pdev =3D to_platform_device(dev);
 	struct mmc_omap_host *host =3D platform_get_drvdata(pdev);
=20
 	if (host && !host->suspended)
@@ -1301,19 +1303,19 @@ clk_en_err:
 	return ret;
 }
=20
=2D#else
=2D#define omap_mmc_suspend	NULL
=2D#define omap_mmc_resume		NULL
+static struct dev_pm_ops omap_mmc_pm_ops =3D {
+	.suspend	=3D omap_mmc_suspend,
+	.resume		=3D omap_mmc_resume,
+};
 #endif
=20
 static struct platform_driver omap_mmc_driver =3D {
 	.probe		=3D omap_mmc_probe,
=2D	.remove		=3D omap_mmc_remove,
=2D	.suspend	=3D omap_mmc_suspend,
=2D	.resume		=3D omap_mmc_resume,
+	.remove		=3D __devexit_p(omap_mmc_remove),
 	.driver		=3D {
=2D		.name =3D DRIVER_NAME,
=2D		.owner =3D THIS_MODULE,
+		.name	=3D DRIVER_NAME,
+		.owner	=3D THIS_MODULE,
+		.pm	=3D &omap_mmc_pm_ops,
 	},
 };
=20
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 972efa8..1fa867c 100644
=2D-- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -544,7 +544,7 @@ static irqreturn_t pxamci_detect_irq(int irq, void *dev=
id)
 	return IRQ_HANDLED;
 }
=20
=2Dstatic int pxamci_probe(struct platform_device *pdev)
+static int __devinit pxamci_probe(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
 	struct pxamci_host *host =3D NULL;
@@ -750,7 +750,7 @@ err_gpio_ro:
 	return ret;
 }
=20
=2Dstatic int pxamci_remove(struct platform_device *pdev)
+static int __devexit pxamci_remove(struct platform_device *pdev)
 {
 	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	int gpio_cd =3D -1, gpio_ro =3D -1, gpio_power =3D -1;
@@ -804,20 +804,22 @@ static int pxamci_remove(struct platform_device *pdev)
 }
=20
 #ifdef CONFIG_PM
=2Dstatic int pxamci_suspend(struct platform_device *dev, pm_message_t stat=
e)
+static int pxamci_suspend(struct device *dev)
 {
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	int ret =3D 0;
=20
 	if (mmc)
=2D		ret =3D mmc_suspend_host(mmc, state);
+		ret =3D mmc_suspend_host(mmc);
=20
 	return ret;
 }
=20
=2Dstatic int pxamci_resume(struct platform_device *dev)
+static int pxamci_resume(struct device *dev)
 {
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	int ret =3D 0;
=20
 	if (mmc)
@@ -825,19 +827,19 @@ static int pxamci_resume(struct platform_device *dev)
=20
 	return ret;
 }
=2D#else
=2D#define pxamci_suspend	NULL
=2D#define pxamci_resume	NULL
+static struct dev_pm_ops pxamci_pm_ops =3D {
+	.suspend	=3D pxamci_suspend,
+	.resume		=3D pxamci_resume,
+};
 #endif
=20
 static struct platform_driver pxamci_driver =3D {
 	.probe		=3D pxamci_probe,
=2D	.remove		=3D pxamci_remove,
=2D	.suspend	=3D pxamci_suspend,
=2D	.resume		=3D pxamci_resume,
+	.remove		=3D __devexit_p(pxamci_remove),
 	.driver		=3D {
 		.name	=3D DRIVER_NAME,
 		.owner	=3D THIS_MODULE,
+		.pm	=3D &pxamci_pm_ops,
 	},
 };
=20
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 8c08cd7..b3b3e1d 100644
=2D-- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1492,54 +1492,60 @@ static int __devinit s3cmci_2440_probe(struct platf=
orm_device *dev)
=20
 #ifdef CONFIG_PM
=20
=2Dstatic int s3cmci_suspend(struct platform_device *dev, pm_message_t stat=
e)
+static int s3cmci_suspend(struct device *dev)
 {
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
=20
=2D	return  mmc_suspend_host(mmc, state);
+	return  mmc_suspend_host(mmc);
 }
=20
=2Dstatic int s3cmci_resume(struct platform_device *dev)
+static int s3cmci_resume(struct device *dev)
 {
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
=20
 	return mmc_resume_host(mmc);
 }
=20
=2D#else /* CONFIG_PM */
=2D#define s3cmci_suspend NULL
=2D#define s3cmci_resume NULL
+static struct dev_pm_ops s3cmci_pm_ops =3D {
+	.suspend	=3D s3cmci_suspend,
+	.resume		=3D s3cmci_resume,
+};
 #endif /* CONFIG_PM */
=20
=20
 static struct platform_driver s3cmci_2410_driver =3D {
=2D	.driver.name	=3D "s3c2410-sdi",
=2D	.driver.owner	=3D THIS_MODULE,
+	.driver	=3D {
+		.name	=3D "s3c2410-sdi",
+		.owner	=3D THIS_MODULE,
+		.pm	=3D &s3cmci_pm_ops,
+	},
 	.probe		=3D s3cmci_2410_probe,
 	.remove		=3D __devexit_p(s3cmci_remove),
 	.shutdown	=3D s3cmci_shutdown,
=2D	.suspend	=3D s3cmci_suspend,
=2D	.resume		=3D s3cmci_resume,
 };
=20
 static struct platform_driver s3cmci_2412_driver =3D {
=2D	.driver.name	=3D "s3c2412-sdi",
=2D	.driver.owner	=3D THIS_MODULE,
+	.driver	=3D {
+		.name	=3D "s3c2412-sdi",
+		.owner	=3D THIS_MODULE,
+		.pm	=3D &s3cmci_pm_ops,
+	},
 	.probe		=3D s3cmci_2412_probe,
 	.remove		=3D __devexit_p(s3cmci_remove),
 	.shutdown	=3D s3cmci_shutdown,
=2D	.suspend	=3D s3cmci_suspend,
=2D	.resume		=3D s3cmci_resume,
 };
=20
 static struct platform_driver s3cmci_2440_driver =3D {
=2D	.driver.name	=3D "s3c2440-sdi",
=2D	.driver.owner	=3D THIS_MODULE,
+	.driver	=3D {
+		.name	=3D "s3c2440-sdi",
+		.owner	=3D THIS_MODULE,
+		.pm	=3D &s3cmci_pm_ops,
+	},
 	.probe		=3D s3cmci_2440_probe,
 	.remove		=3D __devexit_p(s3cmci_remove),
 	.shutdown	=3D s3cmci_shutdown,
=2D	.suspend	=3D s3cmci_suspend,
=2D	.resume		=3D s3cmci_resume,
 };
=20
=20
diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
index d79fa55..0370a96 100644
=2D-- a/drivers/mmc/host/sdhci-of.c
+++ b/drivers/mmc/host/sdhci-of.c
@@ -194,7 +194,7 @@ static int sdhci_of_suspend(struct of_device *ofdev, pm=
_message_t state)
 {
 	struct sdhci_host *host =3D dev_get_drvdata(&ofdev->dev);
=20
=2D	return mmc_suspend_host(host->mmc, state);
+	return mmc_suspend_host(host->mmc);
 }
=20
 static int sdhci_of_resume(struct of_device *ofdev)
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6779b4e..de8e763 100644
=2D-- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1576,7 +1576,7 @@ int sdhci_suspend_host(struct sdhci_host *host, pm_me=
ssage_t state)
=20
 	sdhci_disable_card_detection(host);
=20
=2D	ret =3D mmc_suspend_host(host->mmc, state);
+	ret =3D mmc_suspend_host(host->mmc);
 	if (ret)
 		return ret;
=20
diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index cb41e9c..e7507af 100644
=2D-- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -519,7 +519,7 @@ static int sdricoh_pcmcia_suspend(struct pcmcia_device =
*link)
 {
 	struct mmc_host *mmc =3D link->priv;
 	dev_dbg(&link->dev, "suspend\n");
=2D	mmc_suspend_host(mmc, PMSG_SUSPEND);
+	mmc_suspend_host(mmc);
 	return 0;
 }
=20
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 82554dd..cec9995 100644
=2D-- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -1032,7 +1032,7 @@ static void tifm_sd_remove(struct tifm_dev *sock)
=20
 static int tifm_sd_suspend(struct tifm_dev *sock, pm_message_t state)
 {
=2D	return mmc_suspend_host(tifm_get_drvdata(sock), state);
+	return mmc_suspend_host(tifm_get_drvdata(sock));
 }
=20
 static int tifm_sd_resume(struct tifm_dev *sock)
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 91991b4..042d827 100644
=2D-- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -466,31 +466,33 @@ static struct mmc_host_ops tmio_mmc_ops =3D {
 };
=20
 #ifdef CONFIG_PM
=2Dstatic int tmio_mmc_suspend(struct platform_device *dev, pm_message_t st=
ate)
+static int tmio_mmc_suspend(struct device *dev)
 {
=2D	struct mfd_cell	*cell =3D (struct mfd_cell *)dev->dev.platform_data;
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mfd_cell	*cell =3D (struct mfd_cell *)pdev->dev.platform_data;
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	int ret;
=20
=2D	ret =3D mmc_suspend_host(mmc, state);
+	ret =3D mmc_suspend_host(mmc);
=20
 	/* Tell MFD core it can disable us now.*/
 	if (!ret && cell->disable)
=2D		cell->disable(dev);
+		cell->disable(pdev);
=20
 	return ret;
 }
=20
=2Dstatic int tmio_mmc_resume(struct platform_device *dev)
+static int tmio_mmc_resume(struct device *dev)
 {
=2D	struct mfd_cell	*cell =3D (struct mfd_cell *)dev->dev.platform_data;
=2D	struct mmc_host *mmc =3D platform_get_drvdata(dev);
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct mfd_cell	*cell =3D (struct mfd_cell *)pdev->dev.platform_data;
+	struct mmc_host *mmc =3D platform_get_drvdata(pdev);
 	struct tmio_mmc_host *host =3D mmc_priv(mmc);
 	int ret =3D 0;
=20
 	/* Tell the MFD core we are ready to be enabled */
 	if (cell->enable) {
=2D		ret =3D cell->enable(dev);
+		ret =3D cell->enable(pdev);
 		if (ret)
 			goto out;
 	}
@@ -498,16 +500,18 @@ static int tmio_mmc_resume(struct platform_device *de=
v)
 	/* Enable the MMC/SD Control registers */
 	sd_config_write16(host, CNF_CMD, SDCREN);
 	sd_config_write32(host, CNF_CTL_BASE,
=2D		(dev->resource[0].start >> host->bus_shift) & 0xfffe);
+		(pdev->resource[0].start >> host->bus_shift) & 0xfffe);
=20
 	mmc_resume_host(mmc);
=20
 out:
 	return ret;
 }
=2D#else
=2D#define tmio_mmc_suspend NULL
=2D#define tmio_mmc_resume NULL
+
+static struct dev_pm_ops tmio_mmc_pm_ops =3D {
+	.suspend =3D tmio_mmc_suspend,
+	.resume =3D tmio_mmc_resume,
+};
 #endif
=20
 static int __devinit tmio_mmc_probe(struct platform_device *dev)
@@ -637,13 +641,12 @@ static int __devexit tmio_mmc_remove(struct platform_=
device *dev)
=20
 static struct platform_driver tmio_mmc_driver =3D {
 	.driver =3D {
=2D		.name =3D "tmio-mmc",
=2D		.owner =3D THIS_MODULE,
+		.name	=3D "tmio-mmc",
+		.owner	=3D THIS_MODULE,
+		.pm	=3D &tmio_mmc_pm_ops,
 	},
=2D	.probe =3D tmio_mmc_probe,
=2D	.remove =3D __devexit_p(tmio_mmc_remove),
=2D	.suspend =3D tmio_mmc_suspend,
=2D	.resume =3D tmio_mmc_resume,
+	.probe	=3D tmio_mmc_probe,
+	.remove	=3D __devexit_p(tmio_mmc_remove),
 };
=20
=20
diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 632858a..19f2d72 100644
=2D-- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1280,7 +1280,7 @@ static int via_sd_suspend(struct pci_dev *pcidev, pm_=
message_t state)
 	via_save_pcictrlreg(host);
 	via_save_sdcreg(host);
=20
=2D	ret =3D mmc_suspend_host(host->mmc, state);
+	ret =3D mmc_suspend_host(host->mmc);
=20
 	pci_save_state(pcidev);
 	pci_enable_wake(pcidev, pci_choose_state(pcidev, state), 0);
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 89bf8cd..56e9c4e 100644
=2D-- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1818,7 +1818,7 @@ static int wbsd_suspend(struct wbsd_host *host, pm_me=
ssage_t state)
 {
 	BUG_ON(host =3D=3D NULL);
=20
=2D	return mmc_suspend_host(host->mmc, state);
+	return mmc_suspend_host(host->mmc);
 }
=20
 static int wbsd_resume(struct wbsd_host *host)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 3e7615e..710ae3a 100644
=2D-- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -180,7 +180,7 @@ static inline void *mmc_priv(struct mmc_host *host)
 #define mmc_classdev(x)	(&(x)->class_dev)
 #define mmc_hostname(x)	(dev_name(&(x)->class_dev))
=20
=2Dextern int mmc_suspend_host(struct mmc_host *, pm_message_t);
+extern int mmc_suspend_host(struct mmc_host *);
 extern int mmc_resume_host(struct mmc_host *);
=20
 extern void mmc_detect_change(struct mmc_host *, unsigned long delay);
=2D-=20
1.6.3.3


--Boundary-00=_WqzjKW574GHb21w--
