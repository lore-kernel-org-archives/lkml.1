Return-Path: <linux-kernel-owner+w=401wt.eu-S1761742AbZAUBS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761742AbZAUBS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 20:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760568AbZAUBSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 20:18:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33084 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763298AbZAUBSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 20:18:08 -0500
Message-ID: <497677B9.9080501@jp.fujitsu.com>
Date: Wed, 21 Jan 2009 10:17:45 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/2] PCI PCIe portdrv: Fix allocation of interrupts (rev.
 6)
References: <200901131457.58164.rjw@sisk.pl> <200901210116.09211.rjw@sisk.pl> <200901210118.44162.rjw@sisk.pl> <200901210133.57537.rjw@sisk.pl>
In-Reply-To: <200901210133.57537.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Nice work, Rafael!

Thanks,
H.Seto

Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> If MSI-X interrupt mode is used by the PCI Express port driver, too
> many vectors are allocated and it is not ensured that the right
> vectors will be used for the right services.  Namely, the PCI Express
> specification states that both PCI Express native PME and PCI Express
> hotplug will always use the same MSI or MSI-X message for signalling
> interrupts, which implies that the same vector will be used by both
> of them.  Also, the VC service does not use interrupts at all.
> Moreover, is not clear which of the vectors allocated by
> pci_enable_msix() in the current code will be used for PME and
> hotplug and which of them will be used for AER if all of these
> services are configured.
> 
> For these reasons, rework the allocation of interrupts for PCI
> Express ports so that if MSI-X are enabled, the right vectors will be
> used for the right purposes.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

