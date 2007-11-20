Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbXKTGXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbXKTGXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXKTGXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:23:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbXKTGXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:23:35 -0500
Date: Mon, 19 Nov 2007 22:23:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcel Selhorst <tpm@selhorst.net>
Cc: TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, Kylene Jo Hall <kjhall@us.ibm.com>
Subject: Re: [PATCH] TPM TIS device driver locality request
Message-Id: <20071119222308.05d32ba7.akpm@linux-foundation.org>
In-Reply-To: <4740CBA3.4090708@selhorst.net>
References: <4740CBA3.4090708@selhorst.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 00:32:51 +0100 Marcel Selhorst <tpm@selhorst.net> wrote:

> Dear all,
> 
> during the initialization of the TPM TIS driver, the necessary
> locality has to be requested earlier in the init-process. Depending on
> the used TPM chip, this leads to wrong information.
> For example: Lenovo X61s with Atmel TPM:
> 
> tpm_tis 00:0a: 1.2 TPM (device-id 0xFFFF, rev-id 255)
> 
> But correct is:
> 
> tpm_tis 00:0c: 1.2 TPM (device-id 0x3203, rev-id 9)
> 
> This short patch fixes this issue.

Is this bug sufficiently serious to warrant inclusion of the fix in
2.6.24?  2.6.23.x?

It looks like it's just a cosmetic thing, but I'd like to check...

> Signed-Off-by Marcel Selhorst <tpm@selhorst.net>

Signed-off-by:, please.

> ---
> --- tpm_tis.c.orig      2007-11-19 00:21:09.000000000 +0100
> +++ tpm_tis.c   2007-11-19 00:21:23.000000000 +0100

`patch -p1' form, please.  This should have been

--- a/drivers/char/tpm/tpm_tis.c
+++ a/drivers/char/tpm/tpm_tis.c

> @@ -450,6 +450,11 @@ static int tpm_tis_init(struct device *d
>                 goto out_err;
>         }
> 
> +       if (request_locality(chip, 0) != 0) {
> +               rc = -ENODEV;
> +               goto out_err;
> +       }
> +

Your email client is converting tabs to spaces.

http://mbligh.org/linuxdocs/Email/Clients/Thunderbird has help for this.

Thanks.
