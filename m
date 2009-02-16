Return-Path: <linux-kernel-owner+w=401wt.eu-S1751414AbZBPPNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbZBPPNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbZBPPNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:13:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:31204 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZBPPNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:13:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eAvDUaPDzC6ru5lXGJ9qrrGT4LJF9Q6qTFAWz00uBBOK2dixYL1WzwviwVTnFsRmN+
         ss6aK3RG+quiCX5CAiu05BnJp1K1EaAPActttJP5sBCQBP6zmNtMvjvjgzlblOlb/Wv9
         rauDVUvjC5JtoDh4cXNA3Djg6/+AKNuMDgoDc=
MIME-Version: 1.0
In-Reply-To: <20090216144725.976425091@cmpxchg.org>
References: <20090216142926.440561506@cmpxchg.org>
	 <20090216144725.976425091@cmpxchg.org>
Date: Mon, 16 Feb 2009 17:13:30 +0200
X-Google-Sender-Auth: 8fc0c252241d74c5
Message-ID: <84144f020902160713y7341b2b4g8aa10919405ab82d@mail.gmail.com>
Subject: Re: [patch 6/8] cifs: use kzfree()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Mon, Feb 16, 2009 at 4:29 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> @@ -2433,11 +2433,8 @@ mount_fail_check:
>  out:
>        /* zero out password before freeing */
>        if (volume_info) {
> -               if (volume_info->password != NULL) {
> -                       memset(volume_info->password, 0,
> -                               strlen(volume_info->password));
> -                       kfree(volume_info->password);
> -               }
> +               if (volume_info->password != NULL)
> +                       kzfree(volume_info->password);

The NULL check here is unnecessary.

>                kfree(volume_info->UNC);
>                kfree(volume_info->prepath);
>                kfree(volume_info);
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -97,10 +97,8 @@ sesInfoFree(struct cifsSesInfo *buf_to_f
>        kfree(buf_to_free->serverOS);
>        kfree(buf_to_free->serverDomain);
>        kfree(buf_to_free->serverNOS);
> -       if (buf_to_free->password) {
> -               memset(buf_to_free->password, 0, strlen(buf_to_free->password));
> -               kfree(buf_to_free->password);
> -       }
> +       if (buf_to_free->password)
> +               kzfree(buf_to_free->password);

And here.

>        kfree(buf_to_free->domainName);
>        kfree(buf_to_free);
>  }
> @@ -132,10 +130,8 @@ tconInfoFree(struct cifsTconInfo *buf_to
>        }
>        atomic_dec(&tconInfoAllocCount);
>        kfree(buf_to_free->nativeFileSystem);
> -       if (buf_to_free->password) {
> -               memset(buf_to_free->password, 0, strlen(buf_to_free->password));
> -               kfree(buf_to_free->password);
> -       }
> +       if (buf_to_free->password)
> +               kzfree(buf_to_free->password);
>        kfree(buf_to_free);
>  }
>
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
