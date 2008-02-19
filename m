Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYBSGFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYBSGFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 01:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYBSGFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 01:05:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:33440 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYBSGFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 01:05:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,375,1199692800"; 
   d="scan'208";a="380736855"
Subject: Re: PCIE ASPM support hangs my laptop pretty often
From: Shaohua Li <shaohua.li@intel.com>
To: =?UTF-8?Q?=D0=94=D0=B0=D0=BC=D1=98=D0=B0=D0=BD_?=
	 =?UTF-8?Q?=D0=93=D0=B5=D0=BE=D1=80=D0=B3=D0=B8=D0=B5=D0=B2=D1=81=D0=BA?=
	 =?UTF-8?Q?=D0=B8?= <penguinista@mail.net.mk>
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>
In-Reply-To: <200802051840.05237.penguinista@mail.net.mk>
References: <200802051840.05237.penguinista@mail.net.mk>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Feb 2008 13:55:58 +0800
Message-Id: <1203400558.12681.18.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-06 at 01:40 +0800, Дамјан Георгиевски wrote:
> I've patched my kernel with the PCIe ASPM and after setting
> echo powersave > /sys/module/pcie_aspm/parameters/policy
> 
> I started to experience random hangs of my laptop.
> Hardware info:
> Thinkpad x60s 1704-5UG
> also tested on a firends X60s 1702-F6U
> 
> Kernel is 2.6.24 + these patches:
>  tuxonice 3.0-rc5
>  thinkpad_acpi v0.19-20080107
>  tp_smapi 0.36
Hi,
Sorry for the long delay, I'm just back from vocation. Some devices or
chipsets don't work well with ASPM. This is one of the reason why the
default policy of the patch is per BIOS setting. Ideally drivers should
disable ASPM for specific devices, the patch provides an API
(pci_disable_link_state) for this too. As Auke suggested, you can use
the per-device interface to control separate links to see which device
is broken. If you found one, please report to driver maintainer and me,
we can disable ASPM in the driver.

Thanks,
Shaohua

