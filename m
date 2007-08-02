Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbXHBGlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbXHBGlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 02:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXHBGlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 02:41:07 -0400
Received: from mtoichi16.ns.itscom.net ([219.110.2.186]:52412 "EHLO
	mtoichi16.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbXHBGlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 02:41:05 -0400
Date: Thu, 2 Aug 2007 15:40:34 +0900
From: Mattia Dongili <malattia@linux.it>
To: Eugene Teo <eugeneteo@kernel.sg>, Len Brown <lenb@kernel.org>,
       Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/sonypi.c: fix ids member of struct
	acpi_driver
Message-ID: <20070802064034.GF25969@inferi.kami.home>
References: <20070801091534.GA6845@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801091534.GA6845@kernel.sg>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.23-rc1-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 05:15:34PM +0800, Eugene Teo wrote:
> ids member of struct acpi_driver is of type struct acpi_device_id, not a
> character array.
> 
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> ---
>  drivers/char/sonypi.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
> index 73037a4..ac0aeb0 100644
> --- a/drivers/char/sonypi.c
> +++ b/drivers/char/sonypi.c
> @@ -1147,10 +1147,16 @@ static int sonypi_acpi_remove(struct acpi_device *device, int type)
>  	return 0;
>  }
>  
> +const static struct acpi_device_id sonypi_device_ids[] = {
> +	{"SNY6001", 0},
> +	{"", 0},
> +};
> +MODULE_DEVICE_TABLE(acpi, sonypi_device_ids);

how does it behave with the already existing id in sony-laptop?
I'd rather avoid the MODULE_DEVICE_TABLE for sonypi allowing sony-laptop
to take over automagically.

-- 
mattia
:wq!
