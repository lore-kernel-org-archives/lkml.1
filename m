Return-Path: <linux-kernel-owner+w=401wt.eu-S1751516AbZGWE5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbZGWE5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 00:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZGWE5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 00:57:54 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:31949 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZGWE5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 00:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DDt06fCGoWmnc04qOYMWuAnbgG0uK+nEVGWUSADPeSr+cOGwO/+0pdGS3nAgxGMwVS
         Q20LYt/b9fAzeSMinqpkbUM57Jqba5BGrT+DjI4nV1t4VA7ZkB9/OJsqGzKgyu45Wx4T
         oNBBrkQZ++7X3RO+1Y1TGD1vEn51hneLvQAc0=
MIME-Version: 1.0
In-Reply-To: <1246642011-21749-1-git-send-email-nicolas.ferre@atmel.com>
References: <1246642011-21749-1-git-send-email-nicolas.ferre@atmel.com>
Date: Wed, 22 Jul 2009 21:57:52 -0700
X-Google-Sender-Auth: 67b3f95209745cc2
Message-ID: <e9c3a7c20907222157p6dfbbb4ewdbe1e2c05c09d841@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: dmatest: add a maximum number of test 
	iterations
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: maciej.sosnowski@intel.com, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, haavard.skinnemoen@atmel.com,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 10:26 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
> The dmatest usually waits for the killing of its kthreads to stop
> running tests.  This patch adds a parameter that sets a maximum
> number of test iterations.
>
> This feature is quite interesting for debugging when you set a lot of
> traces in your dmaengine controller driver.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/dma/dmatest.c |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index fb7da51..0131a1f 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -38,6 +38,11 @@ module_param(max_channels, uint, S_IRUGO);
>  MODULE_PARM_DESC(max_channels,
>                "Maximum number of channels to use (default: all)");
>
> +static unsigned int iteration_nbr = 0;
> +module_param(iteration_nbr, uint, S_IRUGO);
> +MODULE_PARM_DESC(iteration_nbr,
> +               "Iteration number before stopping test (default: infinite)");
> +

This is a minor nit, but for a user facing interface I don't think we
should export abbreviated variable names.  I'll apply this with the
following fixups:

s/iteration_nbr/iterations/
s/Iteration number/Iterations/

...as well as a fix for the checkpatch violation of initializing a static to 0.

Thanks,
Dan
