Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYKLV13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYKLV13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYKLV1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:27:22 -0500
Received: from xenotime.net ([72.52.64.118]:51293 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751006AbYKLV1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:27:21 -0500
Date: Wed, 12 Nov 2008 13:26:40 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, djwong@us.ibm.com
Subject: Re: mmotm 2008-11-10-14-54 uploaded (i5k_amb)
Message-Id: <20081112132640.1c7ac924.rdunlap@xenotime.net>
In-Reply-To: <200811102254.mAAMsTU5029697@imap1.linux-foundation.org>
References: <200811102254.mAAMsTU5029697@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/hwmon/i5K_amb.c contains a few duplicated lines, causing:

mmotm-2008-1112-1148/drivers/hwmon/i5k_amb.c:500: error: redefinition of 'i5k_amb_ids'
mmotm-2008-1112-1148/drivers/hwmon/i5k_amb.c:493: error: previous definition of 'i5k_amb_ids' was here



static struct pci_device_id i5k_amb_ids[] __devinitdata = {
	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR) },
	{ 0, }
};
MODULE_DEVICE_TABLE(pci, i5k_amb_ids);

static struct pci_device_id i5k_amb_ids[] __devinitdata = {
	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR) },
	{ 0, },
};

MODULE_DEVICE_TABLE(pci, i5k_amb_ids);

---
~Randy
