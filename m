Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYIKDxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYIKDxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 23:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYIKDxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 23:53:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:2084 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbYIKDxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 23:53:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,376,1217833200"; 
   d="scan'208";a="615073803"
Subject: Re: [PATCH 1/2] fix acpi ec read write bug
From: Zhao Yakui <yakui.zhao@intel.com>
To: Kevin Hao <kexin.hao@windriver.com>
Cc: ak@linux.intel.com, astarikovskiy@suse.de, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <d41e1c0a5be061176c65db7ef42263f75ae84dcb.1221102420.git.kexin.hao@windriver.com>
References: <1221103065-9123-1-git-send-email-kexin.hao@windriver.com>
	 <d41e1c0a5be061176c65db7ef42263f75ae84dcb.1221102420.git.kexin.hao@windriver.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 12:07:37 +0800
Message-Id: <1221106057.3989.228.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 11:17 +0800, Kevin Hao wrote:
> Fill in command unit of transaction_data structure, otherwise
> gpe_transaction will skip read or write instruction.
> 
> Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
> ---
>  drivers/acpi/ec.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index bd3555c..0c65e82 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -240,6 +240,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
>  	}
>  	atomic_set(&ec->irq_count, 0);
>  	/* fill in transaction structure */
> +	ec->t.command = command;
It is also OK to add this explicitly. In fact the ec->t.command will be
assigned in the function of acpi_ec_write_cmd.

Thanks.
>  	ec->t.wdata = wdata;
>  	ec->t.wlen = wdata_len;
>  	ec->t.rdata = rdata;

