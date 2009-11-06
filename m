Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZKFCsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZKFCsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 21:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZKFCsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 21:48:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59737 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZKFCsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 21:48:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF38E6B.3000604@jp.fujitsu.com>
Date: Fri, 06 Nov 2009 11:48:11 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, rdh@east.sun.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
References: <19184.41676.262206.134000@gargle.gargle.HOWL> <20091104110321.5e58e112@jbarnes-piketon> <200911041628.17905.bjorn.helgaas@hp.com> <4AF240E7.8050200@jp.fujitsu.com> <20091105191138.GN10555@parisc-linux.org>
In-Reply-To: <20091105191138.GN10555@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Nov 05, 2009 at 12:05:11PM +0900, Kenji Kaneshige wrote:
>> There are a lot of codes that searches PCI express capability offset
>> in the PCI configuration space using pci_find_capability(). Caching it
>> in the struct pci_dev will reduce unncecessary search. This patch adds
>> an additional 'pcie_cap' fields into struct pci_dev, which is
>> initialized at pci device scan time (in set_pcie_port_type()).
> 
> I think adding this should imply the removal of ->is_pcie.  pcie_cap == 0
> means !is_pcie.

Right.

But, as you know, we need to change users of is_pcie (including some
adapter card drivers) before removing it.

Thanks,
Kenji Kaneshige


