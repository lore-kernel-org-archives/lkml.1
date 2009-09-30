Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbZI3U1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbZI3U1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZI3U1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:27:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53295 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZI3U1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:27:08 -0400
Subject: Re: [PATCH] TPM: fix pcrread
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       Jan Beulich <JBeulich@novell.com>
In-Reply-To: <1254324415.13475.24.camel@blackbox>
References: <1254324415.13475.24.camel@blackbox>
Content-Type: text/plain
Date: Wed, 30 Sep 2009 16:27:09 -0400
Message-Id: <1254342429.3544.20.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 12:26 -0300, Rajiv Andrade wrote:
> The previously sent patch:
> 
> http://marc.info/?l=tpmdd-devel&m=125208945007834&w=2
> 
> Had its first hunk cropped when merged, submitting only this first hunk
> again.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Debora Velarde <debora@linux.vnet.ibm.com>
> Cc: Marcel Selhorst <m.selhorst@sirrix.com>
> Cc: James Morris <jmorris@namei.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 45d5800..47c2d27 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -696,8 +696,7 @@ int __tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
> 
>  	cmd.header.in = pcrread_header;
>  	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
> -	BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
> -	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
> +	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
>  			  "attempting to read a pcr value");
> 
>  	if (rc == 0)

Compiled and tested patch.

Acked-by: Mimi Zohar <zohar@us.ibm.com>

