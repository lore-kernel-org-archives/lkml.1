Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZEVChW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZEVChW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 22:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZEVChK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 22:37:10 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:46523 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751847AbZEVChJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 22:37:09 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: bderE4YVM1lyAWAzhgR_gyxqBJVChlKqvoZX_o29Cc48GMNn6MJpj77q.6sa7aw9sXivr_kGy7dvAzUKSIjiBfRVJr86vlSOIdzUp3Vq8LSqYt9A_cvcM6My9aLOL_7MXNUr3eIrBXtFv_hzXvEjaTWZ.acXuTRiAGJ_.GGqK0cxJLwyxdjbAJScZJpGciP._d4MuW_ymAcs.Dtys7ldHQBtNJPZCxtSegIWWLJHlmOqc_RJT_PPZLN5dUUvsFlDvqnDokgJYrpkwdb2BdUVoXSN7izjkemwbXoPeNK_Yhjgtnc1U1Y-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A160E28.1010306@schaufler-ca.com>
Date: Thu, 21 May 2009 19:30:00 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: jmorris@namei.org, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] smack:beyond ARRAY_SIZE of data
References: <4A141F83.10102@gmail.com> <4A1483E0.1030303@schaufler-ca.com> <4A15848E.5030403@gmail.com>
In-Reply-To: <4A15848E.5030403@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Do not go beyond ARRAY_SIZE of data
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>   

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Thank you. The fix is appreciated.


> ---
>   
>>> -	if (count < SMK_NETLBLADDRMIN || count > SMK_NETLBLADDRMAX)
>>> +	if (count < SMK_NETLBLADDRMIN || count >= SMK_NETLBLADDRMAX)
>>>   
>>>       
>> There is a problem here, but this won't fix it. The buffer needs to be
>> allocated bigger than the potential contents (should be
>> SMK_NETLBLADDRMAX + 1 instead of SMK_NETLBLADDRMAX. Your patch will clip
>> the last byte off of a maximum length specification.
>>     
>
> Ok, how about this?
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index e03a7e1..10a4604 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -775,7 +775,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
>  	struct sockaddr_in newname;
>  	char smack[SMK_LABELLEN];
>  	char *sp;
> -	char data[SMK_NETLBLADDRMAX];
> +	char data[SMK_NETLBLADDRMAX + 1];
>  	char *host = (char *)&newname.sin_addr.s_addr;
>  	int rc;
>  	struct netlbl_audit audit_info;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   
