Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800Ab0A0Jnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0A0Jnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260Ab0A0Jnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:43:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:23326 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab0A0Jnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:43:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RZTp2hqsIIx3UFmMkrnSTpj4NJp9J6wX8sQB/iPe0dROClei15qzxsHm3yaK6Voewx
         NbMCDGwhSZHu1qpd8apkZM9bjUFZeGKvhtMFLBrIJ5UKD+6ifDjCUp4vlRJZI2goSx1C
         et7uLYn3J+uohAX4RHKqnlIMP4KoRDMubQzng=
Message-ID: <4B600AB7.3070705@gmail.com>
Date: Wed, 27 Jan 2010 10:43:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org, joe@perches.com,
       bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com,
       shemminger@vyatta.com
Subject: Re: + drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
 added to -mm tree
References: <201001270037.o0R0bqQC032566@imap1.linux-foundation.org>
In-Reply-To: <201001270037.o0R0bqQC032566@imap1.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 01:37 AM, akpm@linux-foundation.org wrote:
> @@ -3145,7 +3136,9 @@ static inline int raw_cmd_copyout(int cm
>  	int ret;
>  
>  	while (ptr) {
> -		COPYOUT(*ptr);
> +		ret = copy_to_user((void __user *)param, ptr, sizeof(*ptr));
> +		if (ret)
> +			return -EFAULT;
>  		param += sizeof(struct floppy_raw_cmd);
>  		if ((ptr->flags & FD_RAW_READ) && ptr->buffer_length) {
>  			if (ptr->length >= 0 &&
> @@ -3195,7 +3188,9 @@ static inline int raw_cmd_copyin(int cmd
>  		if (!ptr)
>  			return -ENOMEM;
>  		*rcmd = ptr;
> -		COPYIN(*ptr);
> +		ret = copy_from_user(ptr, (void __user *)param, sizeof(*ptr));

Actually the casts are not needed anymore, are they?

-- 
js
