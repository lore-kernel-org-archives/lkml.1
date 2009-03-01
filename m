Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbZCAHsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbZCAHsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 02:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZCAHsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 02:48:38 -0500
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:40532 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbZCAHsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 02:48:37 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-14.arcor-online.net 1234D28B2DA
From: Prakash Punnoor <prakash@punnoor.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
Date: Sun, 1 Mar 2009 08:50:52 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6; KDE/4.2.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <86802c440902281257r4b7f6ca3w546310581a3fc6b5@mail.gmail.com> <86802c440902281443g4638dbcby463864df911a50ba@mail.gmail.com>
In-Reply-To: <86802c440902281443g4638dbcby463864df911a50ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903010850.53031.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 28 Februar 2009 23:43:51 Yinghai Lu wrote:
> please check this one
> v1 is pulled by Linus from Jesse's pci tree already, and v3 is needed
> to be applied on top of v1
>
> YH

Hi,

yes, this works nicely now. Thanks. (Are you still interested in all the infos 
you requested in your last email?) But have you looked at the original patch? 
It might be that your current one is not enough to cover all models. In the 
original NVidia one following bridges were enabled:

+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC0   0x02F0
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC1   0x02F1
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC2   0x02F2
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC3   0x02F3
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC4   0x02F4
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC5   0x02F5
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC6   0x02F6
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC7   0x02F7
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_MEMC	0x0369

As you can see, the one on my board is the MEMC0. I don't know which revisions 
have the other ones. The MEMC case had a special bahaviour in the original 
patch also:

+				bridge_dev = NULL;
+				while ((bridge_dev = pci_get_device(PCI_VENDOR_ID_NVIDIA,
+					PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_MEMC, bridge_dev))
+					!= NULL) {
+					pci_enable_msi_ht_cap(bridge_dev);
+			 	}

Cheers,

Prakash
