Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZETW2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZETW2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbZETW2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:28:04 -0400
Received: from smtp103.prem.mail.sp1.yahoo.com ([98.136.44.58]:43777 "HELO
	smtp103.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756433AbZETW2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:28:01 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: ipizfTkVM1kDkmocb_SAvLHkinMS1B6PXy2v2UJ.gh4A8sFYG5WCYYBk3w8aAZtlhhEIyt0a7qCAq0pdBi_RxehpAHLuY2sVYl1U6PQtguutcyga4j2u0BCOGaBbLDbsqiXFm2jr3K2abVDepMDCdSvLwrIFOIQCImC5EWLSJuQDYOMgNiYfeCTaoUI1xW5d9GWL8.arswfavELtt6rcX.HG1nCCRG8JPaA2klRj4zQVHEyh1cs1WVYKUNZV8m9GYXmRvnuX_Q78Qlzg4LSZx_vFKbi364FznZh1ydY8FNMwLojVTg8nvxIWKGl1v6u.c_BBr5pwoTMtAAQVjCw-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A1483E0.1030303@schaufler-ca.com>
Date: Wed, 20 May 2009 15:27:44 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: jmorris@namei.org, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] smack:beyond ARRAY_SIZE of data
References: <4A141F83.10102@gmail.com>
In-Reply-To: <4A141F83.10102@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Do not go beyond ARRAY_SIZE of data
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index e03a7e1..7407e5c 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -797,7 +797,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
>  		return -EPERM;
>  	if (*ppos != 0)
>  		return -EINVAL;
> -	if (count < SMK_NETLBLADDRMIN || count > SMK_NETLBLADDRMAX)
> +	if (count < SMK_NETLBLADDRMIN || count >= SMK_NETLBLADDRMAX)
>   

There is a problem here, but this won't fix it. The buffer needs to be
allocated bigger than the potential contents (should be
SMK_NETLBLADDRMAX + 1 instead of SMK_NETLBLADDRMAX. Your patch will clip
the last byte off of a maximum length specification.



>  		return -EINVAL;
>  	if (copy_from_user(data, buf, count) != 0)
>  		return -EFAULT;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   
