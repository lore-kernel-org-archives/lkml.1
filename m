Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYJCPue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYJCPue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYJCPu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:50:26 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:29293 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYJCPuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:50:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH 0/2]Add Variable Page Size and IA64 Support in Intel IOMMU
Date: Fri, 3 Oct 2008 09:50:18 -0600
User-Agent: KMail/1.9.9
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
References: <20081001165606.GA21279@linux-os.sc.intel.com>
In-Reply-To: <20081001165606.GA21279@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810030950.19359.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008 10:56:06 am Fenghua Yu wrote:
> The following two patches (Intel IOMMU generic patch and ia64 specific patch) together enable Intel IOMMU on IA64 platform. They are applied cleanly on the latest linux-next tree which contains Intel IOMMU interrupt remapping and VT-d driver KVM support code.

General comment (not ia64-related): it looks like you detect the
IOMMU using the static DMAR table.  Does the IOMMU also appear in
PCI config space or the ACPI namespace?  I expect it would, because
the fact that the DMAR table is static precludes any sort of hot-plug
to add or remove IOMMUs.

If it *is* in config space or the namespace, it would be good to
exercise that discovery path to help shake out firmware bugs.  For
example, arch/ia64/hp/common/sba_iommu.c uses acpi_bus_register_driver()
to discover HP IOMMUs.  I wouldn't hold the sba_iommu.c discovery code
(most of which I take the blame for) up as a shining example of how to
do things, but it shows the point.

Bjorn
