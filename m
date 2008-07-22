Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbYGVRMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbYGVRMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYGVRMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:12:24 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:24800 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYGVRMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:12:23 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2008 17:11:16 +0000
Subject: RE: [PATCH 75/79] HP iLO driver
Thread-Topic: [PATCH 75/79] HP iLO driver
Thread-Index: Acjru5LBITsFkRVhRLm55+jiiU025AAYJpgg
Message-ID: <CF70AA892F109448AEA269483B3A983903C30E04F2@G1W1215.americas.hpqcorp.net>
References: <20080722051805.GA17373@suse.de>
 <1216703983-21448-75-git-send-email-gregkh@suse.de>
In-Reply-To: <1216703983-21448-75-git-send-email-gregkh@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 1921b8d..ce67d97 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -420,4 +420,17 @@ config SGI_XP
>           this feature will allow for direct communication between SSIs
>           based on a network adapter and DMA messaging.
>
> +config HP_ILO
> +       tristate "Channel interface driver for HP iLO/iLO2 processor"
> +       default n

Heiko Carstens submitted a Kconfig "depend on PCI" patch to linux-next,
and that should be included with this series.  His mail is below.
Outlook might well mangle the diff, but that's my fault, not his.

----

Subject: [PATCH] Let HP iLO driver depend on PCI

From: Heiko Carstens <heiko.carstens@de.ibm.com>

"HP iLO driver" causes this:

drivers/misc/hpilo.c: In function 'doorbell_set':
drivers/misc/hpilo.c:147: error: implicit declaration of function 'iowrite8'
drivers/misc/hpilo.c: In function 'ilo_ccb_close':
drivers/misc/hpilo.c:204: error: implicit declaration of function 'iowrite32'
drivers/misc/hpilo.c:204: error: implicit declaration of function 'ioread32'
drivers/misc/hpilo.c:222: error: implicit declaration of function 'memset_io'
drivers/misc/hpilo.c:225: error: implicit declaration of function 'pci_free_consistent'
drivers/misc/hpilo.c: In function 'ilo_ccb_open':
drivers/misc/hpilo.c:244: error: implicit declaration of function 'pci_alloc_consistent'
drivers/misc/hpilo.c:245: warning: assignment makes pointer from integer without a cast
drivers/misc/hpilo.c:296: error: implicit declaration of function 'memcpy_toio'
drivers/misc/hpilo.c: In function 'ilo_unmap_device':
drivers/misc/hpilo.c:575: error: implicit declaration of function 'pci_iounmap'
drivers/misc/hpilo.c: In function 'ilo_map_device':
drivers/misc/hpilo.c:585: error: implicit declaration of function 'pci_iomap'
drivers/misc/hpilo.c:585: warning: assignment makes pointer from integer without a cast
drivers/misc/hpilo.c:592: warning: assignment makes pointer from integer without a cast
drivers/misc/hpilo.c:599: warning: assignment makes pointer from integer without a cast
make[2]: *** [drivers/misc/hpilo.o] Error 1

Just let it depend on PCI.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Greg, this came in via one of your git trees. Please merge/apply. Thanks.

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next/drivers/misc/Kconfig
===================================================================
--- linux-next.orig/drivers/misc/Kconfig
+++ linux-next/drivers/misc/Kconfig
@@ -423,6 +423,7 @@ config SGI_XP
 config HP_ILO
        tristate "Channel interface driver for HP iLO/iLO2 processor"
        default n
+       depends on PCI
        help
          The channel interface driver allows applications to communicate
          with iLO/iLO2 management processors present on HP ProLiant
