Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbZIGO7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbZIGO7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZIGO7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:59:44 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:48899 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZIGO7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:59:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MoLkUwAQyVqVhqMtSGF3Hq6/rdsikjXHu60pUdYkxSKYnsi5IiqXPlI5gE97+438M4
         7mYy2gHSsvnt5Iyle4FTM1Mvz7lIBSROyFw2DyiGnsRNIP7BNNE2H1GRXuDsrjy4SroK
         cw22g6gcJWZEs8A+5z/Zoqup+TuKdrnp9gps4=
Date: Mon, 7 Sep 2009 18:59:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Youquan Song <youquan.song@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>, youqun.song@intel.com
Subject: Re: Fix interrupt remapping hang if interrupt remapping disable in
	BIOS
Message-ID: <20090907145940.GD5294@lenovo>
References: <20090907141313.GA26091@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907141313.GA26091@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Youquan Song - Mon, Sep 07, 2009 at 10:13:13AM -0400]
...  
|  static int disable_intremap;
|  static __init int setup_nointremap(char *str)
| @@ -607,9 +608,14 @@ end:
|  int __init intr_remapping_supported(void)
|  {
|  	struct dmar_drhd_unit *drhd;
| -
| +	struct acpi_table_dmar *dmar;
| +
|  	if (disable_intremap)
|  		return 0;
| +
| +	dmar = (struct acpi_table_dmar *)dmar_tbl;
| +	if (!(dmar->flags & 0x1))
| +		return 0;
|  
|  	for_each_drhd_unit(drhd) {
|  		struct intel_iommu *iommu = drhd->iommu;

Hi Youquan,

perhaps we could move this test to helper function
in dmar.c instead of plain external variable test?

	-- Cyrill
