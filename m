Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbZLKAm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbZLKAm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761813AbZLKAmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:42:55 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:52704 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761823AbZLKAmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:42:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q+NBKdnxL86fSgfzsD4mEEC2sDu3N2lgke1GTIUJAd7NXnp0nDrdCuK086ghAJ3CfF
         XGSgJEcmRn1cipLluutqEXPHmKYq7Xhc+7E7st9w7GxtesWgf/egOZTqG5BvHe00nFvY
         Mk+lkRhw8uV3irzKNRVhNdy/kgYgJ8zYjCr4g=
MIME-Version: 1.0
In-Reply-To: <1260466101-17545-4-git-send-email-ddaney@caviumnetworks.com>
References: <4B212EEC.3060808@caviumnetworks.com>
	 <1260466101-17545-4-git-send-email-ddaney@caviumnetworks.com>
Date: Thu, 10 Dec 2009 19:42:59 -0500
Message-ID: <b4198de60912101642u147f4592r9337dd9b7d7c604b@mail.gmail.com>
Subject: Re: [PATCH 4/5] alpha: Convert BUG() to use unreachable()
From: Matt Turner <mattst88@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 12:28 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> Use the new unreachable() macro instead of for(;;);
>
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> CC: Richard Henderson <rth@twiddle.net>
> CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> CC: Matt Turner <mattst88@gmail.com>
> CC: linux-alpha@vger.kernel.org
> ---
>  arch/alpha/include/asm/bug.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/alpha/include/asm/bug.h b/arch/alpha/include/asm/bug.h
> index 1720c8a..f091682 100644
> --- a/arch/alpha/include/asm/bug.h
> +++ b/arch/alpha/include/asm/bug.h
> @@ -13,7 +13,8 @@
>                "call_pal %0  # bugchk\n\t"                             \
>                ".long %1\n\t.8byte %2"                                 \
>                : : "i"(PAL_bugchk), "i"(__LINE__), "i"(__FILE__));     \
> -       for ( ; ; ); } while (0)
> +       unreachable();                                                  \
> +  } while (0)
>
>  #define HAVE_ARCH_BUG
>  #endif
> --
> 1.6.2.5

Thanks David. I've pushed this into my tree.

Matt
