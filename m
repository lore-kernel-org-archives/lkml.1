Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZFAIkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZFAIkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZFAIkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:40:03 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:34109 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZFAIkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=B8sxpV0gyFgxVpMDlFOiPWT3MPudRZQgLbmZrogOVXLqG1VNmeLz9q/YVMORdrnseY
         BeZ2sOFOjNxjs8zUXBcS1QfH5uZm2EDEafLxn6jEYU5oiv8DNp9FDKf0bJlfvy+Nrc/W
         6m7pJnjWj+v90SiAec/3bsZ6X8d8ZLtAZzGX0=
Message-ID: <4A2393DE.10300@gmail.com>
Date: Mon, 01 Jun 2009 10:39:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1pre) Gecko/20090525 SUSE/3.0b2-10.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: vibi_sreenivasan@cms.com
CC: Mimi Zohar <zohar@us.ibm.com>, Kylene Hall <kylene@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Reiner Sailer <sailer@watson.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]:RESEND : Return proper error value on failure of dentry_open
References: <1243836708.2163.3.camel@system>  <4A238625.8060002@gmail.com> <1243844849.2327.27.camel@system>
In-Reply-To: <1243844849.2327.27.camel@system>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2009 10:27 AM, vibi sreenivasan wrote:
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -201,10 +201,10 @@ int ima_path_check(struct path *path, int mask)
>  	}
>  out:
>  	mutex_unlock(&iint->mutex);
> -	if (file)
> +	if (!IS_ERR(file))
>  		fput(file);

No, IS_ERR won't catch NULL and there is 'file = NULL' on the
dentry_open fail path. I still think 'if (file)' is proper condition.

What bug did you hit?
