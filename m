Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbZJZOIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbZJZOIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 10:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZJZOIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 10:08:46 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:58258 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZJZOIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 10:08:46 -0400
Message-ID: <4AE5ACE3.30103@linux.vnet.ibm.com>
Date: Mon, 26 Oct 2009 12:06:27 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090614)
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] tpm add default function definitions
References: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
In-Reply-To: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Mimi Zohar wrote:
> Add default tpm_pcr_read/extend function definitions required
> by IMA/Kconfig changes.
>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Cc: Stable Kernel <stable@kernel.org>
> ---
>  include/linux/tpm.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index 3338b3f..8eaa8f8 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -31,5 +31,12 @@
>
>  extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
>  extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
> +#else
> +static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
> +	return -ENODEV;
> +}
> +static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
> +	return -ENODEV;
> +}
>  #endif
>  #endif
>   

