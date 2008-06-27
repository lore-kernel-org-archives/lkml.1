Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbYF0Wiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbYF0Wiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 18:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbYF0Win
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:38:43 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:40329 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYF0Win (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:38:43 -0400
Date: Fri, 27 Jun 2008 18:29:31 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "Duran, Leo" <leo.duran@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>, Adrian Bunk <bunk@kernel.org>,
       "Richter, Robert" <rrichter@elbe.amd.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       "Biemueller, Sebastian" <Sebastian.Biemueller@amd.com>,
       tglx@linutronix.de, mingo@redhat.com,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080627222931.GB7201@il.ibm.com>
References: <20080627170546.GE10197@8bytes.org> <6453C3CB8E2B3646B0D020C1126132730120C444@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453C3CB8E2B3646B0D020C1126132730120C444@sausexmb4.amd.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 03:39:31PM -0500, Duran, Leo wrote:

> 2) IOMMU will not translate if the exclusion range has been enabled, and
> the DMA address falls inside that range.
> The exclusion range can be enabled for specific devices, or for all
> devices... Enabling the exclusion range can be considered a 'performance
> optimization' (no table-walks), with the caveat of not being able to
> provide protection for devices sharing the exclusion range (BTW, there's
> a single exclusion address range per IOMMU).

So, if I understand this correctly, could we implement Joerg's
"almost-direct-map" by having 0-64MB translated for host-owned
devices, and then 64MB-end excluded (again, for host-owned devices
only)? If yes, it should provide a small boost in performance (may or
may not be measurable) over having 64MB-end be an identity
translation.

Cheers,
Muli
