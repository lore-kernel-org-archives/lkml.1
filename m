Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbYCRD6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbYCRD6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 23:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYCRD63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 23:58:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:42665 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYCRD62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 23:58:28 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Thomas Meyer <thomas@m3y3r.de>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: In function `ata_acpi_associate': undefined reference =?utf-8?q?to=09=60register=5Fhotplug=5Fdock=5Fdevice=27?=
Date: Mon, 17 Mar 2008 23:57:53 -0400
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       htejun@gmail.com, jeff@garzik.org
References: <47DEC970.2050402@m3y3r.de> <20080317194809.GB9550@cs181133002.pp.htv.fi> <47DECD54.5060202@m3y3r.de>
In-Reply-To: <47DECD54.5060202@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803172357.54253.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/built-in.o: In function `ata_acpi_associate':
> (.text+0x7106a): undefined reference to `register_hotplug_dock_device'

CONFIG_ACPI_DOCK=m
CONFIG_ATA_ACPI=y

don't work together.

particularly this:

drivers/ata/libata-acpi.c
...
#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
                        /* we might be on a docking station */
                        register_hotplug_dock_device(ap->acpi_handle,
                                                     ata_acpi_ap_notify, ap);
#endif

does not link with an EXPORT_SYMBOL_GPL in dock.c when that is a module.

you can change them both to be =y (or either to be =n) to work around it.
however, this is a 2.6.25 regression, since 2.6.24 could make ATA=y
and make dock=m

-Len
