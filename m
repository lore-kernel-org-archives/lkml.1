Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZIIDHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZIIDHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZIIDHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:07:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:43073 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbZIIDHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:07:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,356,1249282800"; 
   d="scan'208";a="446875126"
Date: Wed, 9 Sep 2009 06:46:06 -0400
From: "Youquan,Song" <youquan.song@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Youquan Song <youquan.song@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>, youqun.song@intel.com
Subject: Re: Fix interrupt remapping hang if interrupt remapping disable in BIOS
Message-ID: <20090909104606.GA10454@youquan-linux.bj.intel.com>
References: <20090907141313.GA26091@youquan-linux.bj.intel.com> <20090907145940.GD5294@lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907145940.GD5294@lenovo>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 06:59:40PM +0400, Cyrill Gorcunov wrote:
> [Youquan Song - Mon, Sep 07, 2009 at 10:13:13AM -0400]
> ...  
> |  static int disable_intremap;
> |  static __init int setup_nointremap(char *str)
> | @@ -607,9 +608,14 @@ end:
> |  int __init intr_remapping_supported(void)
> |  {
> |  	struct dmar_drhd_unit *drhd;
> | -
> | +	struct acpi_table_dmar *dmar;
> | +
> |  	if (disable_intremap)
> |  		return 0;
> | +
> | +	dmar = (struct acpi_table_dmar *)dmar_tbl;
> | +	if (!(dmar->flags & 0x1))
> | +		return 0;
> |  
> |  	for_each_drhd_unit(drhd) {
> |  		struct intel_iommu *iommu = drhd->iommu;
> 
> Hi Youquan,
> 
> perhaps we could move this test to helper function
> in dmar.c instead of plain external variable test?

Good point. I will update it and send it out soon.

- Youquan


