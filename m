Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZBRT1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZBRT1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZBRT1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:27:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:38512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbZBRT1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:27:03 -0500
Message-ID: <499C60AC.9050008@kernel.org>
Date: Wed, 18 Feb 2009 11:25:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: enable MSI on 8132
References: <499B46B2.5040601@kernel.org>	 <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>	 <499B6BF7.9090300@kernel.org>	 <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>	 <499B724A.2040408@kernel.org>	 <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>	 <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>	 <499B774C.5010705@kernel.org>	 <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>	 <499B9129.50104@kernel.org> <20090218122137.GJ16841@parisc-linux.org>	 <alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>	 <20090218100448.7f7c5b86.akpm@linux-foundation.org>	 <1234982285.3225.42.camel@localhost.localdomain>	 <499C5CAD.1070404@kernel.org> <1234984495.3225.48.camel@localhost.localdomain>
In-Reply-To: <1234984495.3225.48.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-02-18 at 11:08 -0800, Yinghai Lu wrote:
>> James Bottomley wrote:
>>> On Wed, 2009-02-18 at 10:04 -0800, Andrew Morton wrote:
>>>
>>>> Do we not need mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch as
>>>> well, to fix this regression?
>>> No ... it's a separate issue.  MSI was enabled for fusion SAS in 2.6.26;
>>> the problem msi patch which the above corrects actually has the effect
>>> of disabling MSI for fusion and went into 2.6.29-rc2, which isn't a
>>> kernel that's been tested here.
>>>
>> so for 2.6.26, 27, 28 need pci-enable-msi-on-8132.patch
> 
> I'm a bit lost with the names, but if that's the PCI quirk fix, then yes

yes

> 
>> 2.6.29 need pci-enable-msi-on-8132.patch and mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch
> 
> Like I said, I'm happy to have MSI completely disabled until LSI wants
> to comment, so no ... only the PCI quirk fix.  The true fix is to have
> the drivers participate in dynamic testing of MSI IRQ routing, but I've
> somewhat lost sight of that.

[PATCH] mpt: fix enable lsi sas to use msi as default

Impact: fix bug

the third param in module_param(,,) is perm instead of default value.
we still need to assign default at first.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/message/fusion/mptbase.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6/drivers/message/fusion/mptbase.c
@@ -90,8 +90,8 @@ module_param(mpt_msi_enable_fc, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
 		controllers (default=0)");
 
-static int mpt_msi_enable_sas;
-module_param(mpt_msi_enable_sas, int, 1);
+static int mpt_msi_enable_sas = 1;
+module_param(mpt_msi_enable_sas, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
 		controllers (default=1)");
 
or you want

[PATCH] mpt: fix disable lsi sas to use msi as default

Impact: fix bug

the third param in module_param(,,) is perm instead of default value.
we still need to assign default at first.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/message/fusion/mptbase.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6/drivers/message/fusion/mptbase.c
@@ -91,9 +91,9 @@ MODULE_PARM_DESC(mpt_msi_enable_fc, " En
 		controllers (default=0)");
 
 static int mpt_msi_enable_sas;
-module_param(mpt_msi_enable_sas, int, 1);
+module_param(mpt_msi_enable_sas, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
-		controllers (default=1)");
+		controllers (default=0)");
 
 
 static int mpt_channel_mapping;

anyway we need to fix the typo.

YH
