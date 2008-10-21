Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYJUAYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYJUAYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYJUAYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:24:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:21610 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYJUAYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PE0Adjd56paUxeobNpm4H1oUH/kKhU6poCw3pubSWS8jHW79dRucSAsJIe0R+Bw8Do
         fDpcf9HKghih8h+l78qX/us0+FO8agvmXfOynEAMZ2RjNKfZvC/+7846R2iFdHKODnt/
         I8oWGMK37JRBG2uj/uPJK4hyzCeBH1L+mub0A=
Message-ID: <c62985530810201724i6e19441ep59ab42cd488ae1c3@mail.gmail.com>
Date: Tue, 21 Oct 2008 02:24:19 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] sparc: correct section of apc_no_idle
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Sparc <sparclinux@vger.kernel.org>
In-Reply-To: <48FA0AB6.3060505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FA0AB6.3060505@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/18 Frederic Weisbecker <fweisbec@gmail.com>:
> The latest mainline gives this section mismatch on sparc:
>
> The function __devinit apc_probe() references
> a variable __initdata apc_no_idle.
> If apc_no_idle is only used by apc_probe then
> annotate apc_no_idle with a matching annotation.
>
> Since the commit 7e7e2f035663c5ceb029bfb9d91e75099b0a5625,
> apc_probe() is on __devinit so we have to correct apc_no_idle
> which is referenced by this function.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
> index 4dd1ba7..9c11582 100644
> --- a/arch/sparc/kernel/apc.c
> +++ b/arch/sparc/kernel/apc.c
> @@ -31,7 +31,7 @@
>  #define APC_DEVNAME "apc"
>
>  static u8 __iomem *regs;
> -static int apc_no_idle __initdata = 0;
> +static int apc_no_idle __devinitdata = 0;
>
>  #define apc_readb(offs)                (sbus_readb(regs+offs))
>  #define apc_writeb(val, offs)  (sbus_writeb(val, regs+offs))
>

(Adding William and sparclinux in cc)
