Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYI1HXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYI1HXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 03:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYI1HXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 03:23:43 -0400
Received: from mga10.intel.com ([192.55.52.92]:3409 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751131AbYI1HXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 03:23:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,324,1220252400"; 
   d="scan'208";a="621164291"
Subject: Re: [PATCH] PCIE: use PCI_EXT_CAP_NEXT to traverse PCIE extended
	capability list.
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: qingtao.cao@windriver.com
Cc: linux-kernel@vger.kernel.org, yanmin.zhang@intel.com
In-Reply-To: <1222578476-25691-1-git-send-email-qingtao.cao@windriver.com>
References: <1222578476-25691-1-git-send-email-qingtao.cao@windriver.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 28 Sep 2008 15:20:16 +0800
Message-Id: <1222586416.25574.36.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-09-28 at 13:07 +0800, qingtao.cao@windriver.com wrote:
> PCIE extended capability unit is of 4-byte, so the least 2 bits of the most 
> significant 12 bits should be masked off to zero when accessing the extended
> capability list.
> 
> Signed-off-by: Harry Ciao<qingtao.cao@windriver.com>
﻿Acked-by: ﻿Zhang Yanmin <yanmin_zhang@linux.intel.com>

> ---
>  drivers/pci/pcie/aer/aerdrv_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -52,7 +52,7 @@
>  		if (PCI_EXT_CAP_ID(reg32) == PCI_EXT_CAP_ID_ERR)
>  			break;
>  
> -		pos = reg32 >> 20;
> +		pos = PCI_EXT_CAP_NEXT(reg32);
>  	}
>  
>  	return pos;


