Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZIJAKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZIJAKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 20:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZIJAKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 20:10:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49232 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbZIJAKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 20:10:04 -0400
Date: Thu, 10 Sep 2009 01:10:09 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jerome Glisse <jglisse@redhat.com>
cc: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [PATCH] drm/radeon/kms: Don't try to process irq when we are
 unloading
In-Reply-To: <1252527787-2203-1-git-send-email-jglisse@redhat.com>
Message-ID: <alpine.DEB.2.00.0909100109190.29694@skynet.skynet.ie>
References: <1252527787-2203-1-git-send-email-jglisse@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Jerome Glisse wrote:

> If module is being unloaded we should not try to handle irq especialy
> we should not call into drm helper or we could hard hang the computer
> free_irq will call the irq handler to make sure we behave properly.

Should you not just ack all irqs here before returning, else we'll
just get called again.

Dave.

> 
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/radeon/r100.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
> index 5708c07..36d0ba2 100644
> --- a/drivers/gpu/drm/radeon/r100.c
> +++ b/drivers/gpu/drm/radeon/r100.c
> @@ -319,6 +319,9 @@ int r100_irq_process(struct radeon_device *rdev)
>  	if (!status) {
>  		return IRQ_NONE;
>  	}
> +	if (rdev->shutdown) {
> +		return IRQ_NONE;
> +	}
>  	while (status) {
>  		/* SW interrupt */
>  		if (status & RADEON_SW_INT_TEST) {
> 
