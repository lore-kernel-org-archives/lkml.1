Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbZLDTR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbZLDTR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 14:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbZLDTR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 14:17:56 -0500
Received: from sous-sol.org ([216.99.217.87]:53270 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755817AbZLDTRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 14:17:55 -0500
Date: Fri, 4 Dec 2009 11:17:54 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: jbarnes@virtuousgeek.org, Allen Kay <allen.m.kay@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, matthew@wil.cx,
       chris@sous-sol.org, jeremy@goop.org, don.dugger@intel.com
Subject: Re: [ACS PATCH v5 1/2] acs p2p upsteram forwarding enabling
Message-ID: <20091204191754.GI21174@sequoia.sous-sol.org>
References: <1254936437-18577-1-git-send-email-allen.m.kay@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254936437-18577-1-git-send-email-allen.m.kay@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Allen Kay (allen.m.kay@intel.com) wrote:
> Changes from v4 to v5:
> 	- separate out dom0 checking out of v4
> 	- use iommu_found() for detecting HW iommu presence

Erk, turns out iommu_found() doesn't work (becuase the iommu has been
detected, but not initialized yet when this code runs).

This could be fixed in a few ways:

1) Have an isolation capable iommu actively ask for ACS to be enabled
2) Have pci core switch to iommu_detected (as Allen had done earlier).
This would need some work to make iommu_detected actually defined on
all arches that make use of pci.  iommu_detected could be more
descriptive than a single boolean, turned into an enum that says what
kind of hw iommu was detected.
3) Just always enable ACS and pay the price.

I'll send a patch for option 1) momentarily.

Thoughts?

thanks,
-chris
