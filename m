Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZEMNDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZEMNDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbZEMNDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:03:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:42565 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790AbZEMNDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uJV7xW3kCPgq7eCdsdYL0+efHyGs4etggIzNehtFzvZbS5hzCqbh+DgfBXu4cAf7gW
         zPgtXzWgqlmqrrBLFOOlVovVAM8v+HcNXaHgdZ2xsoUJFqAzid83WF2I7NMpiqgkD9cS
         QUhFZjywWEvBPXDfBsPdqjvsD2twZlg4Lh67o=
MIME-Version: 1.0
In-Reply-To: <1242205213-27452-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1242205213-27452-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Wed, 13 May 2009 18:33:12 +0530
Message-ID: <921ca19c0905130603g3823b213vdb2b62b75934104d@mail.gmail.com>
Subject: Re: [PATCH] ARM: __builtin_return_address works with argument 0
From: Sujit Karataparambil <sjt.kar@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These seem to be required too. Mostly for optimizations the compiler can
provide. Seem to be supported in gnu.

__builtin_clz
__builtin_constant_p
__builtin_expect
__builtin_frame_address

http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0376a/Caceiddh.html



2009/5/13 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> This saves the function overhead for CALLER_ADDRESS0.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
> Hi Thomas,
>
> this applies to .29.3-rt12.  Feel free to squash this into
> arm-tracing-updates.patch.
>
> Best regards
> Uwe
>
>  arch/arm/include/asm/ftrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
> index 900fc19..f7e8bac 100644
> --- a/arch/arm/include/asm/ftrace.h
> +++ b/arch/arm/include/asm/ftrace.h
> @@ -15,7 +15,7 @@ extern void mcount(void);
>  void *return_address(unsigned int);
>
>  #define HAVE_ARCH_CALLER_ADDR
> -#define CALLER_ADDR0 ((unsigned long)return_address(0))
> +#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
>  #define CALLER_ADDR1 ((unsigned long)return_address(1))
>  #define CALLER_ADDR2 ((unsigned long)return_address(2))
>  #define CALLER_ADDR3 ((unsigned long)return_address(3))
> --
> 1.6.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
-- Sujit K M
