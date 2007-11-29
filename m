Return-Path: <linux-kernel-owner+w=401wt.eu-S934532AbXK2W53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532AbXK2W53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934229AbXK2W4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:56:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:15047 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934463AbXK2W4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:56:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bQS5h4GxYLya8DPdfQGEP65El4njPfhOag+yHYc1nk2LUMtxX+iva65B11IzPgTzluhMBqDxRfEAEnncjUhgqiaHk5J7Kccfnh5lDh9Tyl5adjV9bde6NGspeDTijXIv3GHXVxpjOtQRUsCXC5lV3s8pZbbbHMSHt2viKq7qHdk=
Message-ID: <474F438D.7080109@gmail.com>
Date: Thu, 29 Nov 2007 23:56:13 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: named + capset = EPERM [Was: 2.6.24-rc3-mm2]
References: <474DF493.3010903@gmail.com> <830198.27330.qm@web36612.mail.mud.yahoo.com> <20071128234743.GA26217@sergelap.austin.ibm.com> <20071129000408.GA26502@sergelap.austin.ibm.com> <20071129001701.GA26817@sergelap.austin.ibm.com>
In-Reply-To: <20071129001701.GA26817@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2007 01:17 AM, Serge E. Hallyn wrote:
> From 70d5da610fdbd66a36886c01e27b7fb11d2de044 Mon Sep 17 00:00:00 2001
> From: sergeh@us.ibm.com <hallyn@kernel.(none)>
> Date: Wed, 28 Nov 2007 16:16:23 -0800
> Subject: [PATCH 1/1] capabilities: correct logic at capset_check
> 
> Fix typo at capset_check introduced with capability bounding set
> patch.
> 
> Signed-off-by: sergeh@us.ibm.com <hallyn@kernel.(none)>

Tested-by: Jiri Slaby <jirislaby@gmail.com>

> ---
>  security/commoncap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index c25ad09..503e958 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -119,7 +119,7 @@ int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
>  		/* incapable of using this inheritable set */
>  		return -EPERM;
>  	}
> -	if (!!cap_issubset(*inheritable,
> +	if (!cap_issubset(*inheritable,
>  			   cap_combine(target->cap_inheritable,
>  				       current->cap_bset))) {
>  		/* no new pI capabilities outside bounding set */

Thanks.
