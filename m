Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZJUWp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZJUWp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 18:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbZJUWp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 18:45:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:44224 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbZJUWp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 18:45:26 -0400
Date: Wed, 21 Oct 2009 15:43:37 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix null pointer error after vmbus loading
Message-ID: <20091021224337.GA8550@suse.de>
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

Why would the device name ever be NULL?  Why would you need to check it
here?

confused,

greg k-h
