Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYCIR3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYCIR3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYCIR3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:29:05 -0400
Received: from mail.dunaweb.hu ([81.17.184.3]:36851 "EHLO mail.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYCIR3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:29:04 -0400
Message-ID: <47D41E58.6030303@dunaweb.hu>
Date: Sun, 09 Mar 2008 18:28:56 +0100
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hancockr@shaw.ca,
       prakash@punnoor.de, pchen@nvidia.com, kluo@nvidia.com
Subject: Re: SWNCQ should be enabled by default
References: <47CFE29E.8080107@dunaweb.hu>
In-Reply-To: <47CFE29E.8080107@dunaweb.hu>
Content-Type: multipart/mixed;
 boundary="------------070600090408040204090102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070600090408040204090102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Ping. Now with patch.

Zoltan Boszormenyi =EDrta:
> Hi,
>
> the patch is already upstream, thanks for that.
> I am using it without any problems. Currently I am
> using kernel-2.6.24.3-12.fc8 from the updates-testing
> repository of Fedora 8. I had to add
>
> options scsi_hostadapter1 swncq=3D1
> options sata_nv swncq=3D1
>
> before upgrading to get it enabled.
> Can we enable it by default for 2.6.25?
> It's completely independent from ADMA and its problems.
> E.g. my machine has 8GB memory now, no problems at all.
>
> Best regards,
> Zolt=E1n B=F6sz=F6rm=E9nyi


--------------070600090408040204090102
Content-Type: text/x-patch;
 name="sata_nv-swncq_enabled.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="sata_nv-swncq_enabled.patch"

Enable SWNCQ by default.

Signed-off-by: Zolt=C3=A1n B=C3=B6sz=C3=B6rm=C3=A9nyi <zboszor@dunaweb.hu=
>

--- linux-2.6.25-rc4-git3/drivers/ata/sata_nv.c~	2008-03-09 18:24:44.0000=
00000 +0100
+++ linux-2.6.25-rc4-git3/drivers/ata/sata_nv.c	2008-03-09 18:24:44.00000=
0000 +0100
@@ -641,7 +641,7 @@
 MODULE_VERSION(DRV_VERSION);
=20
 static int adma_enabled =3D 1;
-static int swncq_enabled;
+static int swncq_enabled =3D 1;
=20
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -2600,5 +2600,5 @@
 module_param_named(adma, adma_enabled, bool, 0444);
 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: true)");
 module_param_named(swncq, swncq_enabled, bool, 0444);
-MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: false)");
+MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: true)");
=20

--------------070600090408040204090102--
