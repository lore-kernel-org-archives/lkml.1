Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZFAHle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZFAHle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFAHl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:41:26 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:33840 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZFAHl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cpeVmxdSznCCdoJoLJNc0Q0YFxGLEkWbFTGtYmb7vwoPsu0/wJqdWa5fdapJTXf2qJ
         GtBgAuMOfOI7dsvUsGKWfBBuCfYg+gvz3ReRfXRv2c99318mjb8vWGL8PCVfQC3xyrUL
         s2p0xjrRs6dxSr2GVAUzyIpcZlIeHWUmB4t94=
Message-ID: <4A238625.8060002@gmail.com>
Date: Mon, 01 Jun 2009 09:41:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1pre) Gecko/20090525 SUSE/3.0b2-10.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: vibi_sreenivasan@cms.com
CC: Mimi Zohar <zohar@us.ibm.com>, Kylene Hall <kylene@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Reiner Sailer <sailer@watson.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]:Return proper error value on failure of dentry_open
References: <1243836708.2163.3.camel@system>
In-Reply-To: <1243836708.2163.3.camel@system>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2009 08:11 AM, vibi sreenivasan wrote:
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -201,10 +201,10 @@ int ima_path_check(struct path *path, int mask)
>  	}
>  out:
>  	mutex_unlock(&iint->mutex);
> -	if (file)
> +	if (IS_ERR(file))
>  		fput(file);

This makes no sense at all. If it is IS_ERR, i.e. some negative value,
you don't want to pass it to fput. 'if (file)' was perfectly correct.
