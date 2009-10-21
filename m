Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZJUWpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZJUWpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 18:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZJUWpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 18:45:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:44227 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869AbZJUWpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 18:45:30 -0400
Date: Wed, 21 Oct 2009 15:45:20 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix null pointer error after vmbus loading
Message-ID: <20091021224520.GA8569@suse.de>
References: <1FB5E1D5CA062146B38059374562DF72180B39CA@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF72180B39CA@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 07:24:23PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Fix null pointer error after vmbus loading.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> ---
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index 582318f..11431cc 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -538,9 +538,10 @@ static int vmbus_child_device_register(struct hv_device *root_device_obj,
>                    child_device_ctx);
> 
>         /* Make sure we are not registered already */
> -       if (strlen(dev_name(&child_device_ctx->device)) != 0) {
> +       if (dev_name(&child_device_ctx->device) != NULL &&
> +           strlen(dev_name(&child_device_ctx->device)) != 0) {

Also, this patch was sent in html format, and all of the tabs were
converted to spaces, making it impossible to apply.

Please read the file, Documentation/email-clients.txt and follow the
suggestions there in order to be able to send patches that will both
appear on the linux-kernel mailing list, and be able to be applied
properly.

thanks,

greg k-h
