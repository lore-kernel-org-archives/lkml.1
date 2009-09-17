Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZIQCMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZIQCMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbZIQCMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:12:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.221.181]:51560 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZIQCMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xJGkiZJrQAUmESWSYDza7XL4MDLvM93Dfo6882u4GHI8pqAyzed+Z5Xjmrua1X9ofy
         3MOuH2mAwREj9ZcKsr/KvStdWnxbbYRbTAhG7+9MdCyabR8NMkcYdtXF9QC4JlVbNBJt
         J2dq/iVdOYAP86/simnFt2Ld0XRZAMfHzj6RA=
MIME-Version: 1.0
In-Reply-To: <1253137123-18047-3-git-send-email-felipe.contreras@gmail.com>
References: <1253137123-18047-1-git-send-email-felipe.contreras@gmail.com>
	 <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com>
	 <1253137123-18047-3-git-send-email-felipe.contreras@gmail.com>
Date: Thu, 17 Sep 2009 10:12:07 +0800
Message-ID: <2375c9f90909161912g5987ba0ayd2d9cb5e61d2253f@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] kbuild: fix warning when domainname is not 
	available
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 5:38 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> Otherwise we get:
> "dnsdomainname: Unknown host"
>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

> ---
>  scripts/mkcompile_h |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
> index 6a12dd9..f060763 100755
> --- a/scripts/mkcompile_h
> +++ b/scripts/mkcompile_h
> @@ -66,9 +66,13 @@ UTS_TRUNCATE="sed -e s/\(.\{1,$UTS_LEN\}\).*/\1/"
>   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
>
>   if [ -x /bin/dnsdomainname ]; then
> -    echo \#define LINUX_COMPILE_DOMAIN \"`dnsdomainname | $UTS_TRUNCATE`\"
> +    domain=`dnsdomainname 2> /dev/null`
>   elif [ -x /bin/domainname ]; then
> -    echo \#define LINUX_COMPILE_DOMAIN \"`domainname | $UTS_TRUNCATE`\"
> +    domain=`domainname 2> /dev/null`
> +  fi
> +
> +  if [ -n "$domain" ]; then
> +    echo \#define LINUX_COMPILE_DOMAIN \"`echo $domain | $UTS_TRUNCATE`\"
>   else
>     echo \#define LINUX_COMPILE_DOMAIN
>   fi
> --
> 1.6.5.rc1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
